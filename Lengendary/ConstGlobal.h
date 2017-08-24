//
//  ConstGlobal.h
//  Lengendary
//
//  Created by SFC-a on 2017/3/20.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConstGlobal : NSObject

/// base url
extern NSString * const url_baseUrl;

/// 登录
extern NSString * const url_login;

/// 巡检记录查询
extern NSString * const url_home_list;

/// 修改密码
extern NSString * const url_changePassWord ;

/// 是否是可疑包裹
extern NSString * const url_isUnnormalGood;

/// 上传巡检记录
extern NSString * const url_uploadData;

/// 跟新版本
extern NSString * const url_updateVersion;

@end
