//
//  HTTPRequestTool.h
//  Lengendary
//
//  Created by SFC-a on 2017/3/20.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^RequestSuccessBlock)(id json);
typedef void (^RequestFailureBlock)(NSError * error);
typedef void (^DownloadProgressBlock)(CGFloat progress);
typedef void (^UploadProgressBlock)(CGFloat progress);

@interface HTTPRequestTool : NSObject


/**
 GET请求

 @param subPath baseURL 之后的网址 如：/login
 @param params 参数
 @param success 请求成功 成功响应
 @param failure 请求失败
 */
+(void)GETWithPath:(NSString *)subPath
        parameters:(NSDictionary *)params
           success:(RequestSuccessBlock)success
           failure:(RequestFailureBlock)failure;


/**
 POST请求
 
 @param subPath baseURL 之后的网址 如：/login
 @param params  参数
 @param success 请求成功
 @param failure 请求失败
 */
+(void)POSTWithPath:(NSString *)subPath
        parameters:(NSDictionary *)params
           success:(RequestSuccessBlock)success
           failure:(RequestFailureBlock)failure;


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//词典转换为字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end

