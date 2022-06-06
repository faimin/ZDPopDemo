//
//  ZDColorCrossView.h
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/27.
//  Copyright © 2017年 zero.com. All rights reserved.
//

/**
 十字色块移动
 */

#import "AnimationViewProtocol.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface ZDColorCrossView : UIView <AnimationViewProtocol>

@property(nonatomic, assign) NSTimeInterval duration;

@end

///---------------自定义Layer-------------------

UIKIT_EXTERN CGFloat const kLineWidth;

@interface ZDCrossLayer : CALayer

/// 设置十字架的颜色
@property(nonatomic, strong) UIColor *crossColor;

/// 画线宽度
+ (CGFloat)lineWidth;

@end
