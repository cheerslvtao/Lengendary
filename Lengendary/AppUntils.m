//
//  AppUntils.m
//  hnzy
//
//  Created by anyware on 16/11/2.
//
//
#import  <Security/Security.h>
#import "KeychainItemWrapper.h"
#import "AppUntils.h"

@implementation AppUntils

#pragma mark - 保存和读取UUID
+(void)saveUUIDToKeyChain
{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithAccount:@"com.lvtao.Lengendary" service:@"yixuncha" accessGroup:nil];
    NSString *string = [keychainItem objectForKey: (__bridge id)kSecAttrGeneric];
    if([string isEqualToString:@""] || !string){
        [keychainItem setObject:[self getUUIDString] forKey:(__bridge id)kSecAttrGeneric];
    }
}

+(NSString *)readUUIDFromKeyChain
{
    KeychainItemWrapper *keychainItemm = [[KeychainItemWrapper alloc] initWithAccount:@"com.lvtao.Lengendary" service:@"yixuncha" accessGroup:nil];
    NSString *UUID = [keychainItemm objectForKey: (__bridge id)kSecAttrGeneric];
    return UUID;
}

+ (NSString *)getUUIDString
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
    NSString *uuidString = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}

@end
