//
//  ViewController.m
//  MCJSActive
//
//  Created by marco chen on 2016/12/2.
//  Copyright © 2016年 marco chen. All rights reserved.
//

#import "ViewController.h"
#import "MCRuntime.h"

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
    //mc://fun?class=TestViewViewController&dataString=MC很帅&dataInteger=123
    if ([request.URL.scheme isEqualToString:@"mc"]) {
        [MCRuntimeURL MC_pushViewControllerRequestURL:request];

//        [MCRuntimeURL MC_presentViewControllerRequestURL:request];
        
//        UIViewController * vc = (UIViewController *)[MCRuntimeURL MC_getViewControllerRequestURL:request];
//        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}

@end
