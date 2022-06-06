//
//  ZDGeometricDotView.h
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/24.
//  Copyright © 2017年 zero.com. All rights reserved.
//

/**
 点点几何动画
 */

#import "AnimationViewProtocol.h"
#import <UIKit/UIKit.h>

@interface ZDGeometricDotView : UIView <AnimationViewProtocol>

@property(nonatomic, assign) NSTimeInterval duration;

@end
