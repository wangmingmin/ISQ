//
//  BDMLocationController.m
//  ISQ
//
//  Created by mac on 15-6-19.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "BDMLocationController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@implementation BDMLocationController{
    
    CLLocationManager  *locationManager;
    BMKLocationService *_locService;
    BMKGeoCodeSearch* _geocodesearch;
    HomeViewController *homeVC;
    AppDelegate *locationDelegate;
}

CGFloat  TheLat;
CGFloat  TheLong;


-(void)startLocation{
    
     locationDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    //用来判断定位是否被允许
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    
    homeVC=[[HomeViewController alloc]init];
    
    //反响检索
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate=self;
    
}

//百度地图定位
-(void)baiduMapLocationL{
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];

}

//用来判断定位是否被允许
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
        
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            
            //1.5s将地理位置放进反向检索容器中
            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(startGeoPiont) userInfo:nil repeats:NO];
            
            //反响检索
            _geocodesearch = [[BMKGeoCodeSearch alloc]init];
            _geocodesearch.delegate=self;
            //启动LocationService
            [_locService startUserLocationService];
            
            //百度地图定位
            [self baiduMapLocationL];
            break;
            
        default:
            break;
    }
}

//百度地图反响检索服务
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{

    if (error == 0) {
        
        locationDelegate.theAddress=result.address;
        locationDelegate.theAddress_city=result.addressDetail.city;
        locationDelegate.theDistrict=result.addressDetail.district;
        locationDelegate.theLa=TheLat;
        locationDelegate.theLo=TheLong;
        
        
        //更新gps之后更新本地精选的商户
        [[NSNotificationCenter defaultCenter] postNotificationName:@"locationBussnisce_Notification" object:nil];
        
        [_locService stopUserLocationService];
        
    }
    
    
}


//将坐标放入到检索容器中
-(void)startGeoPiont{
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){TheLat, TheLong};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    
    
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        
        NSLog(@"反geo检索发送成功");
        
        
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
    
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    TheLat=userLocation.location.coordinate.latitude;
    TheLong=userLocation.location.coordinate.longitude;
    
    
    ISQLog(@"经纬度---%f-----%f",TheLat,TheLong);
    
    }

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    
    
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"百度定位error---%@",error);
    
    //定位失败时启用iP定位
    [self baiduIP];
    
    
}

-(void)baiduIP{
    
    
    
    NSDictionary *arry=@{@"ak":BAIDUIPLOCATIONKEY,@"coor":@"bd09ll"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:BAIDUIPLOCATIONURL parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding error:nil];
        
        CGFloat x=(data[@"content"][@"point"][@"x"]&&[data[@"content"][@"point"][@"y"] length]>0)?[data[@"content"][@"point"][@"x"] floatValue]:0.f;
        CGFloat y=(data[@"content"][@"point"][@"y"]&&[data[@"content"][@"point"][@"y"] length]>0)?[data[@"content"][@"point"][@"y"] floatValue]:0.f;
        
        TheLat =y;
        TheLong=x;
        
       
        
        [self startGeoPiont];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您好，爱社区获取当前地理位置信息失败，为了更好的为您服务，请检查爱社区是否允许被定位！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
    }];

}


-(void)dealloc{
    
    _locService=nil;
    _geocodesearch=nil;
    
}


@end
