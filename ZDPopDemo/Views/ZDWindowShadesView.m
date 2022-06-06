//
//  ZDWindowShadesView.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/23.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ZDWindowShadesView.h"
#import <pop/POP.h>

static NSString *const AnimationKey = @"ZD_RotationYKey";

@interface ZDWindowShadesView ()
@property(nonatomic, strong) NSMutableArray<CALayer *> *subLayerArray;
@end

@implementation ZDWindowShadesView

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

- (void)setupUI {
  CGFloat viewWidth = 50.0;
  double viewCount = ceil(CGRectGetWidth(self.frame) / viewWidth);
  for (NSUInteger i = 0; i < viewCount; i++) {
    CALayer *layer = ({
      CALayer *layer = [[CALayer alloc] init];
      layer.backgroundColor = [UIColor redColor].CGColor;
      layer;
    });

    // CGFloat x = CGRectGetWidth(self.frame) - viewWidth * i - viewWidth;
    CGFloat x = viewWidth * i;
    layer.frame = (CGRect){x, 0, viewWidth, CGRectGetHeight(self.frame)};
    layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI_2, 0, 1, 0);
    [self.layer addSublayer:layer];

    [self.subLayerArray addObject:layer];
  }
}

#pragma mark - Public Method

- (void)startAnimation:(ShowDirection)direction {
  _duration = _duration ?: 2.5;

#if __has_include("ZDPopViewController.h")
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_duration)*NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
                   [self resetLayersState];
                 });
#endif

  NSUInteger layerCount = self.subLayerArray.count;

  // 让每个动画执行时间长点，并且动画之间的启动时间间隔短一些
  NSTimeInterval startInterval = _duration / (layerCount * 3.0);  //值越大，间隔越短
  NSTimeInterval duration = _duration / (layerCount * 0.5);  // 值越小，动画执行时间越长

  switch (direction) {
    case ShowDirection_RightToLeft: {
      NSUInteger count = self.subLayerArray.count;
      [self.subLayerArray
          enumerateObjectsWithOptions:NSEnumerationReverse
                           usingBlock:^(CALayer *_Nonnull obj, NSUInteger idx,
                                        BOOL *_Nonnull stop) {
                             POPBasicAnimation *animation1 = [self animationWithDuration:duration];
                             animation1.beginTime =
                                 CACurrentMediaTime() + startInterval * (count - 1 - idx);
                             [obj pop_addAnimation:animation1 forKey:AnimationKey];
                           }];
    } break;

    case ShowDirection_MiddleToSide: {
      [self middleToSideAnimationWithDuration:duration startInterval:startInterval];
    } break;

    case ShowDirection_LeftToRight: {
      [self.subLayerArray
          enumerateObjectsUsingBlock:^(CALayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            POPBasicAnimation *animation1 = [self animationWithDuration:duration];
            animation1.beginTime = CACurrentMediaTime() + startInterval * idx;
            [obj pop_addAnimation:animation1 forKey:AnimationKey];
          }];
    } break;

    default:
      break;
  }
}

- (void)middleToSideAnimationWithDuration:(NSTimeInterval)duration
                            startInterval:(NSTimeInterval)startInterval {
  NSMutableArray *leftArray = @[].mutableCopy;
  NSMutableArray *rightArray = @[].mutableCopy;

  NSUInteger middle = self.subLayerArray.count / 2;
  [self.subLayerArray
      enumerateObjectsUsingBlock:^(CALayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (idx < middle) {
          [leftArray insertObject:obj atIndex:0];
        } else {
          [rightArray addObject:obj];
        }
      }];

  [leftArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    POPBasicAnimation *animation = [self animationWithDuration:duration];
    animation.beginTime = CACurrentMediaTime() + startInterval * idx;
    [obj pop_addAnimation:animation forKey:AnimationKey];
  }];

  [rightArray
      enumerateObjectsUsingBlock:^(CALayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        POPBasicAnimation *animation = [self animationWithDuration:duration];
        animation.beginTime = CACurrentMediaTime() + startInterval * idx;
        [obj pop_addAnimation:animation forKey:AnimationKey];
      }];
}

- (void)stopAnimation {
  [self.subLayerArray makeObjectsPerformSelector:@selector(pop_removeAnimationForKey:)
                                      withObject:AnimationKey];
}

- (void)resetLayersState {
  for (CALayer *layer in self.subLayerArray) {
    layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI_2, 0, 1, 0);
  }
}

#pragma mark - Private Method

- (POPBasicAnimation *)animationWithDuration:(NSTimeInterval)duration {
  POPBasicAnimation *animation = ({
    POPBasicAnimation *animation =
        [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotationY];
    animation.fromValue = @(M_PI_2);
    animation.toValue = @0;
    animation.duration = duration;
    animation.removedOnCompletion = YES;
    animation;
  });

  return animation;
}

#pragma mark - Getter

- (NSMutableArray *)subLayerArray {
  if (!_subLayerArray) {
    _subLayerArray = @[].mutableCopy;
  }
  return _subLayerArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
