//
//  ZDAnimations.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/10.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ZDAnimations.h"
#import <UIKit/UIKit.h>
#import <pop/POP.h>

@implementation ZDAnimations

+ (__kindof POPPropertyAnimation *)animationWithType:(ZDAnimationType)type
                                           fromValue:(id)fromValue
                                             toValue:(id)toValue
                                            duration:(CFTimeInterval)duration {
  POPPropertyAnimation *animation;
  switch (type) {
    case ZDAnimationType_Scale: {
      animation = ({
        POPSpringAnimation *springAnimation =
            [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        if (fromValue) {
          springAnimation.fromValue = fromValue;
        }
        springAnimation.toValue = toValue;
        springAnimation.springSpeed = 20.0f;
        springAnimation.springBounciness = 18.0f;
        springAnimation.dynamicsTension = 5.0f;
        springAnimation.dynamicsFriction = 5.0f;
        springAnimation;
      });
    } break;
    case ZDAnimationType_Rotation: {
      animation = ({
        POPBasicAnimation *animation =
            [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
        if (fromValue) {
          animation.fromValue = fromValue;
        }
        animation.toValue = toValue;
        animation.duration = duration ?: 0.8;
        animation;
      });
    } break;
    case ZDAnimationType_RotationX: {
      NSString *propertyName =
          (type == ZDAnimationType_RotationX) ? kPOPLayerRotationX : kPOPLayerRotationY;
      animation = ({
        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:propertyName];
        if (fromValue) {
          animation.fromValue = fromValue;
        }
        animation.toValue = toValue;
        animation.duration = duration ?: 0.8;
        animation;
      });
    } break;
    case ZDAnimationType_RotationY: {
      animation = ({
        POPSpringAnimation *animation =
            [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotationY];
        if (fromValue) {
          animation.fromValue = fromValue;
        }
        animation.toValue = toValue;
        animation.springBounciness = 18.f;
        animation.dynamicsFriction = 4.f;
        animation.dynamicsTension = 25.f;  // 值越大，旋转越快
        animation;
      });
    } break;
    case ZDAnimationType_PositionY: {
      animation = ({
        POPBasicAnimation *animation =
            [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        animation.fromValue = fromValue;
        animation.toValue = toValue;
        if (duration) {
          animation.duration = duration;
        }
        animation;
      });
    } break;
    case ZDAnimationType_Shadow: {
      animation = ({ nil; });
    } break;
    case 50: {
      animation = ({ nil; });
    } break;
    default:
      break;
  }

  return animation;
}

@end
