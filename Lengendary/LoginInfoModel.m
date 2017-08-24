//
//  LoginInfoModel.m
//  Lengendary
//
//  Created by SFC-a on 2017/3/29.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "LoginInfoModel.h"

@implementation LoginInfoModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

@implementation UserInfo

+(instancetype)shareUser{
    static UserInfo * user ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[UserInfo alloc]init];
    });
    return user;
}

@end
