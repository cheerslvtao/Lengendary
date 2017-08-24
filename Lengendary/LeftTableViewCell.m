//
//  LeftTableViewCell.m
//  Module
//
//  Created by SFC-a on 2017/3/18.
//  Copyright © 2017年 SFC-a. All rights reserved.
//

#import "LeftTableViewCell.h"

@implementation LeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleName.textColor = UIColorFromHex(0x9bacdd);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
