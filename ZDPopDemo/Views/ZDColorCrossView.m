//
//  ZDColorCrossView.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/27.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ZDColorCrossView.h"
#import <pop/POP.h>
#import "ZDFunction.h"

@interface ZDColorCrossView () <CAAnimationDelegate>
@property(nonatomic, strong) NSMutableArray<ZDCrossLayer *> *subLayerArr;
@end

@implementation ZDColorCrossView

- (void)dealloc {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setup];
  }
  return self;
}

- (void)setup {
  self.clipsToBounds = YES;
  self.backgroundColor = RandomColor();
  [self setupUI];
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];

  [self setupUI];
}

- (void)setupUI {
  if (CGRectEqualToRect(self.frame, CGRectZero)) return;

  self.duration = self.duration ?: 2.5;

  CGFloat lineWidth = [ZDCrossLayer lineWidth];

  // 不大于x的最大整数个
  NSUInteger crossCount = floor(CGRectGetWidth(self.frame) / 2.0 / lineWidth);

  CGFloat crossWidth = CGRectGetWidth(self.frame) * 2;
  CGFloat crossHeight = CGRectGetHeight(self.frame) * 2;

  if (!self.subLayerArr) {
    self.subLayerArr = @[].mutableCopy;
  } else {
    [self.subLayerArr removeAllObjects];
  }

  // 默认情况下所有的子图层的中心都在原点处，并且子图层的size是父视图的2倍
  // 在执行动画时每个子图层的中心再跳跃到要到达的位置
  for (NSUInteger i = 0; i < crossCount; i++) {
    ZDCrossLayer *layer = [[ZDCrossLayer alloc] init];
    layer.frame = (CGRect){-crossWidth / 2.0 - lineWidth, -crossHeight / 2.0 - lineWidth,
                           crossWidth, crossHeight};
    layer.crossColor = RandomColor();
    [self.layer addSublayer:layer];

    [self.subLayerArr addObject:layer];
  }
}

#pragma mark - Protocol

- (void)startAnimation {
  NSParameterAssert(self.subLayerArr.count > 0);
  if (self.subLayerArr.count == 0) return;

  NSUInteger layerCount = self.subLayerArr.count;
  // CFTimeInterval interval = self.duration / 3.0 * 2 / layerCount;
  CGFloat lineWidth = [ZDCrossLayer lineWidth];

  [self.subLayerArr enumerateObjectsUsingBlock:^(ZDCrossLayer *_Nonnull obj, NSUInteger idx,
                                                 BOOL *_Nonnull stop) {
    CAKeyframeAnimation *keyFrameAnimation = ({
      CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
      keyAnimation.timingFunction =
          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
      keyAnimation.fillMode = kCAFillModeForwards;
      keyAnimation.calculationMode = kCAAnimationDiscrete;  //离散动画
      keyAnimation.removedOnCompletion = NO;
      CGPoint fromPoint = obj.position;
      keyAnimation.path = [self drawPathfromPoint:fromPoint
                                          toPoint:(CGPoint){fromPoint.x + lineWidth * (idx + 1),
                                                            fromPoint.y + lineWidth * (idx + 1)}]
                              .CGPath;
      keyAnimation.duration = [self interval];
      keyAnimation.beginTime = CACurrentMediaTime() + [self interval] * idx;
      if (idx == (layerCount - 1)) {
        keyAnimation.delegate = self;
      }
      keyAnimation;
    });

    [obj addAnimation:keyFrameAnimation forKey:nil];
  }];
}

- (UIBezierPath *)drawPathfromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
  UIBezierPath *path = [UIBezierPath bezierPath];
  [path moveToPoint:fromPoint];
  [path addLineToPoint:toPoint];
  [path closePath];
  return path;
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if (!flag) return;

  // 最后一个keyframeAnimation动画执行完毕后，执行下面的放大动画.然后当放大动画执行完毕后移除视图
  if ([anim isKindOfClass:[CAKeyframeAnimation class]]) {
    CABasicAnimation *animation = ({
      CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
      animation.timingFunction =
          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
      animation.fillMode = kCAFillModeForwards;
      animation.duration = [self lastLayerDuration];
      double scale = ceil(CGRectGetWidth(self.frame) / [ZDCrossLayer lineWidth]) * 1.5;
      animation.toValue = @(scale);
      animation.delegate = self;
      animation;
    });

    [self.subLayerArr.lastObject addAnimation:animation forKey:@"MD_ScaleAnimation"];
  } else if ([anim isKindOfClass:[CABasicAnimation class]]) {
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
    [self removeFromSuperview];
  }
}

#pragma mark - Private Method

- (CFTimeInterval)interval {
  return self.duration / 3.0 * 2 / self.subLayerArr.count;
}

- (CFTimeInterval)lastLayerDuration {
  return self.duration / 3.0;
}

@end

#pragma mark - 自定义Layer
#pragma mark -

CGFloat const kLineWidth = 20.0;

@interface ZDCrossLayer ()
@property(nonatomic, strong) CAShapeLayer *hShape;
@property(nonatomic, strong) CAShapeLayer *vShape;
@end

@implementation ZDCrossLayer

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];

  [self setupUI];
}

- (void)setup {
  [self setupUI];
}

- (void)setupUI {
  if (CGRectEqualToRect(self.frame, CGRectZero)) return;

  self.backgroundColor = [UIColor clearColor].CGColor;

  CGFloat w = CGRectGetWidth(self.frame);
  CGFloat h = CGRectGetHeight(self.frame);

  CGFloat lineWidth = [self.class lineWidth];
  CAShapeLayer *hShape = ({
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = lineWidth;
    layer.frame = (CGRect){0, (h / 2 - lineWidth / 2), w, lineWidth};
    layer.path = [UIBezierPath bezierPathWithRect:layer.bounds].CGPath;
    layer.masksToBounds = YES;
    layer;
  });
  CAShapeLayer *vShape = ({
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = [self.class lineWidth];
    layer.frame = (CGRect){(w / 2 - lineWidth / 2), 0, lineWidth, h};
    layer.path = [UIBezierPath bezierPathWithRect:layer.bounds].CGPath;
    layer.masksToBounds = YES;
    layer;
  });
  self.hShape = hShape;
  self.vShape = vShape;

  [self addSublayer:hShape];
  [self addSublayer:vShape];
}

#pragma mark - Public Method

- (void)setCrossColor:(UIColor *)color {
  if (!color) return;

  self.hShape.strokeColor = color.CGColor;
  self.vShape.strokeColor = color.CGColor;
}

+ (CGFloat)lineWidth {
  CGFloat lineWidth = ScreenSize().width / 414.0 * kLineWidth;
  return lineWidth;
}

- (void)startAnimationWithDuration:(NSTimeInterval)duration {
  POPBasicAnimation *animation =
      [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerLineWidth];
  animation.fromValue = @([self.class lineWidth]);
  CGFloat toValue = MAX(CGRectGetWidth(self.bounds) / 4.0, CGRectGetHeight(self.bounds) / 4.0);
  animation.toValue = @(toValue);
  animation.duration = duration;
  animation.removedOnCompletion = YES;

  NSString *animationKey = @"ZD_ScaleLineWidthAnimation";
  [self.hShape pop_addAnimation:animation forKey:animationKey];
  [self.vShape pop_addAnimation:animation forKey:animationKey];
}

@end
