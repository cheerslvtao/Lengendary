//
//  AppDelegate.m
//  Lengendary
//
//  Created by 张世龙 on 17/3/17.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<CLLocationManagerDelegate>
{
    CLLocationManager * _locationManager;
    CLGeocoder * _geocoder;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self createLocation];
        
    return YES;
}

-(void)createLocation
{
    //初始化定位管理器
    _locationManager = [[CLLocationManager alloc]init];
    _geocoder = [[CLGeocoder alloc]init];
    //设置代理
    _locationManager.delegate = self;
    //设置精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //定位频率，也就是每隔多少米定位一次
    _locationManager.distanceFilter = 10.0;//每隔10米定位一次

    //判断定位服务是否打开
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务目前尚未打开，请设置打开");
        return;
    }
    
    //如果没有授权则当使用定位的时候请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }
    //如果已经授权
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
        
    }
}
#pragma mark - 定位的代理方法
//跟踪定位的代理方法，一旦位置发生变化则会调用这个方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation * location = [locations firstObject];//取出第一个位置
    //获得位置坐标
    CLLocationCoordinate2D coord = location.coordinate;
    CGFloat X = coord.longitude;
    CGFloat Y = coord.latitude;
    [NSUSERDEFAULT setObject:@(X) forKey:@"X"];
    [NSUSERDEFAULT setObject:@(Y) forKey:@"Y"];
    [NSUSERDEFAULT synchronize];
    //如果不使用定位服务，使用完成之后及时关闭定位
    [manager stopUpdatingLocation];
    //获取详细的地理位置信息
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark * placemark = [placemarks firstObject];
        NSArray * FormattedAddressLines = placemark.addressDictionary[@"FormattedAddressLines"];
        [NSUSERDEFAULT setObject:FormattedAddressLines.count?FormattedAddressLines[0]:@"" forKey:@"address"];
        [NSUSERDEFAULT synchronize];
        NSLog(@"详细信息~~~%@",FormattedAddressLines.count?FormattedAddressLines[0]:@"");
        
    }];
    NSLog(@"经度%f~~纬度%f~~海拔%f~~航向%f~~行走速度%f",coord.longitude,coord.latitude,location.altitude,location.course,location.speed);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager startUpdatingLocation];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
