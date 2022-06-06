//
//  ZDWindowController.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/23.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ZDWindowController.h"
#import <pop/POP.h>
#import "ZDAnimations.h"
#import "ZDFunction.h"
#import "ZDWindowShadesView.h"

static NSString *const AnimationKey = @"ZD_RotationYKey";

@interface ZDWindowController ()
@property(nonatomic, strong) UIView *animationView;
@property(nonatomic, strong) ZDWindowShadesView *windowShadesView;
@property(nonatomic, strong) NSMutableArray<CALayer *> *subLayerArray;
@end

@implementation ZDWindowController

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
}

- (void)ui {
  [self.view addSubview:self.animationView];
  self.animationView.frame = (CGRect){0, 0, ScreenSize().width, ScreenSize().width};

  self.windowShadesView = [[ZDWindowShadesView alloc] initWithFrame:self.animationView.bounds];

  [self.animationView addSubview:self.windowShadesView];
}

- (IBAction)executeAnimation:(UIButton *)sender {
  [self startAnimation];
}

- (void)startAnimation {
  [self.windowShadesView startAnimation:ShowDirection_RightToLeft];
}

#pragma mark - Getter

- (UIView *)animationView {
  if (!_animationView) {
    _animationView = [UIView new];
    _animationView.backgroundColor = [UIColor purpleColor];
  }
  return _animationView;
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
