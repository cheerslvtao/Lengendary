//
//  LoginInfoModel.h
//  Lengendary
//
//  Created by SFC-a on 2017/3/29.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LoginInfoModel : NSObject

@property (nonatomic,strong) NSString * userId;
@property (nonatomic,strong) NSString * creatorId;
@property (nonatomic,strong) NSString * creatorName;

@property (nonatomic,strong) NSString * relName;
@property (nonatomic,strong) NSString * username;
@property (nonatomic,strong) NSString * password;
@property (nonatomic,strong) NSString * logpwdkey;
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,strong) NSString * qq;
@property (nonatomic,strong) NSString * wechat;
@property (nonatomic,strong) NSString * loginType;
@property (nonatomic,strong) NSString * userType;
@property (nonatomic,strong) NSString * deptCode; //部门

@end


@interface UserInfo : NSObject

+(instancetype)shareUser;

@property (nonatomic,strong) LoginInfoModel * userModel;

@end
