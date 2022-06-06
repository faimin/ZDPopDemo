//
//  ZDSectorController.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/26.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ZDSectorController.h"
#import <pop/POP.h>
#import "ZDFunction.h"
#import "ZDSectorView.h"

@interface ZDSectorController ()
@property(nonatomic, strong) UIView *animationView;
@property(nonatomic, strong) ZDSectorView *sectorView;
@end

@implementation ZDSectorController

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

  ZDSectorView *view = [ZDSectorView new];
  view.frame = self.animationView.bounds;
  [self.animationView addSubview:view];

  self.sectorView = view;
}

- (IBAction)executeAnimation:(UIButton *)sender {
  [self startAnimation];
}

- (void)startAnimation {
  [self.sectorView startAnimation];
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
