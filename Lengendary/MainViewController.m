//
//  MainViewController.m
//  Lengendary
//
//  Created by 张世龙 on 17/3/17.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "MainViewController.h"
#import "LeftViewController.h"
#import "PoperViewController.h"
#import "ScanViewController.h"
#import "MainViewCell.h"
#import "ChangePasswordViewController.h"
#import "AboutUSViewController.h"
#import "MJRefresh.h"
#import "CellModel.h"
#import "LoginInfoModel.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,GestureDelegate,UIPopoverPresentationControllerDelegate>
{
    LeftViewController * _leftvc;
    UIView * _bgView ;
}
@property (nonatomic,strong) UIView * leftView;

@property (nonatomic,strong) UITableView * leftTableView;
@property (weak, nonatomic) IBOutlet UIImageView *scanImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;


@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic) BOOL isRefresh;
@property (nonatomic) NSInteger page;

@property (nonatomic,strong) UserInfo * user;

@end

@implementation MainViewController

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [UserInfo shareUser];
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"MainViewCell" bundle:nil] forCellReuseIdentifier:@"MainViewCell"];
    
    __weak typeof(self) weakself = self;
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongself = weakself;
        [strongself loadNewData];
    }];
    
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(self) strongself = weakself;
        [strongself loadMoreData];
    }];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    if (_mainTableView) {
        [self loadNewData];
    }
}

-(void)loadNewData{
    if (!self.isRefresh) {
        self.isRefresh = YES;
    }
    self.page = 1;
    [self loadData];
}

-(void)loadMoreData{
    if (self.isRefresh) {
        self.isRefresh = NO;
    }
    self.page++;
    [self loadData];
}

-(void)endRefresh{
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView.mj_header endRefreshing];
}

-(void)loadData{
    
    NSDictionary * dic = @{@"creatorId":self.user.userModel.userId,@"pageNo":@(self.page),@"pageSize":@(10)};
    
    [HTTPRequestTool POSTWithPath:url_home_list
                       parameters:dic
                          success:^(id json) {
                              NSLog(@"首页 -->  %@",json);
        if ([json[@"status"] integerValue] == 200) {
            if (self.isRefresh) {
                [self.dataArr removeAllObjects];
            }

            NSDictionary * listDic = json[@"data"][0];
            for (NSDictionary * dic in listDic[@"list"]) {
                CellModel * model = [[CellModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:model];
            }
            [self.mainTableView reloadData];
            if(self.page >= [listDic[@"totalPage"] intValue]){
                [self.mainTableView.mj_header endRefreshing];
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
        }
        [self endRefresh];
    } failure:^(NSError *error) {
        NSLog(@"首页error --> %@",error);
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(30, HEIGHT_SCREEN - 100, WIDTH_SCREEN - 60, 40)];
        label.backgroundColor = [UIColor grayColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"网络异常,请重试";
        [self.view addSubview:label];
        [UIView animateWithDuration:3 animations:^{
            label.alpha = 0;
        }completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
        [self endRefresh];
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MainViewCell" forIndexPath:indexPath];
    if(self.dataArr.count > 0){
        cell.model = self.dataArr[indexPath.row];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoScanViewController:(UITapGestureRecognizer *)sender {
    ScanViewController * vc = [[ScanViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}


- (IBAction)leftButtonClick:(UIButton *)sender {
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.3;
    [_bgView addTapGesture];
    _bgView.delegate = self;
    [self.view addSubview:_bgView];
    
    _leftvc = [[LeftViewController alloc]initWithStyle:UITableViewStylePlain];
    __weak typeof(self) weakself = self;
    _leftvc.selectBlock = ^(NSInteger index,NSString * title){
        NSLog(@"%ld  %@"  ,(long)index,title);
        if (index > 0 ) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(30, HEIGHT_SCREEN - 100, WIDTH_SCREEN - 60, 40)];
            label.backgroundColor = [UIColor grayColor];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"正在开发中";
            [weakself.view addSubview:label];
            [UIView animateWithDuration:3 animations:^{
                label.alpha = 0;
            }completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        }else{
//            weakself.titleLabel.text = title;
        }
        [weakself leftViewDissmiss];
        
    };
    [self addChildViewController:_leftvc];
    [self.view addSubview:_leftvc.view];
}

#pragma mark -- GestureDelegate
-(void)gestureAction{
    [self leftViewDissmiss];
}

-(void)leftViewDissmiss{
    [UIView animateWithDuration:0.3 animations:^{
        _leftvc.view.frame = CGRectMake(- WIDTH_SCREEN*0.4, 0, WIDTH_SCREEN*0.4, HEIGHT_SCREEN);
    }completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_leftvc.view removeFromSuperview];
        [_leftvc removeFromParentViewController];
        _bgView = nil;
        _leftvc = nil;
    }];
}

- (IBAction)rightButtonClick:(UIButton *)sender {
    
    PoperViewController *firstVC = [[PoperViewController alloc] init];
    firstVC.modalPresentationStyle = UIModalPresentationPopover;
    firstVC.popoverPresentationController.sourceView = sender;  //rect参数是以view的左上角为坐标原点（0，0）
    firstVC.popoverPresentationController.sourceRect =  sender.bounds; //指定箭头所指区域的矩形框范围（位置和尺寸），以view的左上角为坐标原点
    firstVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp; //箭头方向
    firstVC.popoverPresentationController.delegate = self;
    firstVC.preferredContentSize = CGSizeMake(self.view.bounds.size.width*0.3, 130);
   
    __weak typeof(self) weakself = self;
    firstVC.block = ^(NSInteger index) {
        if (index == 0) {
            ChangePasswordViewController * vc = [[ChangePasswordViewController alloc]init];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [weakself presentViewController:vc animated:YES completion:nil];
            
        }else if(index == 1){
            AboutUSViewController * vc = [[AboutUSViewController alloc]init];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [weakself presentViewController:vc animated:YES completion:nil];
        }else {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定退出登录？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [NSUSERDEFAULT setObject:@"" forKey:@"userAccount"];
                [NSUSERDEFAULT synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
                [self dismissViewControllerAnimated:NO completion:nil];
            }];
            [alert addAction:action];
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    };
    [self presentViewController:firstVC animated:YES completion:nil];
    
}

//iPhone下默认是UIModalPresentationFullScreen，需要手动设置为UIModalPresentationNone，iPad不需要
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}
- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style
{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller.presentedViewController];
    return navController;
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;   //点击蒙板popover不消失， 默认yes
}


-(UIView *)leftView{
    if (!_leftView) {
        _leftView = [[UIView alloc]initWithFrame:self.view.bounds];
        _leftView.alpha = 0.3;
        _leftView.backgroundColor = [UIColor blackColor];
        _leftView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBGView:)];
        [_leftView addGestureRecognizer:tap];
    }
    return _leftView;
}

-(void)tapBGView:(UITapGestureRecognizer * )tap{
    if (_leftView) {
        [_leftView removeFromSuperview];
    }
}


-(UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
    }
    return _leftTableView;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
