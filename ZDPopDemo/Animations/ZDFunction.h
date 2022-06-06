//
//  ZDFunction.h
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/25.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGPoint ZD_LeftTopPoint(CGRect originFrame);
FOUNDATION_EXPORT CGPoint ZD_LeftBottomPoint(CGRect originFrame);
FOUNDATION_EXPORT CGPoint ZD_RightTopPoint(CGRect originFrame);
FOUNDATION_EXPORT CGPoint ZD_RightBottomPoint(CGRect originFrame);

FOUNDATION_EXPORT CGPoint ZD_PointScale(CGPoint originPoint, CGFloat scale);
FOUNDATION_EXPORT CGPoint ZD_PointOffset(CGPoint originPoint, CGPoint offset);

FOUNDATION_EXPORT CGSize ScreenSize();

UIKIT_EXTERN UIColor *RandomColor();

UIKIT_EXTERN __kindof UIView *CopyedView(__kindof UIView *view);
