//
//  ShadowController.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/31.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ShadowController.h"
#import <pop/POP.h>
#import "ZDFunction.h"

@interface ShadowController ()
@property(nonatomic, strong) UIView *animationView;
@property(nonatomic, strong) UILabel *label;
@property(nonatomic, assign) NSTimeInterval duration;
@end

@implementation ShadowController

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

- (IBAction)executeAnimation:(UIButton *)sender {
  [self startAnimation];
}

- (void)startAnimation {
  [self shadowAnimation];
}

#pragma mark - Animation
/// 模拟背影效果
- (void)shadowAnimation {
  self.label.text = @"零";

  [self.label sizeToFit];
  self.label.center = self.animationView.center;

  // 数组里放的都是阴影视图，不包含self.label
  // NSMutableArray<UILabel *> *shadowViews = @[].mutableCopy;
  NSInteger count = 4, offset = 7;
  for (NSInteger i = 0; i < count; i++) {
    UILabel *label = CopyedView(self.label);
    label.textColor = RandomColor();
    label.frame = self.label.frame;
    [self.label.superview insertSubview:label belowSubview:self.label];
    //[shadowViews addObject:label];

    NSInteger index = count - i;
    [self setupAnimation:label toValue:(CGPoint){index * offset, index * (offset + 2)}];
  }
}

- (void)setupAnimation:(UIView *)label toValue:(CGPoint)point {
  // if (CGPointEqualToPoint(point, CGPointZero)) return;

  CFAbsoluteTime beginTime = CFAbsoluteTimeGetCurrent();
  POPBasicAnimation *animation =
      [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationXY];
  animation.toValue = [NSValue valueWithCGPoint:point];
  animation.duration = self.duration;
  animation.autoreverses = YES;
  animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
    if (finished) {
      label.hidden = YES;
      [label removeFromSuperview];
      CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
      // NSLog(@"运行时间：%f\n", endTime - beginTime);
    }
  };
  [label.layer pop_addAnimation:animation forKey:nil];
}

#pragma mark - Create View

- (UILabel *)label {
  if (!_label) {
    _label = ({
      UILabel *label = [UILabel new];
      CGFloat edgeLR = 0.f;
      label.frame = (CGRect){edgeLR, 0, CGRectGetWidth(self.animationView.bounds) - edgeLR * 2,
                             CGRectGetHeight(self.animationView.bounds)};
      label.textColor = [UIColor whiteColor];
      label.textAlignment = NSTextAlignmentCenter;
      label.font = [UIFont boldSystemFontOfSize:200.f];
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
