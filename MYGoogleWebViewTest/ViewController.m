//
//  ViewController.m
//  MYGoogleWebViewTest
//
//  Created by zhf on 16/9/1.
//  Copyright © 2016年 zhenghongfeng. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "WebViewJavascriptBridge.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "BYShop.h"
#import "WGS84TOGCJ02.h"

@interface ViewController () <CLLocationManagerDelegate, UIWebViewDelegate, JSExportProtocol>

@property (strong, nonatomic) JSContext *context;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property WebViewJavascriptBridge *bridge;

@property (nonatomic, assign) CLLocationCoordinate2D currentCoord;

@property (nonatomic, strong) NSMutableArray *shops;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *currentButton;

@property (nonatomic, strong) NSArray *coordinateArray;

@end

@implementation ViewController

#pragma mark - lazy load

- (CLLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    return _locationManager;
}

- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
        NSString *urlString = [[NSBundle mainBundle] pathForResource:@"GoogleMap" ofType:@"html"];
        NSURL *url = [NSURL URLWithString:urlString];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    return _webView;
}

- (UIButton *)currentButton
{
    if (_currentButton == nil) {
        _currentButton = [[UIButton alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height - 40, 30, 30)];
        _currentButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
        [_currentButton setBackgroundImage:[UIImage imageNamed:@"currentLocation.png"] forState:UIControlStateNormal];
        [_currentButton addTarget:self action:@selector(currentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _currentButton;
}
    
#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.shops = @[].mutableCopy;
    self.coordinateArray = [NSArray array];
    
    [self.view addSubview:self.webView];
    
    [self.view addSubview:self.currentButton];
    
    [self.locationManager startUpdatingLocation];
    
//    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 200, 30)];
//    self.textField.borderStyle = UITextBorderStyleRoundedRect;
//    [self.view addSubview:self.textField];
//    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(230, 100, 50, 30)];
//    button.backgroundColor = [UIColor whiteColor];
//    [button setTitle:@"搜索" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];

}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"CTGoogleMapView"] = self;
    
//    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"test()"]];
}

#pragma mark -  JSExportProtocol

#pragma mark - 谷歌地图初始化加载完毕

- (void)loadGoogleMapFinish
{
    NSLog(@"loadGoogleMapFinish");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getVisibleMapRect()"]];
    });
}

#pragma mark - 谷歌地图初始化加载失败

- (void)loadGoogleMapFail
{
    NSLog(@"loadGoogleMapFail");
}

#pragma mark - 获取地图的矩形框的经纬度

- (void)visibleMapRect:(id)mapRect
{
    NSLog(@"visibleMapRect = %@", mapRect);
    
    self.coordinateArray = mapRect;
    
    [self requestData];
}

- (void)myTest
{
    NSLog(@"myTest");
}

- (NSString *)getNameAge
{
    return @"zheng";
}

- (double)getCurrentLocationLat
{
    return self.currentCoord.latitude;
}

- (double)getCurrentLocationLon
{
    return self.currentCoord.longitude;
}

- (void)mapCenterChanged:(id)mapCenter
{
    NSLog(@"mapCenterChanged");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"clearMarkers()"]];
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getVisibleMapRect()"]];
}

#pragma mark - 地图缩放手势改变

- (void)mapZoomChanged:(id)mapZoom
{
    NSLog(@"mapZoomChanged = %@", mapZoom);
}


- (int)getItemsCount
{
    NSLog(@"getItemsCount = %zd", self.shops.count);
    return (int)self.shops.count;
}

- (NSString *)getItemLat:(int)index
{
    BYShop *shop = self.shops[index];
    return shop.latitude;
}

- (NSString *)getItemLon:(int)index
{
    BYShop *shop = self.shops[index];
    return shop.longitude;
}

- (NSString *)getMyLocationIcon
{
    return @"common_ico_map_locate.png";
}

- (void)onMarkerClicked:(int)index
{
    NSLog(@"onMarkerClicked点击了%d", index);
}

- (NSString *)getItemName:(int)index
{
    BYShop *shop = self.shops[index];
    return shop.name;
}

- (void)onInfoWindowClicked:(int)index
{
    NSLog(@"onInfoWindowClicked点击了%d", index);
    BYShop *shop = self.shops[index];
    NSLog(@"name = %@, category = %@, description = %@", shop.name, shop.category, shop.myDescription);
    
}

//- (NSString *)getIconPath:(int)index
//{
//    
//}


//- (NSString *)getHighlightIconPath:(int)index
//{
//    
//}
//
//- (double)getHighlightIconWidth:(int)index
//{
//    
//}
//
//- (double)getHighlightIconHeight:(int)index
//{
//    
//}

#pragma mark - custom event

- (void)currentButtonClick
{
    NSLog(@"currentButtonClick");
    // 将当前位置的经纬度传给js的setMyLocation()函数
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setMyLocation(%f, %f)", self.currentCoord.latitude, self.currentCoord.longitude]];
}

- (void)buttonClick
{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"geocodeAddress('%@')", self.textField.text]];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *loc = [locations objectAtIndex:0];
    self.currentCoord = loc.coordinate;
    
    //判断是不是属于国内范围
//    if (![WGS84TOGCJ02 isLocationOutOfChina:[loc coordinate]]) {
//        //转换后的coord
//        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[loc coordinate]];
//        self.currentCoord = coord;
//    } else {
//        self.currentCoord = loc.coordinate;
//    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"用户还未决定");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"访问受限");
            break;
        case kCLAuthorizationStatusDenied:
            // 定位是否可用（是否支持定位或者定位是否开启）
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位开启，但被拒");
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请在手机设置-隐私-定位服务中允许访问位置信息" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:@"prefs:root=info.binyou.binyouhulian"];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                NSLog(@"定位关闭，不可用");
            }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"获取前后台定位授权");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"获取后台定位授权");
            break;
        default:
            break;
    }
}

#pragma mark - net request

- (void)requestData
{
    NSString *swLat = self.coordinateArray[0];
    NSString *swLng = self.coordinateArray[1];
    NSString *neLat = self.coordinateArray[2];
    NSString *neLng = self.coordinateArray[3];
    
    NSDictionary *dic = @{
                          @"lowerlong": swLng,
                          @"lowerlati": swLat,
                          @"upperlong": neLng,
                          @"upperlati": neLat,
                          @"key": @""
                          };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[@"http://123.56.186.178/api" stringByAppendingString:@"/shop/search?"] parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 1) {
            [self.shops removeAllObjects];
            
            self.shops = [BYShop mj_objectArrayWithKeyValuesArray:responseObject[@"stores"]];
            NSLog(@"shops = %@", self.shops);
            
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"addMarkers()"]];
        } else {
            NSLog(@"error = %@", responseObject[@"msg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error.localizedDescription);
        
    }];
}

@end
