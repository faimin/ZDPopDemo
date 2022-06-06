//
//  ZDColorCrossController.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/6/8.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ZDColorCrossController.h"
#import <pop/POP.h>
#import "ZDColorCrossView.h"
#import "ZDFunction.h"

@interface ZDColorCrossController ()
@property(nonatomic, strong) UIView *animationView;
@property(nonatomic, strong) ZDColorCrossView *crossView;
@end

@implementation ZDColorCrossController

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
  [self setupSectorView];
}

- (void)setupSectorView {
  [self.view addSubview:self.animationView];
  self.animationView.frame = (CGRect){0, 0, ScreenSize().width, ScreenSize().width};

  ZDColorCrossView *view = [ZDColorCrossView new];
  view.frame = self.animationView.bounds;
  [self.animationView addSubview:view];

  self.crossView = view;
}

- (IBAction)executeAnimation:(UIButton *)sender {
  [self startAnimation];
}

- (void)startAnimation {
  if (!self.crossView.superview) {
    [self.animationView addSubview:self.crossView];
  }
  [self.crossView startAnimation];
}

#pragma mark - property

- (UIView *)animationView {
  if (!_animationView) {
    _animationView = [UIView new];
    _animationView.backgroundColor = [UIColor magentaColor];
    _animationView.layer.masksToBounds = YES;
  }
  return _animationView;
}

@end
