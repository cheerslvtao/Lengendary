//
//  MainViewCell.m
//  Lengendary
//
//  Created by 张世龙 on 17/3/19.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "MainViewCell.h"

@implementation MainViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.shadowColor=[UIColor blackColor].CGColor;
    self.bgView.layer.shadowOffset=CGSizeMake(1, 1);
    self.bgView.layer.shadowOpacity=0.6;
    
    self.statesLabel.layer.cornerRadius = self.statesLabel.frame.size.height/2;
    self.statesLabel.layer.borderWidth = 0.2;
    self.statesLabel.layer.borderColor = [UIColor magentaColor].CGColor;

    self.descriptionLabel.layer.cornerRadius = 5;
    self.descriptionLabel.superview.layer.cornerRadius = 5;

}

-(void)setModel:(CellModel *)model{
    
    self.timeLabel.text = model.createdTime;
    self.addressLabel.text  = [NSString stringWithFormat:@"查询地址  %@",model.address];
    self.orderNumberLabel.text =[NSString stringWithFormat:@"查询单号  %@",model.code];
    
    if([model.checkFlag isEqualToString:@"Y"]){
//         实名认证  包裹未（已）实名
        self.descriptionLabel.text = @"包裹已实名";
    }else{
        self.descriptionLabel.text = @"包裹未实名";
    }
    
    if ([model.suspiciousFlag isEqualToString:@""] ||[model.suspiciousFlag isEqualToString:@"N"] ) {
        self.statesLabel.hidden = YES;
    }else{
        self.statesLabel.hidden = NO;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
