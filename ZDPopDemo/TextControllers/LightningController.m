//
//  LightningController.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/31.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "LightningController.h"
#import <pop/POP.h>
#import "ZDFunction.h"

@interface LightningController ()
@property(nonatomic, strong) UIView *animationView;
@property(nonatomic, strong) UILabel *label;
@property(nonatomic, assign) NSTimeInterval duration;
@end

@implementation LightningController

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
  self.duration = self.duration ?: 5;

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
  [self lightningShowText];
}

#pragma mark - Animation

- (void)lightningShowText {
  self.label.text = @"HELLO";
  self.label.font = [UIFont boldSystemFontOfSize:self.label.font.pointSize];

  NSTimeInterval interval = 0.2;

  POPBasicAnimation *animation1 = ({
    POPBasicAnimation *animation =
        [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    animation.fromValue = [UIColor blackColor];
    animation.toValue = [UIColor whiteColor];
    animation.duration = interval;
    animation.repeatCount = ceil(self.duration / interval);
    animation.autoreverses = YES;
    animation;
  });

  POPBasicAnimation *animation2 = ({
    POPBasicAnimation *animation =
        [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
    animation.fromValue = [UIColor whiteColor];
    animation.toValue = [UIColor blackColor];
    animation.duration = interval;
    animation.repeatCount = ceil(self.duration / interval);
    animation.autoreverses = YES;
    animation;
  });

  [self.animationView pop_addAnimation:animation1 forKey:nil];
  [self.label pop_addAnimation:animation2 forKey:nil];
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
