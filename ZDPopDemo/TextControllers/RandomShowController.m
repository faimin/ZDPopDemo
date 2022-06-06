//
//  RandomShowController.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/31.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "RandomShowController.h"
#import <pop/POP.h>
#import "ZDFunction.h"

@interface RandomShowController ()
@property(nonatomic, strong) UIView *animationView;
@property(nonatomic, strong) UILabel *label;
@property(nonatomic, assign) NSTimeInterval duration;
@end

@implementation RandomShowController

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
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.animationView.frame = (CGRect){0, 0, ScreenSize().width, ScreenSize().width};

  [self setupUI];
}

- (void)setupUI {
  self.duration = self.duration ?: 1;

  [self.view addSubview:self.animationView];
  [self.animationView addSubview:self.label];
}

- (void)setupTimer {
  // CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self
  // selector:@selector(executeTimer:)];
  CADisplayLink *link = [[UIScreen mainScreen] displayLinkWithTarget:self
                                                            selector:@selector(executeTimer:)];
  [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)executeTimer:(CADisplayLink *)displayTimer {
}

- (IBAction)executeAnimation:(UIButton *)sender {
  [self startAnimation];
}

- (void)startAnimation {
  [self jumpShowText];
}

#pragma mark - Animation

- (void)jumpShowText {
  self.label.text = @"零";
  [self.label sizeToFit];
  self.label.center = self.label.superview.center;

#if 0  //调试用（展示运动轨迹）
    CAShapeLayer *shapeLayer = ({
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.label.superview.bounds;
        layer.lineWidth = 5;
        layer.strokeColor = [UIColor greenColor].CGColor;
        layer.fillColor = [[UIColor grayColor] colorWithAlphaComponent:0.3].CGColor; // 所画出区域的填充色
        layer.lineCap = kCALineCapRound;
        layer.lineJoin = kCALineJoinRound;
        layer.path = [self drawJumpPathFromPoint:self.label.center].CGPath;
        layer;
    });
    [self.label.superview.layer addSublayer:shapeLayer];
#endif

  // Keyframe animation(离散动画)
  CAKeyframeAnimation *keyFrameAnimation = ({
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // keyAnimation.duration = self.duration;
    keyAnimation.path = [self drawJumpPathFromPoint:self.label.center].CGPath;
    keyAnimation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.calculationMode = kCAAnimationDiscrete;  //离散动画
    // keyAnimation.delegate = self;
    keyAnimation;
  });
  //[self.label.layer addAnimation:keyFrameAnimation forKey:@"ZD_PostionKeyframeAnimation"];

  // 缩小文字
  /*
  POPBasicAnimation *scaleAnimation = [POPBasicAnimation
  animationWithPropertyNamed:kPOPLayerScaleXY]; scaleAnimation.toValue = [NSValue
  valueWithCGSize:(CGSize){0.5, 0.5}]; scaleAnimation.duration = self.duration; [self.label.layer
  pop_addAnimation:scaleAnimation forKey:@"ZD_ScaleSize"];
  */

  CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
  scaleAnimation.fromValue = [NSValue valueWithCGSize:(CGSize){1, 1}];
  scaleAnimation.toValue = [NSValue valueWithCGSize:(CGSize){0.5, 0.5}];

  // 动画组
  CAAnimationGroup *group = [CAAnimationGroup animation];
  group.animations = @[ keyFrameAnimation, scaleAnimation ];
  group.duration = self.duration;
  group.fillMode = kCAFillModeForwards;
  group.removedOnCompletion = NO;
  [self.label.layer addAnimation:group forKey:@"ZD_GroupAnimation"];
}

- (UIBezierPath *)drawJumpPathFromPoint:(CGPoint)startPoint {
  UIBezierPath *path = [UIBezierPath bezierPath];
  [path moveToPoint:startPoint];  // startPoint是中心点
  CGFloat w = startPoint.x * 2;
  CGFloat h = startPoint.y * 2;
  CGFloat ratio = 0.2;
  [path addLineToPoint:(CGPoint){w * ratio, h * (1 - ratio)}];
  [path addLineToPoint:(CGPoint){w * (1 - ratio), h * (1 - ratio)}];
  [path addLineToPoint:(CGPoint){w * ratio, h * ratio}];
  [path addLineToPoint:(CGPoint){w * (1 - ratio), h * ratio}];
  [path addLineToPoint:startPoint];
  [path closePath];
  return path;
}

#pragma mark - Create View

- (UILabel *)label {
  if (!_label) {
    _label = ({
      UILabel *label = [UILabel new];
      CGFloat edgeLR = 0.f;
      label.frame = (CGRect){edgeLR, 0, CGRectGetWidth(self.animationView.bounds) - edgeLR * 2,
                             CGRectGetHeight(self.animationView.bounds)};
      label.center = self.animationView.center;
      // label.backgroundColor = RandomColor();
      [label sizeToFit];
      label.center = self.animationView.center;
      label.adjustsFontSizeToFitWidth = YES;
      label.textColor = [UIColor redColor];
      label.font = [UIFont systemFontOfSize:200];
      label;
    });
  }
  return _label;
}

#pragma mark - property

- (UIView *)animationView {
  if (!_animationView) {
    _animationView = [UIView new];
    _animationView.backgroundColor = [UIColor yellowColor];
    _animationView.layer.masksToBounds = YES;
  }
  return _animationView;
}

@end
