//
//  ZDScaleSquareView.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/6/2.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ZDScaleSquareView.h"
#import <pop/POP.h>
#import "ZDFunction.h"

@interface ZDScaleSquareView ()

@end

@implementation ZDScaleSquareView

- (void)dealloc {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setup];
  }
  return self;
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];

  [self setup];
}

#pragma mark -

- (void)setup {
  [self setupUI];
}

- (void)setupUI {
  if (CGRectEqualToRect(self.frame, CGRectZero)) return;

  self.duration = self.duration ?: 0.7;
}

#pragma mark - Protocol

- (void)startAnimation {
  //------------------添加视图-------------------

  CGSize size = self.bounds.size;
  UIView *squareView =
      [[UIView alloc] initWithFrame:(CGRect){0, 0, size.width * 0.2, size.height * 0.2}];
  squareView.backgroundColor = [UIColor greenColor];
  squareView.center = self.center;
  [self addSubview:squareView];

  //------------------动画------------------------

  CFAbsoluteTime beginTime = CFAbsoluteTimeGetCurrent();

  void (^ReverseAnimationBlock)() = ^void() {
    // NSLog(@"Reverse");
    POPBasicAnimation *animation20 =
        [self scaleFromValue:[NSValue valueWithCGSize:(CGSize){1.5, 1.5}]
                     toValue:[NSValue valueWithCGSize:(CGSize){3.0, 3.0}]];

    POPBasicAnimation *animation21 = [self rotationFromValue:@(-M_PI * 1.2) toValue:@(0)];
    animation21.completionBlock = ^(POPAnimation *anim, BOOL finished) {
      if (finished) {
        [squareView removeFromSuperview];
        [self removeFromSuperview];
        NSLog(@"完全结束");

        CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
        NSLog(@"动画所用时长： %f", endTime - beginTime);
      }
    };

    [squareView.layer pop_addAnimation:animation20 forKey:@"ZDContinueScale"];
    [squareView.layer pop_addAnimation:animation21 forKey:@"ZDReverseRotation"];
  };

  POPBasicAnimation *animation10 =
      [self scaleFromValue:[NSValue valueWithCGSize:(CGSize){0.2, 0.2}]
                   toValue:[NSValue valueWithCGSize:(CGSize){1.5, 1.5}]];
  animation10.completionBlock = ^(POPAnimation *anim, BOOL finished) {
    if (finished) ReverseAnimationBlock();
  };

  POPBasicAnimation *animation11 = [self rotationFromValue:@(0) toValue:@(-M_PI * 1.2)];

  [squareView.layer pop_addAnimation:animation10 forKey:@"ZDScale"];
  [squareView.layer pop_addAnimation:animation11 forKey:@"ZDRotation"];
}

- (POPBasicAnimation *)rotationFromValue:(id)fromValue toValue:(id)toValue {
  NSParameterAssert(_duration > 0);
  POPBasicAnimation *animation = ({
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.duration = _duration / 2.0;
    animation.removedOnCompletion = YES;
    // animation.autoreverses = YES;
    animation;
  });

  return animation;
}

- (POPBasicAnimation *)scaleFromValue:(id)fromValue toValue:(id)toValue {
  POPBasicAnimation *animation = ({
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.duration = _duration / 2.0;
    animation.removedOnCompletion = YES;
    animation;
  });

  return animation;
}

@end
