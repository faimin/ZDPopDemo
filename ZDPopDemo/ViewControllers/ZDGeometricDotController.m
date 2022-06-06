//
//  ZDGeometricDotController.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/24.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ZDGeometricDotController.h"
#import <pop/POP.h>
#import "ZDAnimations.h"
#import "ZDFunction.h"
#import "ZDGeometricDotView.h"

@interface ZDGeometricDotController ()
@property(nonatomic, strong) UIView *animationView;
@property(nonatomic, assign) NSTimeInterval duration;
@property(nonatomic, strong) ZDGeometricDotView *dotView;
@end

@implementation ZDGeometricDotController

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
  [self ui];
}

- (void)ui {
  _duration = 2.5;

  [self.view addSubview:self.animationView];
  self.animationView.frame = (CGRect){0, 0, ScreenSize().width, ScreenSize().width};

  [self.animationView addSubview:self.dotView];
}

- (IBAction)executeAnimation:(UIButton *)sender {
  [self startAnimation];
}

- (void)startAnimation {
  [self.dotView startAnimation];
}

#pragma mark - Property

- (UIView *)animationView {
  if (!_animationView) {
    _animationView = [UIView new];
    _animationView.backgroundColor = [UIColor grayColor];
  }
  return _animationView;
}

- (ZDGeometricDotView *)dotView {
  if (!_dotView) {
    _dotView = [[ZDGeometricDotView alloc] initWithFrame:self.animationView.bounds];
  }
  return _dotView;
}

@end
