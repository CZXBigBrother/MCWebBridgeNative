//
//  ViewController.m
//  WebBridgeNativeExample
//
//  Created by marco chen on 2016/12/3.
//  Copyright © 2016年 marco chen. All rights reserved.
//

#import "ViewController.h"
#import "MCWebBridgeNative.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (strong, nonatomic) JSContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    self.webView.delegate = self;
    NSString *html = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"demo.html" ofType:nil] encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:html baseURL:nil];
    [self.view addSubview:self.webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    if ([MCURLBridgeNative MC_checkScheme:request]) {
//        return [MCURLBridgeNative MC_autoExecute:[MCURLBridgeNative MC_DESDecrypt:request key:@"mc"] withReceiver:self];
//    }
    return [MCURLBridgeNative MC_autoExecute:request withReceiver:self];
}

- (void)test {
    [self test:nil];
}
- (void)test:(NSString *)data {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"执行一个方法" message:@"内容" preferredStyle:UIAlertControllerStyleAlert];
    if (data) {
        alert.message = [NSString stringWithFormat:@"%@",data.description];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
