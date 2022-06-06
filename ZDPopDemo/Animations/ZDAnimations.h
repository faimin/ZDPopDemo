//
//  ZDAnimations.h
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/10.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class POPPropertyAnimation;

typedef NS_ENUM(NSInteger, ZDAnimationType) {
  ZDAnimationType_Scale,
  ZDAnimationType_Rotation,
  ZDAnimationType_RotationX,
  ZDAnimationType_RotationY,
  ZDAnimationType_PositionY,
  ZDAnimationType_Shadow,
};

@interface ZDAnimations : NSObject

+ (__kindof POPPropertyAnimation *)animationWithType:(ZDAnimationType)type
                                           fromValue:(id)fromValue
                                             toValue:(id)toValue
                                            duration:(CFTimeInterval)duration;

@end
