//
//  AnimationViewProtocol.h
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/27.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#ifndef AnimationViewProtocol_h
#define AnimationViewProtocol_h

@protocol AnimationViewProtocol <NSObject>

@property(nonatomic, assign) NSTimeInterval duration;

- (void)startAnimation;

@end

#endif /* AnimationViewProtocol_h */
