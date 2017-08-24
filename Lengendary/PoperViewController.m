//
//  PoperViewController.m
//  Lengendary
//
//  Created by SFC-a on 2017/3/18.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "PoperViewController.h"

@interface PoperViewController ()

@end

@implementation PoperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray * arr = @[@"修改密码",@"关于我们",@"退出账号"];
    for (int i = 0; i<arr.count; i++) {
        UIButton *btn = [self createButtonwithRect:CGRectMake(0, 10+i*40, self.view.bounds.size.width*0.3, 30)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGB(29, 45, 89, 1) forState:UIControlStateNormal];
        btn.tag = 1045+i;
        [self.view addSubview:btn] ;
    }
}

-(UIButton *)createButtonwithRect:(CGRect)frame {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)clickButton:(UIButton *)btn {
   
    [self dismissViewControllerAnimated:YES completion:^{
         self.block(btn.tag - 1045);
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
