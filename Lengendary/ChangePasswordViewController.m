//
//  ChangePasswordViewController.m
//  Lengendary
//
//  Created by SFC-a on 2017/3/18.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "LoginInfoModel.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *newpasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;


@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UITextField *surePasswordTextfield;
@property (nonatomic,strong) UserInfo * user;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.user = [UserInfo shareUser];
    self.oldPasswordTextField.delegate = self;
    self.newpasswordTextField.delegate =self;
    self.surePasswordTextfield.delegate = self;
}

- (IBAction)savePassword:(UIButton *)sender {
    if (self.oldPasswordTextField.text.length == 0 ) {
        [self errorAnimation:self.oldPasswordTextField];
        return;
    }else if (![self.oldPasswordTextField.text isEqualToString:self.user.userModel.password]) {
        [self showErrorInfo:@"原密码不正确" errorView:self.oldPasswordTextField];
        [self errorAnimation:self.oldPasswordTextField];

        return;
    }else if(self.newpasswordTextField.text.length == 0){
        [self errorAnimation:self.newpasswordTextField];

        return;
    }else if (![self.newpasswordTextField.text isEqualToString:self.surePasswordTextfield.text]){
        [self errorAnimation:self.newpasswordTextField];
        [self errorAnimation:self.surePasswordTextfield];
        [self showErrorInfo:@"新密码确认失败" errorView:self.oldPasswordTextField];

        return;
    }
    self.oldPasswordTextField.layer.borderColor = [UIColor clearColor].CGColor;
    self.oldPasswordTextField.layer.borderWidth = 0;
    self.newpasswordTextField.layer.borderColor = [UIColor clearColor].CGColor;
    self.newpasswordTextField.layer.borderWidth = 0;
    self.surePasswordTextfield.layer.borderColor = [UIColor clearColor].CGColor;
    self.surePasswordTextfield.layer.borderWidth = 0;

    [ProgressHUD show:@"加载中..."];

    NSDictionary * dic = @{@"password":self.user.userModel.password,@"newPwd":self.newpasswordTextField.text,@"UserId":self.user.userModel.userId,@"Authorization":Authorization};
    [HTTPRequestTool POSTWithPath:url_changePassWord
                       parameters:dic
                          success:^(id json) {
                              NSLog(@"修改密码 -->  %@",json);
                              if ([json[@"status"] integerValue] == 200) {
                                  [ProgressHUD dismiss];
                                  [self dismissViewControllerAnimated:YES completion:nil];
                              }else{
                                  [ProgressHUD showError:json[@"info"]];
                              }

                          } failure:^(NSError *error) {
                              NSLog(@"修改密码error --> %@",error);
                              [ProgressHUD showError:@"网络异常"];
                          }];
    
    
}
- (IBAction)backtop:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.layer.borderColor = [UIColor clearColor].CGColor;
    textField.layer.borderWidth = 0;
}

-(void)errorAnimation:(UITextField *)textfield{
    CGFloat leftOffset = textfield.center.x - 15;
    CGFloat rightOffset = textfield.center.x + 15;
    CGFloat offset = textfield.center.x;
    CGFloat YOffset = textfield.center.y;
    textfield.layer.borderColor = [UIColor redColor].CGColor;
    textfield.layer.borderWidth = 1;
    
    [UIView animateWithDuration:0.1 animations:^{
        textfield.center = CGPointMake(leftOffset, YOffset);
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            textfield.center = CGPointMake(rightOffset, YOffset);
        }completion:^(BOOL finished) {
            textfield.center = CGPointMake(offset, YOffset);
        }];
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
