//
//  ZDScaleSquareController.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/23.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ZDScaleSquareController.h"
#import <pop/POP.h>
#import "ZDAnimations.h"
#import "ZDFunction.h"
#import "ZDScaleSquareView.h"

@interface ZDScaleSquareController ()
@property(nonatomic, strong) UIView *animationView;
@property(nonatomic, assign) NSTimeInterval duration;
@property(nonatomic, strong) ZDScaleSquareView *scaleSquareView;
@end

@implementation ZDScaleSquareController

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
  _duration = 2.5;

  [self.view addSubview:self.animationView];
  self.animationView.frame = (CGRect){0, 0, ScreenSize().width, ScreenSize().width};

  ZDScaleSquareView *scaleSquareView =
      [[ZDScaleSquareView alloc] initWithFrame:self.animationView.bounds];
  scaleSquareView.backgroundColor = [UIColor grayColor];
  self.scaleSquareView = scaleSquareView;
  [self.view addSubview:scaleSquareView];
}

- (IBAction)executeAnimation:(UIButton *)sender {
  [self startAnimation];
}

- (void)startAnimation {
  [self.scaleSquareView startAnimation];
}

#pragma mark - Getter

- (UIView *)animationView {
  if (!_animationView) {
    _animationView = [UIView new];
    _animationView.backgroundColor = [UIColor purpleColor];
  }
  return _animationView;
}

@end
