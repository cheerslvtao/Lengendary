//
//  LeftViewController.h
//  Module
//
//  Created by SFC-a on 2017/3/18.
//  Copyright © 2017年 SFC-a. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectIndex)(NSInteger row,NSString * title);

@interface LeftViewController : UITableViewController

@property (nonatomic,copy) selectIndex selectBlock;


@end
