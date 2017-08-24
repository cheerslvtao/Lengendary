//
//  CellModel.h
//  Lengendary
//
//  Created by SFC-a on 2017/3/28.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject

@property (nonatomic,strong) NSString * pId;

@property (nonatomic,strong) NSString * kpId;
@property (nonatomic,strong) NSString * eId;
@property (nonatomic,strong) NSString * address; //地址
@property (nonatomic,strong) NSString * x;
@property (nonatomic,strong) NSString * y;
@property (nonatomic,strong) NSString * networkDot;
@property (nonatomic,strong) NSString * enterprise;
@property (nonatomic,strong) NSString * code; //单号


@property (nonatomic,strong) NSString * status;

@property (nonatomic,strong) NSString * remark;
@property (nonatomic,strong) NSString * createdTime;
@property (nonatomic,strong) NSString * creatorId;


//是否是可疑包裹  “Y”显示  “”或者“N”隐藏
@property (nonatomic,strong) NSString * suspiciousFlag;
//底部红色的文字 实名认证  包裹未（已）实名
@property (nonatomic,strong) NSString * checkFlag;

@end
