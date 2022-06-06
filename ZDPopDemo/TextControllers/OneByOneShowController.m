//
//  OneByOneShowController.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/27.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "OneByOneShowController.h"
#import <pop/POP.h>
#import "ZDFunction.h"

@interface OneByOneShowController ()
@property(nonatomic, strong) UIView *animationView;
@property(nonatomic, strong) UILabel *label;
@property(nonatomic, assign) NSTimeInterval duration;
@end

@implementation OneByOneShowController

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
  [self showOneByOneText];
}

//-----------------

- (void)showOneByOneText {
  self.label.attributedText = nil;

  NSString *willShowText = @"我是你爸爸😄";
  NSTimeInterval interval = self.duration / willShowText.length;

  CFAbsoluteTime beginTime = CFAbsoluteTimeGetCurrent();
  for (NSUInteger i = 0; i < willShowText.length; i++) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * i * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                     NSString *text = [willShowText substringToIndex:(i + 1)];
                     NSMutableAttributedString *mutAttStr =
                         [[NSMutableAttributedString alloc] initWithString:text
                                                                attributes:@{
                                                                  NSKernAttributeName : @(2)
                                                                }];  //设置字间距
                     self.label.attributedText = mutAttStr;

                     CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
                     CFAbsoluteTime intervalTime = endTime - beginTime;
                     NSLog(@"一共用时：%f", intervalTime);
                   });
  }
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
      label.textAlignment = NSTextAlignmentCenter;
      label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
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
