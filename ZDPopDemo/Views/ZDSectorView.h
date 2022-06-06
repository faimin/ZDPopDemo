//
//  ZDSectorView.h
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/26.
//  Copyright © 2017年 zero.com. All rights reserved.
//

/**
 扇形动画
 */

#import "AnimationViewProtocol.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZDSectorView : UIView <AnimationViewProtocol>

@property(nonatomic, assign) NSTimeInterval duration;

@end
