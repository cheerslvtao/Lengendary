//
//  HTTPRequestTool.m
//  Lengendary
//
//  Created by SFC-a on 2017/3/20.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "HTTPRequestTool.h"

#define httpTool [HTTPClient shareClient]

@interface HTTPClient : AFHTTPSessionManager

@end

@implementation HTTPClient

+(instancetype)shareClient{
    static HTTPClient * client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        client = [[HTTPClient alloc]initWithBaseURL:[NSURL URLWithString:url_baseUrl] sessionConfiguration:config];
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif",@"application/x-www-form-urlencoded; charset=utf-8", nil];
        /** 请求超时 时间 */
        client.requestSerializer.timeoutInterval = 10;
        /** 安全策略 */
        client.securityPolicy = [AFSecurityPolicy defaultPolicy];
        /** 添加请求头 */
        [client.requestSerializer setValue:@"APP" forHTTPHeaderField:@"X-Source-Header"];
        if ([NSUSERDEFAULT objectForKey:@"Authorization"]) {
            [client.requestSerializer setValue:[NSUSERDEFAULT objectForKey:@"Authorization"] forHTTPHeaderField:@"Authorization"];
        }
        
    });
    return client;
}

@end



@implementation HTTPRequestTool


+(void)GETWithPath:(NSString *)subPath parameters:(NSDictionary *)params success:(RequestSuccessBlock)success failure:(RequestFailureBlock)failure{
    
    NSString * url = [url_baseUrl stringByAppendingString:subPath];
    
    [httpTool GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


+(void)POSTWithPath:(NSString *)subPath parameters:(NSDictionary *)params success:(RequestSuccessBlock)success failure:(RequestFailureBlock)failure{

    if (![subPath isEqualToString:url_login]) {
        subPath = [subPath stringByAppendingString:[NSString stringWithFormat:@"?Authorization=%@",Authorization]];
    }
    NSString * url = [url_baseUrl stringByAppendingString:subPath];
    NSLog(@"url -- > %@",url);
    [httpTool POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]] && [subPath isEqualToString:url_login]) {
            NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
            if(response.allHeaderFields[@"Authorization"]){
                [NSUSERDEFAULT setObject:response.allHeaderFields[@"Authorization"] forKey:@"Authorization"];
                [NSUSERDEFAULT synchronize];
                [httpTool.requestSerializer setValue:response.allHeaderFields[@"Authorization"] forHTTPHeaderField:@"Authorization"];
                NSLog(@"%@",response.allHeaderFields[@"Authorization"]);
            }
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    

}


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//词典转换为字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
