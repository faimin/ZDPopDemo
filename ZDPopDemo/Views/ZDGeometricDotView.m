//
//  ZDGeometricDotView.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/24.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ZDGeometricDotView.h"
#import <pop/POPBasicAnimation.h>
#import "ZDFunction.h"

static NSString *const KeyPath = @"strokeEnd";

static CGFloat const kRatio = (1.0 / 15.0f);  ///< 小圆直径占对角线的比例
static CGFloat const kScale = 0.8f;  ///< 实心矩形与对角线的交点长度是对角线长度的几分之几
static CGFloat const kXOffset = 20.f;            ///< 矩形x坐标相对于对角线的偏移量
static CGFloat const kLineWidth = 5.f;           ///< 线的宽度
static CGFloat const kDotMargin = 50.0f;         ///< 点点之间的横向间距
static NSUInteger const kAnimationCount = 10.0;  ///< 动画执行次数

typedef NS_ENUM(NSUInteger, DotLineDisplayType) {
  DotLineDisplayType_HideAll = 0,       ///< 隐藏全部点点
  DotLineDisplayType_HidelMiddleLines,  ///< 隐藏中间行
  DotLineDisplayType_ShowAll,           ///< 展示全部点点
};

@interface ZDGeometricDotView ()
@property(nonatomic, strong) NSArray<CAShapeLayer *> *diagonalShapeArray;  ///< 四条对角线数组
@property(nonatomic, strong) NSMutableArray<NSArray<CAShapeLayer *> *>
    *dotLineShapeArray;  ///< 装有点矩阵的二维数组，每一条线上的所有点也是一个数组
@property(nonatomic, assign) CGFloat lineVerticalMargin;          ///< 点点之间的纵向距离
@property(nonatomic, strong) CAShapeLayer *hollowRectangleLayer;  ///< 空心矩形
@property(nonatomic, strong) CAShapeLayer *solidRectangleLayer;   ///< 实心矩形
@end

@implementation ZDGeometricDotView

- (void)dealloc {
  NSLog(@"%s", __PRETTY_FUNCTION__);
  [self.diagonalShapeArray.firstObject removeObserver:self forKeyPath:KeyPath];
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setup];
  }
  return self;
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];

  [self setup];
}

- (void)setup {
  self.duration = self.duration ?: 6.5;
  [self setupUI];
}

- (void)setupUI {
  if (CGRectEqualToRect(self.frame, CGRectZero)) return;
  if (self.layer.sublayers.count > 0) {
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
  }

  [self addShapePath];
}

- (void)addShapePath {
  if (CGRectEqualToRect(self.frame, CGRectZero)) return;

  //--------------------对角线-----------------------------
  CGFloat selfWidth = CGRectGetWidth(self.frame);
  CGFloat selfHeight = CGRectGetHeight(self.frame);

  CGFloat aRatio1 = (0.5 - kRatio);
  CGFloat aRatio2 = 1 - aRatio1;  //(0.5 + ratio / 2); //半径比例 + 一个半圆所占比例
  CGFloat shapeLWidth = selfWidth * aRatio1;
  CGFloat shapeLHeight = selfHeight * aRatio1;
  CGSize shapeLSize = (CGSize){shapeLWidth, shapeLHeight};

  // 左上角
  CAShapeLayer *leftTop = [self shapeLayerWithFrame:(CGRect){CGPointZero, shapeLSize}];
  leftTop.path = [self lineBezierPathFrom:CGPointZero to:ZD_RightBottomPoint(leftTop.frame)].CGPath;

  // 右上角
  CAShapeLayer *rightTop = [self shapeLayerWithFrame:(CGRect){selfWidth * aRatio2, 0, shapeLSize}];
  rightTop.path = [self lineBezierPathFrom:ZD_RightTopPoint(rightTop.bounds)
                                        to:ZD_LeftBottomPoint(rightTop.bounds)]
                      .CGPath;

  // 左下角
  CAShapeLayer *leftBottom =
      [self shapeLayerWithFrame:(CGRect){0, selfHeight * aRatio2, shapeLSize}];
  leftBottom.path = [self lineBezierPathFrom:ZD_LeftBottomPoint(leftBottom.bounds)
                                          to:ZD_RightTopPoint(leftBottom.bounds)]
                        .CGPath;

  // 右下角
  CAShapeLayer *rightBottom =
      [self shapeLayerWithFrame:(CGRect){selfWidth * aRatio2, selfHeight * aRatio2, shapeLSize}];
  rightBottom.path = [self lineBezierPathFrom:ZD_RightBottomPoint(rightBottom.bounds)
                                           to:ZD_LeftTopPoint(rightBottom.bounds)]
                         .CGPath;

  self.diagonalShapeArray = @[ leftTop, rightTop, leftBottom, rightBottom ];

  for (CAShapeLayer *layer in self.diagonalShapeArray) {
    layer.strokeEnd = 0.f;
    [self.layer addSublayer:layer];
  }

  //--------------------空心矩形-----------------------------

  [self hollowRectangle];

  //--------------------点矩阵-----------------------------

  [self dotRectangle];

  //--------------------实心矩阵-----------------------------

  [self solidRectangle];

  // 监听对角线的变化
  [self setupObserver];
}

- (void)setupObserver {
  CAShapeLayer *leftTopShape = self.diagonalShapeArray.firstObject;
  // KVO
  [leftTopShape addObserver:self
                 forKeyPath:KeyPath
                    options:NSKeyValueObservingOptionNew
                    context:nil];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
  if ([keyPath isEqualToString:KeyPath]) {
    CGFloat end = [change[NSKeyValueChangeNewKey] floatValue];
    // 对角线到达其kScale比例的地方显示出来空心矩形
    if (end >= kScale && end < 1) {
      self.hollowRectangleLayer.hidden = NO;
    }
    // 对角线画完之后隐藏，然后展示空心矩形和点点
    else if (end == 1.0) {
      // 这里的操作在对角线动画结束的block中执行
    }
  }
}

#pragma mark - Public Method

- (void)startAnimation {
#if __has_include("ZDPopViewController.h")  // DEBUG用的
  for (CAShapeLayer *shapeLayer in self.diagonalShapeArray) {
    shapeLayer.hidden = NO;
    shapeLayer.strokeEnd = 0.f;
  }
#endif

  // 展示点点视图
  void (^displayDotBlock)() = ^() {
    // 显示所有点点矩阵
    [self displayDotLine:DotLineDisplayType_ShowAll];

    // 隐藏空心矩形，显示实心矩形
    NSTimeInterval averageInterval = self.duration / kAnimationCount;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(averageInterval * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                     self.hollowRectangleLayer.hidden = YES;
                     self.solidRectangleLayer.hidden = NO;
                   });

    // 隐藏点点
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(averageInterval * 2 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                     [self displayDotLine:DotLineDisplayType_HideAll];
                   });

    // 实心矩形变色
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(averageInterval * 3 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                     self.solidRectangleLayer.fillColor = RandomColor().CGColor;
                     self.solidRectangleLayer.strokeColor = self.solidRectangleLayer.fillColor;
                     self.backgroundColor = RandomColor();
                   });

    // 点点上下边出来
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(averageInterval * 4 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                     [self displayDotLine:DotLineDisplayType_HidelMiddleLines
                                 dotColor:self.solidRectangleLayer.fillColor];
                   });

    // 实心矩形消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(averageInterval * 5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                     self.solidRectangleLayer.hidden = YES;
                   });

    // 最后点点消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(averageInterval * 6 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                     [self displayDotLine:DotLineDisplayType_HideAll];
                   });
  };

  [self.diagonalShapeArray enumerateObjectsUsingBlock:^(CAShapeLayer *_Nonnull layer,
                                                        NSUInteger idx, BOOL *_Nonnull stop) {
    POPBasicAnimation *animation = ({
      POPBasicAnimation *animation =
          [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
      animation.fromValue = @0.f;
      animation.toValue = @1.f;
      animation.duration = self.duration / kAnimationCount * 3;
      // animation.removedOnCompletion = YES;
      animation;
    });
    animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
      // 动画结束后四个对角线隐藏，然后点点矩阵显示
      if (finished) {
        layer.hidden = YES;

        // 展示的block执行一次就可以了
        if (idx == 0) displayDotBlock();
      }
    };

    [layer pop_addAnimation:animation forKey:@"ZD_ShapeLayerStrokeAnimation"];
  }];
}

#pragma mark - ShapeLayer

// 空心矩形(与对角线交叉的那个)
- (void)hollowRectangle {
  CGPoint point =
      ZD_PointScale(ZD_RightBottomPoint(self.diagonalShapeArray.firstObject.frame), kScale);
  CGFloat x = point.x - kXOffset;
  CGFloat y = point.y;
  CGFloat width = CGRectGetWidth(self.frame) - x * 2;
  CGFloat height = CGRectGetHeight(self.frame) - y * 2;

  CAShapeLayer *rectangle = [self shapeLayerWithFrame:(CGRect){x, y, width, height}];
  rectangle.path = [UIBezierPath bezierPathWithRect:rectangle.bounds].CGPath;
  rectangle.backgroundColor = [UIColor clearColor].CGColor;
  rectangle.hidden = YES;
  [self.layer addSublayer:rectangle];

  self.hollowRectangleLayer = rectangle;
}

// 点矩阵(用画圈圈实现)
- (void)dotRectangle {
  // MARK:修改圆点大小
  CGFloat customLineWidth = 3.0f;  // 通过修改这个值来改变点点的大小
  CGPoint point = ZD_PointScale(ZD_RightBottomPoint(self.diagonalShapeArray[0].frame), kScale);
  CGFloat x = (point.x - kXOffset) - 20.0;        // x坐标相对于矩形坐标还得左移
  CGFloat y = point.y + (customLineWidth / 2.0);  // y坐标相对于矩形坐标下移一点点
  CGFloat width = CGRectGetWidth(self.frame) - x * 2;    // 点矩阵的宽度
  CGFloat height = CGRectGetHeight(self.frame) - y * 2;  // 点矩阵的高度

  CGSize circleDotSize = (CGSize){customLineWidth, customLineWidth};   // 点点size
  CGFloat circleRadius = customLineWidth / 2.0;                        // 圆半径
  NSUInteger lineCount = 4;                                            // 一共有几条线
  CGFloat lineHMargin = kDotMargin;                                    // 点之间的横向间距
  CGFloat lineVMargin = (height - customLineWidth) / (lineCount - 1);  // 点之间的纵向距离
  self.lineVerticalMargin = lineVMargin;
  NSUInteger dotCountInLine = ceil(width / lineHMargin);  // 每行点点的个数

  NSMutableArray<NSArray<CAShapeLayer *> *> *dotLineShapeArray =
      @[].mutableCopy;  // 二维数组,元素为每一行的点数组
  for (NSUInteger i = 0; i < lineCount; i++) {
    @autoreleasepool {
      NSMutableArray<CAShapeLayer *> *dotShapes = @[].mutableCopy;
      for (NSUInteger j = 0; j < dotCountInLine; j++) {
        CGPoint linePoint = (CGPoint){x + lineHMargin * j, y + lineVMargin * i};
        CAShapeLayer *dashLine = [self shapeLayerWithFrame:(CGRect){linePoint, circleDotSize}];
        dashLine.lineWidth = customLineWidth;
        CGPoint center =
            (CGPoint){dashLine.frame.size.width / 2.0, dashLine.frame.size.height / 2.0};
        dashLine.path = [UIBezierPath bezierPathWithArcCenter:center
                                                       radius:circleRadius
                                                   startAngle:0
                                                     endAngle:(M_PI * 2)
                                                    clockwise:YES]
                            .CGPath;
        dashLine.backgroundColor = [UIColor clearColor].CGColor;
        dashLine.hidden = YES;

        // 把dotShapeLayer添加到里层数组
        [dotShapes addObject:dashLine];

        // dotShapeLayer添加到视图
        [self.layer addSublayer:dashLine];
      }
      [dotLineShapeArray addObject:dotShapes];
    }
  }

  self.dotLineShapeArray = dotLineShapeArray;
}

// 实心矩形
- (void)solidRectangle {
  // 拿到第二行第一个点的坐标
  NSArray<CAShapeLayer *> *shapeLayers1 = self.dotLineShapeArray[1];  // 第二行点点数组
  CGPoint point = shapeLayers1.firstObject.frame.origin;
  CGFloat x = point.x - kDotMargin;
  CGFloat y = point.y;
  CGFloat width = CGRectGetWidth(self.frame) - x * 2;
  CGFloat height = CGRectGetHeight(self.frame) - y * 2;

  CAShapeLayer *rectangle = [self shapeLayerWithFrame:(CGRect){x, y, width, height}];
  rectangle.backgroundColor = [UIColor clearColor].CGColor;
  rectangle.path = [UIBezierPath bezierPathWithRect:rectangle.bounds].CGPath;
  rectangle.fillColor = [UIColor blueColor].CGColor;
  rectangle.hidden = YES;
  [self.layer addSublayer:rectangle];

  self.solidRectangleLayer = rectangle;
}

#pragma mark - Common Method

- (CAShapeLayer *)shapeLayerWithFrame:(CGRect)aFrame {
  CAShapeLayer *shapeLayer = ({
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    // shapeLayer.backgroundColor = RandomColor().CGColor;
    shapeLayer.frame = aFrame;
    shapeLayer.lineCap = kCALineCapButt;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    shapeLayer.lineWidth = kLineWidth;
    shapeLayer.strokeStart = 0.f;
    // shapeLayer.strokeEnd = 0.f;
    shapeLayer;
  });

  return shapeLayer;
}

#pragma mark - BezierPath

// 画线
- (UIBezierPath *)lineBezierPathFrom:(CGPoint)fromePoint to:(CGPoint)toPoint {
  UIBezierPath *path = [UIBezierPath bezierPath];
  [path moveToPoint:fromePoint];
  [path addLineToPoint:toPoint];
  path.lineWidth = kLineWidth;
  return path;
}

#pragma mark - Private Method

- (void)displayDotLine:(DotLineDisplayType)type {
  [self displayDotLine:type dotColor:[UIColor blueColor].CGColor];
}

- (void)displayDotLine:(DotLineDisplayType)type dotColor:(CGColorRef)dotColor {
  [self.dotLineShapeArray enumerateObjectsUsingBlock:^(NSArray<CAShapeLayer *> *_Nonnull obj,
                                                       NSUInteger idx, BOOL *_Nonnull stop) {
    switch (type) {
      case DotLineDisplayType_HideAll: {
        for (CAShapeLayer *layer in obj) {
          // layer.backgroundColor = dotColor;
          layer.hidden = YES;
        }
      } break;

      case DotLineDisplayType_HidelMiddleLines:  // 隐藏中间2行
      {
        for (CAShapeLayer *layer in obj) {
          layer.strokeColor = dotColor;
          layer.hidden = (idx > 0 && idx < 3);
        }
      } break;

      case DotLineDisplayType_ShowAll: {
        for (CAShapeLayer *layer in obj) {
          layer.strokeColor = dotColor;
          layer.hidden = NO;
        }
      } break;
      default:
        break;
    }
  }];
}

- (void)changeDotLineColor:(UIColor *)color {
  if (!color) return;

  [self.dotLineShapeArray enumerateObjectsUsingBlock:^(NSArray<CAShapeLayer *> *_Nonnull obj,
                                                       NSUInteger idx, BOOL *_Nonnull stop) {
    [obj makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:color];
  }];
}

//#pragma mark - 三角函数
//
///// 对角线长度
//- (CGFloat)diagonalLength {
//    CGSize size = self.frame.size;
//    CGFloat l = hypotf(size.width, size.height);    ///< 三角形对角线长度
//    return l;
//}

// 点矩阵(用虚线实现)
- (void)dotRectangleXXXX __unused {
  CGFloat customLineWidth = 4.0f;
  CGPoint point =
      ZD_PointScale(ZD_RightBottomPoint(self.diagonalShapeArray.firstObject.frame), kScale);
  CGFloat x = (point.x - kXOffset) - 30.0;        // x坐标相对于矩形坐标还得左移
  CGFloat y = point.y + (customLineWidth / 2.0);  // y坐标相对于矩形坐标下移一点点
  CGFloat width = CGRectGetWidth(self.frame) - x * 2;
  CGFloat height = CGRectGetHeight(self.frame) - y * 2;

  NSUInteger lineCount = 4;
  CGFloat lineMargin = (height - customLineWidth / 2.0) / (lineCount - 1);

  for (NSUInteger i = 0; i < 4; i++) {
    CAShapeLayer *dashLine =
        [self shapeLayerWithFrame:(CGRect){x, y + lineMargin * i, width, height}];
    dashLine.lineWidth = customLineWidth;
    dashLine.path = ({
                      UIBezierPath *path = [UIBezierPath bezierPath];
                      [path moveToPoint:CGPointZero];
                      [path addLineToPoint:(CGPoint){CGRectGetMaxX(dashLine.bounds),
                                                     CGRectGetMinY(dashLine.bounds)}];
                      path;
                    }).CGPath;
    dashLine.lineDashPattern = @[ @(customLineWidth), @(kDotMargin) ];
    dashLine.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:dashLine];
  }
}

@end
