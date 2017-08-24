//
//  LeftViewController.m
//  Module
//
//  Created by SFC-a on 2017/3/18.
//  Copyright © 2017年 SFC-a. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftTableViewCell.h"
@interface LeftViewController ()

@property (nonatomic,strong) NSArray * cellArr;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellArr = @[ @{@"title":@"物流业",@"img":@"icon_wuliu_50"}
                     ,@{@"title":@"住宿业",@"img":@"icon_zhusu_50"}
                     ,@{@"title":@"娱乐业",@"img":@"icon_yule_50"}
                     ,@{@"title":@"印章业",@"img":@"icon_yinz"}
                     ,@{@"title":@"典当业",@"img":@"icon_diand"}];
    
    self.tableView.bounces = NO;
//    self.tableView.backgroundColor = RGB(29, 45, 89, 1);
    self.tableView.backgroundColor = UIColorFromHex(0x1d2d59);
    self.tableView.frame = CGRectMake(- WIDTH_SCREEN*0.4, 0, WIDTH_SCREEN*0.4, HEIGHT_SCREEN);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    self.tableView.separatorColor = UIColorFromHex(0x273a77);
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"LeftTableViewCell"];
    [self.tableView addSubview:[self versionLabel]];
    
}

-(UILabel *)versionLabel{
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, HEIGHT_SCREEN - 40, WIDTH_SCREEN*0.4, 40)];
    label.text = @"V1.0.0";
    label.font = [UIFont systemFontOfSize:14];
//    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGB(125, 140, 188, 1);
    return label;
}
-(void)viewDidAppear:(BOOL)animated{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, 0, WIDTH_SCREEN*0.4, HEIGHT_SCREEN);
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.cellArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftTableViewCell" forIndexPath:indexPath];
    
    NSDictionary * dic = self.cellArr[indexPath.row];
    cell.titleImgView.image = [UIImage imageNamed:[dic objectForKey:@"img"]];
    cell.titleName.text = [dic objectForKey:@"title"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.cellArr[indexPath.row];
    self.selectBlock(indexPath.row,[dic objectForKey:@"title"]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 2)];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 30)];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30 ;
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
