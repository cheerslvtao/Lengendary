//
//  ConstGlobal.m
//  Lengendary
//
//  Created by SFC-a on 2017/3/20.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "ConstGlobal.h"

@implementation ConstGlobal

/// base url
NSString * const url_baseUrl = @"http://110.249.218.83:8085/exc/";

/// 登录
NSString * const url_login = @"rest/sysUser/login";

/// 巡检记录查询rex/rest/
NSString * const url_home_list = @"rest/busPatrol/searchBusPatrolList";

/// 修改密码
NSString * const url_changePassWord = @"rest/sysUser/updatePwd";

/// 是否是可疑包裹
NSString * const url_isUnnormalGood = @"rest/busExpress/findBusExpress";

/// 上传巡检记录
NSString * const url_uploadData = @"rest/busPatrol/saveBusPatrol";

/// 跟新版本
NSString * const url_updateVersion = @"versonupdate_android.json";


@end
