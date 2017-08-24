//
//  ViewController.m
//  Lengendary
//
//  Created by 张世龙 on 17/3/17.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "ViewController.h"
#import "LoginInfoModel.h"
#import "AppUntils.h"
#import "MainViewController.h"
#import <AdSupport/ASIdentifierManager.h>

@interface ViewController ()<UITextFieldDelegate>
{
    CGFloat _cornerRadius ;
    BOOL _isAutoLogin;
}
@property (weak, nonatomic) IBOutlet UITextField *userAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic) BOOL mustUpdateVersion;
@property (nonatomic,strong) NSString * downloadurl; //升级版本地址
@property (nonatomic,strong) UIImageView * imageview;
@end

@implementation ViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (![[NSUSERDEFAULT objectForKey:@"userAccount"] isEqualToString:@""] && [NSUSERDEFAULT objectForKey:@"userAccount"] != nil) {
        NSString * dicstring =[NSUSERDEFAULT objectForKey:@"userAccount"];
        NSDictionary * dic = [HTTPRequestTool dictionaryWithJsonString:dicstring];
        LoginInfoModel * model = [[LoginInfoModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        UserInfo * user = [UserInfo shareUser];
        user.userModel = model;
        self.userAccountTextField.text = dic[@"username"];
        self.passwordTextField.text = dic[@"password"];
       
        _isAutoLogin  = YES;
        self.imageview = [[UIImageView alloc]initWithFrame:self.view.bounds];
        self.imageview.image = [UIImage imageNamed:@"launchImage"];
        [self.view addSubview:self.imageview];
    }
    
    _cornerRadius = 4;
    
    [self configTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:@"logout" object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated{
    if (_isAutoLogin) {
        [self performSegueWithIdentifier:@"login" sender:self.loginButton];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"logout" object:nil];
}

-(void)logout:(NSNotification *)noti{
    if (self.imageview) {
        _isAutoLogin = NO;
        [self.imageview removeFromSuperview];
    }
}

-(void)checkVersion{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSString * version = [NSString stringWithFormat:@"%@.%@",app_Version,app_build];
    
    NSLog(@"version %@  ",version);
    
    [HTTPRequestTool GETWithPath:url_updateVersion parameters:nil success:^(id json) {
        NSLog(@"%@",json);
        NSString * downloadurl = json[@"downloadurl"];
        NSString * versionname = json[@"versionname"];
        NSString * versioncode = json[@"versioncode"];
        NSString * must_versions = json[@"must_versions"];
        NSString * noticeMessage  = json[@"noticeMessage"];
        self.downloadurl = downloadurl;
        if (![version isEqualToString:versionname]) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:noticeMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"残忍拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if ([must_versions intValue] > [versioncode intValue]) {
                    //必须升级
                    self.mustUpdateVersion = YES;
                }else{
                    self.mustUpdateVersion = NO;
                }
            }];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"去升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadurl]];
            }];
            [alert addAction:action1];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)configTextField{
    self.userAccountTextField.layer.cornerRadius = _cornerRadius;
    self.passwordTextField.layer.cornerRadius = _cornerRadius;
    
    
    self.userAccountTextField.leftView = [self imageViewWithImageString:@"login_user"];
    self.passwordTextField.leftView = [self imageViewWithImageString:@"login_pass"];
    self.passwordTextField.rightView = [self imageViewWithImageString:@"login_look"];

    self.userAccountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    self.userAccountTextField.delegate =self;
    self.passwordTextField.delegate = self;

    [self setPlaceholderAttribute:self.userAccountTextField];
    [self setPlaceholderAttribute:self.passwordTextField];
    
}


- (IBAction)tapView:(id)sender {
    [self.view endEditing:YES];
}

-(void)setPlaceholderAttribute:(UITextField *)textField{
    NSString * holderText = textField.placeholder;
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor whiteColor]
                        range:NSMakeRange(0, holderText.length)];

    textField.attributedPlaceholder = placeholder;
}

-(UIView *) imageViewWithImageString:(NSString *)imgName{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 38, 38)];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 22, 22)];
    imageView.image = [UIImage imageNamed:imgName];
    [bgView addSubview:imageView];
    return bgView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)forgerPassword:(UIButton *)sender {
    
}

- (IBAction)rememberPasswod:(UIButton *)sender {
    sender.selected = !sender.selected;
}


- (IBAction)login:(UIButton *)sender {
    if (self.mustUpdateVersion) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"有新版本需要更新，否则无法正常使用APP" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"残忍拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"去升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (_downloadurl) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downloadurl]];
            }
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        return ;
    }
    
    
        if (self.userAccountTextField.text.length == 0) {
            [self errorAnimation:self.userAccountTextField];
            return;
        }else if (self.passwordTextField.text.length == 0){
            [self errorAnimation:self.passwordTextField];
            return;
        }
        
        //保存到keychain
        if(![AppUntils readUUIDFromKeyChain]){
            [AppUntils saveUUIDToKeyChain];
        }
        NSLog(@"uuid -- > %@",[AppUntils readUUIDFromKeyChain]);

        [ProgressHUD show:@"登陆中..."];
        [HTTPRequestTool POSTWithPath:url_login
                           parameters:@{@"username":self.userAccountTextField.text,@"password":self.passwordTextField.text,@"type":@"APP",@"imei":[AppUntils readUUIDFromKeyChain]}
                              success:^(id json) {
                                  NSLog(@"登录 --> %@",json);
                                  if ([json[@"status"] integerValue] == 200) {
                                      NSDictionary * dic = [json[@"data"] firstObject];
                                      [NSUSERDEFAULT setObject:[HTTPRequestTool dictionaryToJson:dic] forKey:@"userAccount"];
                                      [NSUSERDEFAULT synchronize];
                                      LoginInfoModel * model = [[LoginInfoModel alloc]init];
                                      [model setValuesForKeysWithDictionary:dic];
                                      UserInfo * user = [UserInfo shareUser];
                                      user.userModel = model;
                                      [ProgressHUD dismiss];
                                      [self performSegueWithIdentifier:@"login" sender:sender];
                                  }else{
                                      [ProgressHUD showError:json[@"info"]];
                                  }
                              }
                              failure:^(NSError *error) {
                                  NSLog(@"登录异常 --> %@",error);
                                  [ProgressHUD showError:@"登录异常，请重试"];
                              }];
    [self.view endEditing:YES];

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


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.layer.borderColor = [UIColor clearColor].CGColor;
    textField.layer.borderWidth = 0;
}

#pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     NSLog(@"%@",segue.identifier);
     
 }

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if (self.mustUpdateVersion) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"有新版本需要更新，否则无法正常使用APP" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"残忍拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"去升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (_downloadurl) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downloadurl]];
            }
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if ([identifier isEqualToString:@"login"]) {

        if (self.userAccountTextField.text.length == 0) {
            [self errorAnimation:self.userAccountTextField];
            return NO;
        }else if (self.passwordTextField.text.length == 0){
            [self errorAnimation:self.passwordTextField];
            return NO;
        }
        
        //保存到keychain
        if(![AppUntils readUUIDFromKeyChain]){
            [AppUntils saveUUIDToKeyChain];
        }
        NSLog(@"uuid -- > %@",[AppUntils readUUIDFromKeyChain]);
        //B32E668E9C1C43B89F978E30126FDF0E uuid
        //@"353344078745333"
        _isAutoLogin? : [ProgressHUD show:@"登陆中..."];
        [HTTPRequestTool POSTWithPath:url_login
                           parameters:@{@"username":self.userAccountTextField.text,@"password":self.passwordTextField.text,@"type":@"APP",@"imei":[AppUntils readUUIDFromKeyChain]}
                              success:^(id json) {
                                  NSLog(@"登录 --> %@",json);
                                  if ([json[@"status"] integerValue] == 200) {
                                      NSDictionary * dic = [json[@"data"] firstObject];
                                      [NSUSERDEFAULT setObject:[HTTPRequestTool dictionaryToJson:dic] forKey:@"userAccount"];
                                      [NSUSERDEFAULT synchronize];
                                      LoginInfoModel * model = [[LoginInfoModel alloc]init];
                                      [model setValuesForKeysWithDictionary:dic];
                                      UserInfo * user = [UserInfo shareUser];
                                      user.userModel = model;
                                      _isAutoLogin? [self performSegueWithIdentifier:identifier sender:sender]: [ProgressHUD dismiss];
//                                      [self performSegueWithIdentifier:identifier sender:sender];
                                  }else{
                                      _isAutoLogin?  :  [ProgressHUD showError:json[@"info"]];
                                  }
                                  if (self.imageview) {
                                      [self.imageview removeFromSuperview];
                                  }
        }
                              failure:^(NSError *error) {
                                  [ProgressHUD showError:@"登录异常，请重试"];
                                  if (self.imageview) {
                                      [self.imageview removeFromSuperview];
                                  }
//                                  if (_isAutoLogin){[self performSegueWithIdentifier:identifier sender:sender];}
        }];
        if (_isAutoLogin){[self performSegueWithIdentifier:identifier sender:sender];}
    }
    return YES;
}



@end
