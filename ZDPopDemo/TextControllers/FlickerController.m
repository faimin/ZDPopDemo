//
//  FlickerController.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/31.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "FlickerController.h"
#import <pop/POP.h>
#import "ZDFunction.h"

@interface FlickerController ()
@property(nonatomic, strong) UIView *animationView;
@property(nonatomic, strong) UILabel *label;
@property(nonatomic, assign) NSTimeInterval duration;
@end

@implementation FlickerController

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
  self.duration = self.duration ?: 2.5;

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
  [self flickerShowText];
}

#pragma mark - Animation

- (void)flickerShowText {
  self.label.text = @"零";
  [self.label sizeToFit];
  self.label.center = self.animationView.center;

  POPSpringAnimation *animation1 = ({
    POPSpringAnimation *animation =
        [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.fromValue = [NSValue valueWithCGSize:(CGSize){0.2, 0.2}];
    animation.toValue = [NSValue valueWithCGSize:(CGSize){1.2, 1.2}];
    animation.springSpeed = 10.f;
    animation.springBounciness = 18.f;
    // animation.dynamicsFriction = 4.f;
    // animation.dynamicsTension = 1005.f;// 张力
    animation;
  });

  [self.label.layer pop_addAnimation:animation1 forKey:nil];
}

#pragma mark - Create View

- (UILabel *)label {
  if (!_label) {
    _label = ({
      UILabel *label = [UILabel new];
      CGFloat edgeLR = 0.f;
      label.frame = (CGRect){edgeLR, 0, CGRectGetWidth(self.animationView.bounds) - edgeLR * 2,
                             CGRectGetHeight(self.animationView.bounds)};
      // label.backgroundColor = RandomColor();
      // label.textColor = [UIColor redColor];
      label.textAlignment = NSTextAlignmentCenter;
      label.font = [UIFont systemFontOfSize:200];
      label.adjustsFontSizeToFitWidth = YES;
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
