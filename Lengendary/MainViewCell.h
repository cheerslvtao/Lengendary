//
//  MainViewCell.h
//  Lengendary
//
//  Created by 张世龙 on 17/3/19.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

@interface MainViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statesLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@property (nonatomic,strong) CellModel * model ;
@end
