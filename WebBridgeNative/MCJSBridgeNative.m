//
//  MCJSBridgeNative.m
//  WebBridgeNativeExample
//
//  Created by marco chen on 2016/12/15.
//  Copyright © 2016年 marco chen. All rights reserved.
//

#import "MCJSBridgeNative.h"
#import "MCWebBridgeNative.h"

@interface  MCJSBridgeNative()
@property (copy, nonatomic) void (^currentArgumentsCallback)(NSDictionary *data);
@property(strong, nonatomic) NSDictionary *currentData;

@end

@implementation MCJSBridgeNative
//    nil         |     undefined
//    NSNull       |        null
//    NSString      |       string
//    NSNumber      |   number, boolean
//    NSDictionary    |   Object object
//    NSArray       |    Array object
//    NSDate       |     Date object
//    NSBlock (1)   |   Function object (1)
//    id (2)     |   Wrapper object (2)
//    Class (3)    | Constructor object (3)

+ (id)shareInstance
{
    static MCJSBridgeNative *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MCJSBridgeNative alloc] init];
    });
    
    return _sharedClient;
}
- (void)initialize:(UIWebView *)webView withRecive:(id)receiver{
    [self initialize:webView];
    self.receiver = receiver;
}
- (void)initialize:(UIWebView *)webView {
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    WEAK_SELF;
    self.context[MCScheme] = ^(){
        [weakSelf waitExecute:[weakSelf SeparatedByCurrentArguments:[JSContext currentArguments]]];
    };
}
- (void)setContext:(JSContext *)context {
    _context = context;
}
- (void)waitExecute:(NSDictionary *)data {
    if ([MCJSBridgeNative MC_checkDataisEqualVc:data]) {
        [self MC_showViewControllerJSContext:data];
    }else if ([MCJSBridgeNative MC_checkDataisEqualFunc:data]) {
        [self MC_msgSendFuncJSContext:data Receiver:self.receiver];
    }
}
#pragma mark - check data
+ (BOOL)MC_checkDataisEqualVc:(NSDictionary *)data {
    return [[data objectForKey:MCType]isEqualToString:MCHostVc];
}
+ (BOOL)MC_checkDataisEqualFunc:(NSDictionary *)data{
    return [[data objectForKey:MCType]isEqualToString:MCHostFunc];
}
#pragma mark - find param
- (NSDictionary *)SeparatedByCurrentArguments:(NSArray *)array {
    for (JSValue * obj in [JSContext currentArguments]) {
        if ([obj isObject]) {
            return [obj toObject];
        }
    }
    return nil;
}
- (NSDictionary *)getCurrentArguments:(NSArray *)array {
   return [self SeparatedByCurrentArguments:array];
}
#pragma mark - executeFunc
- (void)MC_msgSendFuncJSContext:(NSDictionary *)data Receiver:(id)receiver {
    [MCRuntimeKeyValue MC_msgSendFuncData:data withReceiver:receiver];
}
#pragma mark - showViewController
- (id)MC_getViewControllerJSContext:(NSDictionary *)data {
    return [MCRuntimeKeyValue MC_getViewControllerData:data];
}

- (void)MC_pushViewControllerJSContext:(NSDictionary *)data {
    if ([[[[[UIApplication sharedApplication] delegate] window] rootViewController] isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [nav pushViewController:[self MC_getViewControllerJSContext:data] animated:YES];
    }else {
        [self MC_presentViewControllerJSContext:data];
    }
}
- (void)MC_presentViewControllerJSContext:(NSDictionary *)data {
    [[MCRuntimeKeyValue getCurrentVC] presentViewController:[self MC_getViewControllerJSContext:data] animated:YES completion:nil];
}
- (void)MC_showViewControllerJSContext:(NSDictionary *)data {
    if ([[data objectForKey:MCShowType]isEqualToString:@"present"]) {
        [self MC_presentViewControllerJSContext:data];
    }else {
        [self MC_pushViewControllerJSContext:data];
    }
}
@end
