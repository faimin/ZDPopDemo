//
//  ZDSectorView.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/26.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ZDSectorView.h"
#import <pop/POP.h>

@interface ZDSectorView ()
@property(nonatomic, strong) NSArray<CALayer *> *leftLayers;
@property(nonatomic, strong) NSArray<CALayer *> *rightLayers;
@end

@implementation ZDSectorView

- (void)dealloc {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setup];
  }
  return self;
}

- (void)setup {
  [self setupUI];
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];

  [self setupUI];
}

- (void)setupUI {
  if (CGRectEqualToRect(self.frame, CGRectZero)) return;

  self.duration = self.duration ?: 2.5;

  CGRect leftFrame, rightFrame;
  CGRectDivide(self.bounds, &leftFrame, &rightFrame, CGRectGetMidX(self.bounds), CGRectMinXEdge);
  CALayer *left1 = [self layerWithFrame:leftFrame backgroundColor:[UIColor greenColor] isLeft:YES];
  CALayer *left2 = [self layerWithFrame:leftFrame backgroundColor:[UIColor redColor] isLeft:YES];
  CALayer *left3 = [self layerWithFrame:leftFrame backgroundColor:[UIColor yellowColor] isLeft:YES];

  CALayer *right1 = [self layerWithFrame:rightFrame backgroundColor:[UIColor greenColor] isLeft:NO];
  CALayer *right2 = [self layerWithFrame:rightFrame backgroundColor:[UIColor redColor] isLeft:NO];
  CALayer *right3 = [self layerWithFrame:rightFrame backgroundColor:[UIColor blueColor] isLeft:NO];

  NSArray<CALayer *> *leftLayers = @[ left1, left2, left3 ];
  NSArray<CALayer *> *rightLayers = @[ right1, right2, right3 ];

  for (CALayer *layer in leftLayers) {
    [self.layer addSublayer:layer];
  }
  for (CALayer *layer in rightLayers) {
    [self.layer addSublayer:layer];
  }

  self.leftLayers = leftLayers;
  self.rightLayers = rightLayers;
}

- (CALayer *)layerWithFrame:(CGRect)frame
            backgroundColor:(UIColor *)backgroundColor
                     isLeft:(BOOL)isLeft {
  CALayer *layer = [[CALayer alloc] init];
  layer.anchorPoint = isLeft ? (CGPoint){1, 0} : (CGPoint){0, 0};
  CGFloat w = CGRectGetWidth(frame);
  CGFloat h = CGRectGetHeight(frame);
  CGRect newFrame = (CGRect){frame.origin, w, ceil(hypotf(w, h))};
  layer.frame = newFrame;
  layer.backgroundColor = backgroundColor.CGColor;
  return layer;
}

#pragma mark - Public Method

- (void)startAnimation {
  [self.leftLayers
      enumerateObjectsWithOptions:NSEnumerationReverse
                       usingBlock:^(CALayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                         POPBasicAnimation *animation = [self animationFromValue:@(0)
                                                                         toValue:@(M_PI_2)
                                                                       withIndex:idx];
                         animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                           if (finished && (idx == 0)) {
                             [self removeFromSuperview];
                           }
                           NSLog(@"left idx: %zd com", idx);
                         };
                         [obj pop_addAnimation:animation forKey:nil];
                       }];

  [self.rightLayers
      enumerateObjectsWithOptions:NSEnumerationReverse
                       usingBlock:^(CALayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                         POPBasicAnimation *animation = [self animationFromValue:@(0)
                                                                         toValue:@(-M_PI_2)
                                                                       withIndex:idx];
                         animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                           NSLog(@"right idx: %zd com", idx);
                         };

                         [obj pop_addAnimation:animation forKey:nil];
                       }];
}

#pragma mark -

- (POPBasicAnimation *)animationFromValue:(id)fromValue
                                  toValue:(id)toValue
                                withIndex:(NSUInteger)idx {
  /*
   X为每个动画之间的时间间隔
   1/5 * X + 1/5 * X + X = duration
   */

  POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  animation.removedOnCompletion = YES;
  animation.fromValue = fromValue;
  animation.toValue = toValue;
  animation.duration = self.duration / 7 * 5;

  NSInteger index = 2 - idx;
  animation.beginTime = CACurrentMediaTime() + self.duration / 7 * index;
  NSLog(@"idx: %zd, begin: %f", idx, animation.beginTime);
  return animation;
}

@end
