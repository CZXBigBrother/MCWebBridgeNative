//
//  MCJSBridgeNative.h
//  WebBridgeNativeExample
//
//  Created by marco chen on 2016/12/15.
//  Copyright © 2016年 marco chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

@interface MCJSBridgeNative : NSObject
/**
 *  初始化
 */
+ (id)shareInstance;
/**
 *  加载JS
 */
- (void)initialize:(UIWebView *)webView;
- (void)initialize:(UIWebView *)webView withRecive:(id)receiver;
/**
 *  js对象
 */
@property (strong, nonatomic) JSContext *context;
/**
 * receiver 需要执行方法的对象
 */
@property (weak, nonatomic) id receiver;

/**
 * 返回解析的JS参数
 * @param array  [JSContext currentArguments] 就是传这个,不传其他的哦~
 */
- (NSDictionary *)getCurrentArguments:(NSArray *)array;
/**
 *  JS执行一个本地的方法
 */
- (void)MC_msgSendFuncJSContext:(NSDictionary *)data Receiver:(id)receiver;
/**
 *  创建并获取Controller对象
 */
- (id)MC_getViewControllerJSContext:(NSDictionary *)data;
/**
 *  根据showtype字段判断是push还是present,controller,如没有这个字段则执行MC_push方法
 */
- (void)MC_showViewControllerJSContext:(NSDictionary *)data;
/**
 *  将创建的Controller push,如果没有navigation则执行present
 */
- (void)MC_pushViewControllerJSContext:(NSDictionary *)data;
/**
 *  将创建的Controller present
 */
- (void)MC_presentViewControllerJSContext:(NSDictionary *)data;



@end
