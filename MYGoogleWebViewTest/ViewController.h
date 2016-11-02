//
//  ViewController.h
//  MYGoogleWebViewTest
//
//  Created by zhf on 16/9/1.
//  Copyright © 2016年 zhenghongfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSExportProtocol <JSExport>

- (void)myTest;

- (NSString *)getNameAge;

- (double)getCurrentLocationLat;

- (double)getCurrentLocationLon;

- (void)loadGoogleMapFail;

- (void)mapCenterChanged:(id)mapCenter;

- (void)mapZoomChanged:(id)mapZoom;

- (void)loadGoogleMapFinish;

- (int)getItemsCount;

// 获取纬度
- (NSString *)getItemLat:(int)index;

// 获取经度
- (NSString *)getItemLon:(int)index;

- (NSString *)getMyLocationIcon;

- (void)onMarkerClicked:(int)index;

// 获取icon
- (NSString *)getIconPath:(int)index;

- (NSString *)getItemName:(int)index;

- (NSString *)getItemSubName:(int)index;

- (void)onInfoWindowClicked:(int)index;

- (void)visibleMapRect:(id)mapRect;

- (NSString *)getHighlightIconPath:(int)index;

- (double)getHighlightIconWidth:(int)index;

- (double)getHighlightIconHeight:(int)index;

// 反编码后的地理位置

- (void)getPlace:(id)place;



@end

@interface ViewController : UIViewController



@end

