//
//  ZDPolygonView.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/6/1.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ZDPolygonView.h"
#import <pop/POP.h>
#import "ZDFunction.h"

@interface ZDPolygonView ()
@property(nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation ZDPolygonView

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
  [self setupUI];
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];

  [self setupUI];
}

- (void)setupUI {
  if (CGRectEqualToRect(self.frame, CGRectZero)) return;

  self.duration = self.duration ?: .8;

  CGFloat width = 100;

  CAShapeLayer *subShapeLayer1 = ({
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    __unused CGFloat dx = 20.f;
    CGFloat width1 = width * 0.8;
    CGRect frame = (CGRect){0, 0, width1, width1};
    // CGRectInset(superShapeLayer.bounds, dx, dx);
    shapeLayer.frame = frame;
    shapeLayer.position = self.center;
    shapeLayer.path = [self drawPolygonViewWithWidth:frame.size.width].CGPath;
    shapeLayer.lineCap = kCALineCapButt;
    shapeLayer.fillColor = [UIColor blueColor].CGColor;
    shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    shapeLayer;
  });

  CAShapeLayer *subShapeLayer2 = ({
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    __unused CGFloat dx = 40.f;
    CGFloat width2 = width * 0.5;
    CGRect frame = (CGRect){0, 0, width2, width2};
    // CGRectInset(superShapeLayer.bounds, dx, dx);
    shapeLayer.frame = frame;
    shapeLayer.position = self.center;
    shapeLayer.path = [self drawPolygonViewWithWidth:frame.size.width].CGPath;
    shapeLayer.lineCap = kCALineCapButt;
    shapeLayer.fillColor = [UIColor yellowColor].CGColor;
    shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    shapeLayer;
  });

  [self.layer addSublayer:self.shapeLayer];
  [self.layer addSublayer:subShapeLayer1];
  [self.layer addSublayer:subShapeLayer2];
}

#pragma mark - Protocol

- (void)startAnimation {
  self.shapeLayer.opacity = 1.f;

  CFAbsoluteTime beginTime = CFAbsoluteTimeGetCurrent();

  POPBasicAnimation *animation1 = ({
    POPBasicAnimation *animation =
        [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSubscaleXY];
    animation.fromValue = [NSValue valueWithCGSize:(CGSize){0, 0}];
    CGFloat scale =
        ceil(MAX(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) / (100 * 0.5 * 0.5)) *
        1.2;  // 0.5是最小多边形是原图的几分之几,还有一个是内部颜色占整体的几分之几
    animation.toValue = [NSValue valueWithCGSize:(CGSize){scale, scale}];
    animation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = _duration;
    animation.removedOnCompletion = YES;
    animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
      if (finished) {
        self.shapeLayer.opacity = 0.f;
        [self removeFromSuperview];

        CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
        NSLog(@"动画用时：%f", endTime - beginTime);
      };
    };
    animation;
  });
  [self.layer pop_addAnimation:animation1 forKey:@"ZDShapeScale1"];
}

- (CAShapeLayer *)shapeLayer {
  if (!_shapeLayer) {
    CGFloat width = 100;

    CAShapeLayer *superShapeLayer = ({
      CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
      // shapeLayer.backgroundColor = [UIColor cyanColor].CGColor;
      shapeLayer.frame = (CGRect){0, 0, width, width};
      shapeLayer.position = self.center;
      shapeLayer.path = [self drawPolygonViewWithWidth:width].CGPath;
      shapeLayer.lineCap = kCALineCapButt;
      shapeLayer.fillColor = [UIColor orangeColor].CGColor;
      shapeLayer.strokeColor = [UIColor clearColor].CGColor;
      shapeLayer;
    });

    _shapeLayer = superShapeLayer;
  }

  return _shapeLayer;
}

// 下面是100*100大小的多边形
- (UIBezierPath *)drawPolygonViewWithWidth:(CGFloat)width {
  CGFloat scale = width / 100.0;

  //! Polygon
  UIBezierPath *polygon = [UIBezierPath bezierPath];
  [polygon moveToPoint:ZD_PointScale(CGPointMake(25, 0), scale)];
  [polygon addLineToPoint:ZD_PointScale(CGPointMake(49.99, 25), scale)];
  [polygon addLineToPoint:ZD_PointScale(CGPointMake(74.54, 0), scale)];
  [polygon addLineToPoint:ZD_PointScale(CGPointMake(100, 25), scale)];
  [polygon addLineToPoint:ZD_PointScale(CGPointMake(75, 50), scale)];
  [polygon addLineToPoint:ZD_PointScale(CGPointMake(100, 75), scale)];
  [polygon addLineToPoint:ZD_PointScale(CGPointMake(75, 100), scale)];
  [polygon addLineToPoint:ZD_PointScale(CGPointMake(49.99, 75), scale)];
  [polygon addLineToPoint:ZD_PointScale(CGPointMake(25, 100), scale)];
  [polygon addLineToPoint:ZD_PointScale(CGPointMake(0, 75), scale)];
  [polygon addLineToPoint:ZD_PointScale(CGPointMake(25, 50), scale)];
  [polygon addLineToPoint:ZD_PointScale(CGPointMake(0, 25), scale)];
  [polygon addLineToPoint:ZD_PointScale(CGPointMake(25, 0), scale)];
  [polygon closePath];

  return polygon;
}

@end
