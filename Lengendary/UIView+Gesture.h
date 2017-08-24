//
//  UIView+Gesture.h
//  Module
//
//  Created by SFC-a on 2017/3/18.
//  Copyright © 2017年 SFC-a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@protocol GestureDelegate <NSObject>

/** 手势响应事件 */
-(void)gestureAction;

@end

@interface UIView (Gesture)

@property (nonatomic,weak) id<GestureDelegate> delegate;

-(void)addTapGesture;
-(void)tapGestureAction:(UITapGestureRecognizer *)tap;

@end
