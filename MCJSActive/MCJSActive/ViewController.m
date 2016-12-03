//
//  ViewController.m
//  MCJSActive
//
//  Created by marco chen on 2016/12/2.
//  Copyright © 2016年 marco chen. All rights reserved.
//

#import "ViewController.h"
#import "MCRuntime.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    self.webView.delegate = self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo.html" ofType:nil];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:html baseURL:nil];
    [self.view addSubview:self.webView];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//  mc://fun?class=TestViewViewController&dataString=MC很帅&dataInteger=123
    if ([request.URL.scheme isEqualToString:@"mc"]) {
        NSURLComponents *urlComponents = [[NSURLComponents alloc]initWithString:request.URL.absoluteString];
        NSArray * quryItems = [[urlComponents query] componentsSeparatedByString:@"&"];
        if ([urlComponents.host isEqualToString:@"mcvc"]) {
            [MCRuntimeURL MC_pushViewControllerRequestURL:request];
        }else {
            [MCRuntimeURL MC_msgSendFuncRequestURL:request withReceiver:self];
        }
        return NO;
    }
    return YES;
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
    NSLog(@"test");
}

@end
