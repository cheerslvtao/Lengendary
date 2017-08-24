//
//  BaseViewController.m
//  Lengendary
//
//  Created by 张世龙 on 17/3/19.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)showErrorInfo:(NSString *)info errorView:(UIView *)view{
    CGRect rect ;
    rect = CGRectMake(20, 100, WIDTH_SCREEN-40, 40);
    
    UILabel * label = [[UILabel alloc]initWithFrame:rect];
    label.text = info;
    label.backgroundColor = RGB(164, 182, 202, 1);
    label.textColor = [UIColor redColor];
    label.layer.cornerRadius = 20;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [UIView animateWithDuration:1.5 animations:^{
        label.alpha = 0;
    }completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
