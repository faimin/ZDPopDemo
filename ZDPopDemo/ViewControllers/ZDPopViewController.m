//
//  ZDPopViewController.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/9.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ZDPopViewController.h"
#import <pop/POP.h>
#import "ZDAnimations.h"
#import "ZDFunction.h"

@interface ZDPopViewController () <POPAnimationDelegate, CAAnimationDelegate>
@property(nonatomic, strong) UILabel *label;
@end

@implementation ZDPopViewController

- (void)dealloc {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self setup];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)setup {
  [self ui];
  //[self animation];
}

- (void)ui {
  [self.view addSubview:self.label];
}

- (void)animation {
  [self.label.layer pop_removeAllAnimations];

  [self createAnimationWithType:4];
}

- (void)createAnimationWithType:(ZDAnimationType)type {
  switch (type) {
    case 0:  // 围绕X轴旋转
    {
      CFTimeInterval duration = 0.8;

      dispatch_block_t block = ^{
        POPBasicAnimation *animation2 = [ZDAnimations animationWithType:ZDAnimationType_Rotation
                                                              fromValue:@(M_PI / 8)
                                                                toValue:@(0)
                                                               duration:duration];
        animation2.removedOnCompletion = YES;
        [self.label.layer pop_addAnimation:animation2 forKey:@"ZD_RotationX2Key"];
      };

      POPBasicAnimation *animation1 = [ZDAnimations animationWithType:ZDAnimationType_Rotation
                                                            fromValue:@(M_PI / 8)
                                                              toValue:@(-M_PI / 8)
                                                             duration:duration];
      animation1.autoreverses = YES;
      animation1.removedOnCompletion = YES;
      animation1.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
          block();
        }
      };

      [self.label.layer pop_addAnimation:animation1 forKey:@"ZD_RotationX1Key"];
    } break;
    case 1:  // 围绕Y轴旋转
    {
      // CFTimeInterval duration = 0.8;

      POPSpringAnimation *animation1 = [ZDAnimations animationWithType:ZDAnimationType_RotationY
                                                             fromValue:@(M_PI_2)
                                                               toValue:@(0)
                                                              duration:0];
      animation1.removedOnCompletion = YES;
      animation1.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
          //
        }
      };

      [self.label.layer pop_addAnimation:animation1 forKey:@"ZD_RotationYKey"];
    } break;
    case 2:  // 上下移动
    {
      CGFloat centerY = CGRectGetMidY(self.view.bounds);
      CGFloat updown = 50.0;

      POPBasicAnimation *animation = [ZDAnimations animationWithType:ZDAnimationType_PositionY
                                                           fromValue:@(centerY + updown)
                                                             toValue:@(centerY - updown)
                                                            duration:0.8];
      animation.autoreverses = YES;
      animation.removedOnCompletion = YES;

      [self.label.layer pop_addAnimation:animation forKey:@"ZD_PostionYKey"];
    } break;
    case 3:  // shadow效果
    {
      self.label.layer.shadowOffset = (CGSize){5, 5};
      self.label.layer.shadowColor = [UIColor blackColor].CGColor;
      self.label.layer.shadowOpacity = 0.8;

      POPSpringAnimation *scale =
          [ZDAnimations animationWithType:ZDAnimationType_Scale
                                fromValue:[NSValue valueWithCGPoint:CGPointMake(8.0, 8.0)]
                                  toValue:[NSValue valueWithCGPoint:CGPointMake(0.4, 0.4)]
                                 duration:0];

      CGFloat duration = 1.5;

      POPBasicAnimation *shadowOffset = ({
        POPBasicAnimation *animation =
            [POPBasicAnimation animationWithPropertyNamed:kPOPLayerShadowOffset];
        animation.fromValue = [NSValue valueWithCGSize:(CGSize){20.0, 20.0}];
        animation.toValue = [NSValue valueWithCGSize:(CGSize){5.f, 5.f}];
        animation.duration = duration;
        animation;
      });

      POPBasicAnimation *shadowColor = ({
        POPBasicAnimation *animation =
            [POPBasicAnimation animationWithPropertyNamed:kPOPLayerShadowColor];
        animation.fromValue = (__bridge id)([UIColor redColor].CGColor);
        animation.toValue = (__bridge id)([UIColor lightTextColor].CGColor);
        animation.duration = duration;
        animation;
      });

      [self.label.layer pop_addAnimation:shadowOffset forKey:@"ZD_ShadowOffsetKey"];
      [self.label.layer pop_addAnimation:shadowColor forKey:@"ZD_ShadowColorKey"];
      [self.label.layer pop_addAnimation:scale forKey:@"ZD_ScaleKey"];
    } break;
    case 4:  // 模拟阴影效果
    {
      [self simulateShadowAnimation];
    } break;
    case 5: {
    } break;
    default:
      break;
  }
}

/// 模拟背影效果
- (void)simulateShadowAnimation {
  self.label.hidden = NO;
  self.label.transform = CGAffineTransformIdentity;
  self.label.textColor = RandomColor();

  NSMutableArray<UIView *> *views = @[].mutableCopy;
  NSInteger count = 4, offset = 7;
  for (NSInteger i = 1; i <= count; i++) {
    UILabel *label = CopyedView(self.label);
    label.textColor = RandomColor();
    label.frame = CGRectOffset(self.label.bounds, -offset * i, -offset * i);
    // NSLog(@"%@, %@\n", NSStringFromCGRect(self.label.frame), NSStringFromCGRect(label.frame));
    if (i == count) {
      label.textColor = [UIColor whiteColor];
    }
    [self.label addSubview:label];
    [views addObject:label];
  }

  CGFloat duration = 3.f;

  // MARK: BezierPath
  UIBezierPath *circlePath = [self drawBezierPathWithPoint:self.label.center];

#if 0  //调试用（展示运动轨迹）
    CAShapeLayer *shapeLayer = ({
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.label.superview.bounds;
        layer.lineWidth = 5;
        layer.strokeColor = [UIColor greenColor].CGColor;
        layer.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.3].CGColor; // 所画出区域的填充色
        layer.lineCap = kCALineCapRound;
        layer.lineJoin = kCALineJoinRound;
        layer.path = circlePath.CGPath;
        layer;
    });
    [self.label.superview.layer addSublayer:shapeLayer];
#endif

  // Keyframe animation
  CAKeyframeAnimation *keyFrameAnimation = ({
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.duration = duration;
    keyAnimation.path = circlePath.CGPath;
    keyAnimation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    keyAnimation.fillMode = kCAFillModeBoth;
    keyAnimation.calculationMode = kCAAnimationCubic;
    keyAnimation.rotationMode = kCAAnimationRotateAuto;
    keyAnimation.removedOnCompletion = YES;
    keyAnimation.delegate = self;
    keyAnimation;
  });
  [self.label.layer addAnimation:keyFrameAnimation forKey:@"ZD_PostionKeyframeAnimation"];

  //============================================================================

  // MARK: POP animation
  POPBasicAnimation *animation = ({
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.fromValue = [NSValue valueWithCGPoint:(CGPoint){2.f, 2.f}];
    animation.toValue = [NSValue valueWithCGPoint:(CGPoint){0.0f, 0.0f}];
    animation.duration = duration;
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    animation;
  });
  [self.label.layer pop_addAnimation:animation forKey:@"ZD_ShadowPosition"];

  // MARK: 好像不起作用？？？？
  [views enumerateObjectsUsingBlock:^(UIView *_Nonnull view, NSUInteger idx, BOOL *_Nonnull stop) {
    POPSpringAnimation *animation2 = ({
      POPSpringAnimation *animation = [POPSpringAnimation animation];
      CGPoint originPoint = view.frame.origin;
      animation.fromValue = [NSValue valueWithCGPoint:originPoint];
      animation.toValue =
          [NSValue valueWithCGPoint:(CGPoint){originPoint.x + 15, originPoint.y - 15}];
      animation.removedOnCompletion = YES;
      animation.property =
          [POPAnimatableProperty propertyWithName:@"ZD_CustomProperty"
                                      initializer:^(POPMutableAnimatableProperty *prop) {
                                        prop.writeBlock = ^(id obj, const CGFloat *values) {
                                          CGSize originSize = view.bounds.size;
                                          view.frame = (CGRect){{values[0], values[1]}, originSize};
                                        };
                                      }];
      animation;
    });
    [view.layer pop_addAnimation:animation2 forKey:@"ZD_ViewsPostion"];
  }];

  POPBasicAnimation *rotationAnimation = ({
    /*
    void(^innerAnimationBlock)() = ^void(){
        POPBasicAnimation *innerAnimation = ({
            POPBasicAnimation *rotationAnimation = [POPBasicAnimation
    animationWithPropertyNamed:kPOPLayerRotation]; rotationAnimation.fromValue = @(-M_PI_2);
            rotationAnimation.toValue = @0;
            rotationAnimation.duration = duration / 2.f;
            rotationAnimation.removedOnCompletion = YES;
            rotationAnimation;
        });
        [self.label.layer pop_addAnimation:innerAnimation forKey:@"ZD_InnerRotationKey"];
    };
     */

    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    animation.toValue = @(-M_PI_4 * 3);
    animation.duration = duration / 2.f;
    animation.removedOnCompletion = YES;
    animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
      if (finished) {
        // innerAnimationBlock();
      }
    };
    animation;
  });

  // self.label.layer.transform = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);

  [self.label.layer pop_addAnimation:rotationAnimation forKey:@"ZD_ViewsRotationKey"];

  //==============================================================
}

// MARK: 绘制贝塞尔曲线
- (UIBezierPath *)drawBezierPathWithPoint:(CGPoint)point {
  UIBezierPath *circlePath = ({
    CGFloat curveRadius = [UIScreen mainScreen].bounds.size.width / 2.0 - 20.0;  ///< 大圆半径
    CGPoint center = point;

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:curveRadius
                                                    startAngle:(M_PI_2)endAngle:(M_PI_2 * 5)
                                                     clockwise:YES];
    path.lineWidth = 5.f;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;

    // 最终回到大圆的中心点
    UIBezierPath *middlePath =
        [UIBezierPath bezierPathWithArcCenter:(CGPoint){center.x, center.y + curveRadius / 4.0}
                                       radius:(curveRadius * 2 - curveRadius * 0.5) / 2.0
                                   startAngle:(M_PI_2)endAngle:(M_PI_2 * 5)
                                    clockwise:YES];
    UIBezierPath *smallPath =
        [UIBezierPath bezierPathWithArcCenter:(CGPoint){center.x, center.y + curveRadius / 2.0}
                                       radius:curveRadius / 2.0
                                   startAngle:(M_PI_2)endAngle:(M_PI_2 * 3)
                                    clockwise:YES];

    [path appendPath:middlePath];
    [path appendPath:smallPath];

    [path stroke];
    path;
  });

  return circlePath;
}

- (UIBezierPath *)drawBezierPathWithPoint888888:(CGPoint)point {
  UIBezierPath *circlePath = ({
    CGFloat curveRadius = [UIScreen mainScreen].bounds.size.width / 2.0 - 20.0;
    CGPoint center = point;

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:curveRadius
                                                    startAngle:(M_PI_2)endAngle:(M_PI_2 * 3)
                                                     clockwise:YES];
    path.lineWidth = 5.f;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;

    UIBezierPath *smallPath =
        [UIBezierPath bezierPathWithArcCenter:(CGPoint){center.x, center.y - curveRadius / 2.0}
                                       radius:curveRadius / 2.0
                                   startAngle:(-M_PI_2)endAngle:(M_PI_2)clockwise:YES];
    [path appendPath:smallPath];

    //[path closePath];//执行此方法后半圆会闭合
    [path stroke];
    path;
  });

  return circlePath;
}

#pragma mark - Actions

- (IBAction)executeAnimation:(UIButton *)sender {
  [self animation];
}

#pragma mark - POPAnimationDelegate

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
  if (finished) {
    [self.label.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if (flag) {
    [self.label.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.label.hidden = YES;
  }
}

#pragma mark - property

- (UILabel *)label {
  if (!_label) {
    _label = [[UILabel alloc]
        initWithFrame:(CGRect){30, 250, [UIScreen mainScreen].bounds.size.width - 30 * 2, 100}];
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont boldSystemFontOfSize:100.f];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = RandomColor();  //[UIColor blueColor];
    _label.text = @"零";
  }
  return _label;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before
navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

#if 0
{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotationX];
    springAnimation.toValue = @(M_PI * 2);
    springAnimation.springBounciness = 12.f;
    springAnimation.springSpeed = 4.f;
    springAnimation.dynamicsFriction = 10.f;
    springAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [self.label.layer pop_removeAllAnimations];
        }
    };
    [self.label.layer pop_addAnimation:springAnimation forKey:@"ZD_PopRotationXKey"];
}
#else

#endif
