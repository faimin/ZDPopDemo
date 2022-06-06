//
//  ZDPolygonView.h
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/6/1.
//  Copyright © 2017年 zero.com. All rights reserved.
//

/**
 多边形放大动画
 */

#import "AnimationViewProtocol.h"
#import <UIKit/UIKit.h>

@interface ZDPolygonView : UIView <AnimationViewProtocol>

@property(nonatomic, assign) NSTimeInterval duration;

@end
