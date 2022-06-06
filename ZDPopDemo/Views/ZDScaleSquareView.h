//
//  ZDScaleSquareView.h
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/6/2.
//  Copyright © 2017年 zero.com. All rights reserved.
//

/**
 正方形旋转缩放动画
 */

#import "AnimationViewProtocol.h"
#import <UIKit/UIKit.h>

@interface ZDScaleSquareView : UIView <AnimationViewProtocol>

@property(nonatomic, assign) NSTimeInterval duration;

@end
