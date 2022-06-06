//
//  ZDFunction.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/25.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ZDFunction.h"

CGPoint ZD_LeftTopPoint(CGRect originFrame) {
  return (CGPoint){CGRectGetMinX(originFrame), CGRectGetMinY(originFrame)};
}

CGPoint ZD_LeftBottomPoint(CGRect originFrame) {
  return (CGPoint){CGRectGetMinX(originFrame), CGRectGetMaxY(originFrame)};
}

CGPoint ZD_RightTopPoint(CGRect originFrame) {
  return (CGPoint){CGRectGetMaxX(originFrame), CGRectGetMinY(originFrame)};
}

CGPoint ZD_RightBottomPoint(CGRect originFrame) {
  return (CGPoint){CGRectGetMaxX(originFrame), CGRectGetMaxY(originFrame)};
}

CGPoint ZD_PointScale(CGPoint originPoint, CGFloat scale) {
  CGFloat x = originPoint.x * scale;
  CGFloat y = originPoint.y * scale;
  return (CGPoint){x, y};
}

CGPoint ZD_PointOffset(CGPoint originPoint, CGPoint offset) {
  return (CGPoint){originPoint.x + offset.x, originPoint.y + offset.y};
}

CGSize ScreenSize() { return [UIScreen mainScreen].bounds.size; }

UIColor *RandomColor() {
  CGFloat hue = (arc4random() % 256 / 256.0);
  CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
  CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
  return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

UIView *CopyedView(UIView *view) {
  UIView *v = [[[view class] alloc] initWithFrame:view.frame];
  if ([view isKindOfClass:[UILabel class]]) {
    UILabel *old = (UILabel *)view;
    UILabel *new = (UILabel *)v;

    new.textAlignment = old.textAlignment;
    new.text = old.text;
    new.textColor = old.textColor;
    new.font = old.font;
    v = new;
  }

  v.hidden = view.hidden;
  v.alpha = view.alpha;
  v.backgroundColor = view.backgroundColor;

  v.layer.shadowColor = view.layer.shadowColor;
  v.layer.shadowOffset = view.layer.shadowOffset;
  v.layer.shadowRadius = view.layer.shadowRadius;

  v.layer.cornerRadius = view.layer.cornerRadius;
  return v;
}
