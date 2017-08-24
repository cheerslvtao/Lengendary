//
//  UIView+Gesture.m
//  Module
//
//  Created by SFC-a on 2017/3/18.
//  Copyright © 2017年 SFC-a. All rights reserved.
//

#import "UIView+Gesture.h"

@implementation UIView (Gesture)

static char strAddrKey = 'a';
-(id<GestureDelegate>)delegate{
    return objc_getAssociatedObject(self, &strAddrKey);
}

-(void)setDelegate:(id<GestureDelegate>)delegate{
    objc_setAssociatedObject(self, &strAddrKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)addTapGesture{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    [self addGestureRecognizer:tap];
}


-(void)tapGestureAction:(UITapGestureRecognizer *)tap{
    if (self.delegate) {
        [self.delegate gestureAction];
    }
}

@end
