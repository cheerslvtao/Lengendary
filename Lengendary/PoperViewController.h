//
//  PoperViewController.h
//  Lengendary
//
//  Created by SFC-a on 2017/3/18.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectButtonIndexDelegate)(NSInteger index);

@interface PoperViewController : BaseViewController

@property (nonatomic,copy) SelectButtonIndexDelegate block;

@end
