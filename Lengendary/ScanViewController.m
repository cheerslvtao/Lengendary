//
//  ScanViewController.m
//  Lengendary
//
//  Created by 张世龙 on 17/3/17.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MainViewCell.h"
#import "CellModel.h"
#import "LoginInfoModel.h"
#define TOP (HEIGHT_SCREEN-220)/2
#define LEFT (WIDTH_SCREEN-220)/2

#define kScanRect CGRectMake(LEFT, TOP, 220, 220)
//#define kScanRect CGRectMake(LEFT, TOP, WIDTH_SCREEN, HEIGHT_SCEEN*0.25)


@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UITableViewDelegate,UITableViewDataSource>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CAShapeLayer *cropLayer;
    BOOL _isScan; //是否扫描过
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic, strong) UIImageView * line;
@property (weak, nonatomic) IBOutlet UITextField *inputScanTextField;

@property (weak, nonatomic) IBOutlet UIView *scanBGView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,assign) NSInteger dataCount;

@end

@implementation ScanViewController
-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
- (IBAction)backMain:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)inputCodeButtonClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    _isScan = NO;

    [ProgressHUD show:@"查询中..." Interaction:YES];
    [HTTPRequestTool POSTWithPath:url_isUnnormalGood
                       parameters:@{@"code":self.inputScanTextField.text}
                          success:^(id json) {
                              NSLog(@"查询包裹根据扫描值 --> %@",json);
                                  [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      CellModel * model = (CellModel *)obj;
                                      if ([model.code isEqualToString:self.inputScanTextField.text]) {
                                          [ProgressHUD show:@"此货物已扫描"];
                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                              [ProgressHUD dismiss];
                                          });
                                          _isScan = YES;
                                      }
                                  }];
                              if (!_isScan) {
                                  if ([json[@"status"] integerValue] == 200) {
                                      NSDictionary * listDic = json[@"data"][0];
                                      for (NSDictionary * dic in listDic[@"list"]) {
                                          CellModel * model = [[CellModel alloc]init];
                                          [model setValuesForKeysWithDictionary:dic];
                                          [self.dataArr addObject:model];
                                      }
                                  }else{
                                      CellModel * model = [[CellModel alloc]init];
                                      model.code = self.inputScanTextField.text;
                                      model.x =[NSUSERDEFAULT objectForKey:@"X"];
                                      model.y =[NSUSERDEFAULT objectForKey:@"Y"];
                                      model.address = [NSUSERDEFAULT objectForKey:@"address"];
                                      model.createdTime = [self nowTime];
                                      model.checkFlag = @"N";
                                      model.suspiciousFlag = @"";
                                      model.eId = @"";
                                      model.enterprise = @"";
                                      model.networkDot = @"";
                                      model.status = @"";
                                      [self.dataArr addObject:model];
                                      [self.mainTableView reloadData];
                                      [ProgressHUD dismiss];
                                      self.inputScanTextField.text = @"";

                                  }
                              }
                          }
                          failure:^(NSError *error) {
                              [ProgressHUD showError:@"网络异常，请重试"];
                          }];

    
}
- (IBAction)uploadData:(UIButton *)sender {
    self.dataCount = self.dataArr.count;
    
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CellModel class]]) {
           
            CellModel * model = (CellModel *)obj;
            UserInfo * user = [UserInfo shareUser];
            [ProgressHUD show:@"上传中..."];
            NSDictionary * params = @{@"creatorId":user.userModel.userId,
                                      @"creatorName":user.userModel.creatorName,
                                      @"code":model.code,
                                      @"x":[NSUSERDEFAULT objectForKey:@"X"],
                                      @"y":[NSUSERDEFAULT objectForKey:@"Y"],
                                      @"address":[NSUSERDEFAULT objectForKey:@"address"],
                                      @"deptCode":user.userModel.deptCode,
                                      @"checkFlag":model.checkFlag,
                                      @"eId":model.eId,
                                      @"sendTime":model.createdTime,
                                      @"enterprise":model.enterprise,
                                      @"networkDot":model.networkDot,
                                      @"status":model.status
                                      };
            [HTTPRequestTool POSTWithPath:url_uploadData
                               parameters:params
                                  success:^(id json) {
                                      NSLog(@"上传 --> %@",json);
                                      if (self.dataCount>1) {
                                          [ProgressHUD show:[NSString stringWithFormat:@"%ld/%lu",(long)self.dataCount,(unsigned long)self.dataArr.count]];
                                          self.dataCount--;
                                      }else{
                                          [ProgressHUD showSuccess:@"长传成功"];
                                          [self.dataArr removeAllObjects];
                                          [self.mainTableView reloadData];
                                      }
                                  }
                                  failure:^(NSError *error) {
                                      [ProgressHUD showError:@"网络异常，请重试"];
                                      NSLog(@"%@",error);
                                      return ;
                                  }];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
    [self configView];
    self.sureButton.layer.cornerRadius = 5;
    self.uploadButton.layer.cornerRadius = 5;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"MainViewCell" bundle:nil] forCellReuseIdentifier:@"MainViewCell"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MainViewCell" forIndexPath:indexPath];
    if (self.dataArr.count > 0) {
        CellModel * model = self.dataArr[indexPath.row];
        NSLog(@"%@",model.address);
        [cell setModel:model];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


-(void)configView{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN*0.25)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.scanBGView addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, WIDTH_SCREEN, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.scanBGView addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self setCropRect:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN*0.25)];
    
    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:0.3];
    
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(0, 10+2*num, WIDTH_SCREEN, 2);
        if (10+2*num > HEIGHT_SCREEN*0.25-10) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(0, 10+2*num,  WIDTH_SCREEN, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}


- (void)setCropRect:(CGRect)cropRect{
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, self.view.bounds);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    
    
    [cropLayer setNeedsDisplay];
    
    [self.scanBGView.layer addSublayer:cropLayer];
}

- (void)setupCamera
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device==nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        //[self presentViewController:alert animated:YES completion:nil];
        return;
    }
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫描区域
    CGFloat top = 0/HEIGHT_SCREEN;
    CGFloat left = 0/WIDTH_SCREEN;
    CGFloat width = WIDTH_SCREEN/WIDTH_SCREEN;
    CGFloat height = HEIGHT_SCREEN/HEIGHT_SCREEN;
    ///top 与 left 互换  width 与 height 互换
    [_output setRectOfInterest:CGRectMake(top,left, height, width)];
    
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode, nil]];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.scanBGView.layer.bounds;
    [self.scanBGView.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    _isScan = NO;
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        [timer setFireDate:[NSDate distantFuture]];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"扫描结果：%@",stringValue);
        if(stringValue.length == 0 || !stringValue){
            if (_session != nil && timer != nil) {
                [_session startRunning];
                [timer setFireDate:[NSDate date]];
            }
            return;
        }
        [ProgressHUD show:@"查询中..." Interaction:YES];
        [HTTPRequestTool POSTWithPath:url_isUnnormalGood
                           parameters:@{@"code":stringValue}
                              success:^(id json) {
                                  NSLog(@"查询包裹根据扫描值 --> %@",json);
                                  [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      CellModel * model = (CellModel *)obj;
                                      if ([model.code isEqualToString:stringValue]) {
                                          [ProgressHUD show:@"此货物已扫描"];
                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                              [ProgressHUD dismiss];
                                          });
                                          _isScan = YES;
                                      }
                                  }];
                                  if (!_isScan) {
                                      if ([json[@"status"] integerValue] == 200) {
                                          NSDictionary * listDic = json[@"data"][0];
                                          for (NSDictionary * dic in listDic[@"list"]) {
                                              CellModel * model = [[CellModel alloc]init];
                                              [model setValuesForKeysWithDictionary:dic];
                                              [self.dataArr addObject:model];
                                          }
                                      }else{
                                          CellModel * model = [[CellModel alloc]init];
                                          model.code = stringValue;
                                          model.x =[NSUSERDEFAULT objectForKey:@"X"];
                                          model.y =[NSUSERDEFAULT objectForKey:@"Y"];
                                          model.address = [NSUSERDEFAULT objectForKey:@"address"];
                                          model.createdTime = [self nowTime];
                                          model.checkFlag = @"N";
                                          model.suspiciousFlag = @"";
                                          model.eId = @"";
                                          model.enterprise = @"";
                                          model.networkDot = @"";
                                          model.status = @"";
                                          [self.dataArr addObject:model];
                                          [self.mainTableView reloadData];
                                          [ProgressHUD dismiss];
                                          self.inputScanTextField.text = @"";
                                      }
                                  }
                                  
                                  if (_session != nil && timer != nil) {
                                      [_session startRunning];
                                      [timer setFireDate:[NSDate date]];
                                  }
                              }
                              failure:^(NSError *error) {
                                  [ProgressHUD showError:@"网络异常，请重试"];
                                  if (_session != nil && timer != nil) {
                                      [_session startRunning];
                                      [timer setFireDate:[NSDate date]];
                                  }
                              }];

        NSArray *arry = metadataObject.corners;
        for (id temp in arry) {
            NSLog(@"%@",temp);
        }
        
    } else {
        NSLog(@"无扫描信息");
        [ProgressHUD showError:@"无扫描信息"];

        return;
    }
    
}

-(NSString *)nowTime{
    
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy年MM月dd日 HH:mm";
    
    return [formatter stringFromDate:date];
}

@end
