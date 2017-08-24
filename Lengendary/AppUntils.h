//
//  AppUntils.h
//  hnzy
//
//  Created by anyware on 16/11/2.
//
//

#import <Foundation/Foundation.h>

@interface AppUntils : NSObject

+(NSString *)getUUIDString;
+(NSString *)readUUIDFromKeyChain;
+(void)saveUUIDToKeyChain;

@end
