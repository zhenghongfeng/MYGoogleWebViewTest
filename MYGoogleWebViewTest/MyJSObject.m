//
//  Person.m
//  javascriptcore测试
//
//  Created by Tian on 16/4/21.
//  Copyright © 2016年 TianTengFei. All rights reserved.
//

#import "MyJSObject.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

@protocol PersonJSExport <JSExport>

//- (void)nslog:(NSString *)str;
JSExportAs(nslog,
           - (void)printWithString:(NSString *)string callback:(NSString *)callback
           );

@end

@interface MyJSObject() <PersonJSExport>

//- (void)nslog:(NSString *)str;
//- (void)printSome;
@property(strong, nonatomic) UIWebView *webView;

@end

@implementation MyJSObject

- (instancetype)initWithWebView:(UIWebView *)webView {
    if (self = [super init]) {
        _webView = webView;
    }
    return self;
}

+ (instancetype)objectWithWebView:(UIWebView *)webView {
    return [[self alloc] initWithWebView:webView];
}

//- (void)nslog:(NSString *)str {
//    NSLog(@"测试一下JavaScript!");
//}

- (void)printWithString:(NSString *)string callback:(NSString *)callback {
    NSLog(@"%@", string);
    
    NSString *callbackJS = [NSString stringWithFormat:@"%@('我是callback')", callback];
    [self.webView stringByEvaluatingJavaScriptFromString:callbackJS];
}

@end
