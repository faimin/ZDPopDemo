//
//  ZDWindowShadesView.h
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/23.
//  Copyright © 2017年 zero.com. All rights reserved.
//
/**
 百叶窗动画效果
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShowDirection) {
  ShowDirection_RightToLeft = 0,
  ShowDirection_MiddleToSide,
  ShowDirection_LeftToRight
};

@interface ZDWindowShadesView : UIView

@property(nonatomic, assign) NSTimeInterval duration; ///< default is 2.5s
@property(nonatomic, strong) UIColor *layerColor;

- (void)startAnimation:(ShowDirection)direction;

- (void)stopAnimation;

- (void)resetLayersState;

@end
