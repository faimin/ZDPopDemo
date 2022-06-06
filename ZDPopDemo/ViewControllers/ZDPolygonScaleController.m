//
//  ZDPolygonScaleController.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/24.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ZDPolygonScaleController.h"
#import <pop/POP.h>
#import "ZDAnimations.h"
#import "ZDFunction.h"
#import "ZDPolygonView.h"

@interface ZDPolygonScaleController ()
@property(nonatomic, strong) UIView *animationView;
@property(nonatomic, assign) NSTimeInterval duration;
@end

@implementation ZDPolygonScaleController

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
}

- (void)ui {
  _duration = 8.5;

  [self.view addSubview:self.animationView];
  self.animationView.frame = (CGRect){0, 0, ScreenSize().width, ScreenSize().width};
}

- (IBAction)executeAnimation:(UIButton *)sender {
  [self startAnimation];
}

- (void)startAnimation {
  ZDPolygonView *polygonView = [ZDPolygonView new];
  polygonView.frame = self.animationView.bounds;
  [self.animationView addSubview:polygonView];

  [polygonView startAnimation];
}

#pragma mark - Getter

- (UIView *)animationView {
  if (!_animationView) {
    _animationView = [UIView new];
    _animationView.backgroundColor = [UIColor purpleColor];
    _animationView.layer.masksToBounds = YES;
  }
  return _animationView;
}

@end
