//
//  MCRuntimeURL.h
//  MCRuntimeJSON
//
//  Created by marco chen on 2016/12/1.
//  Copyright © 2016年 marco chen. All rights reserved.
//
//  Copyright (c) 2016 czxghostyueqiu (http://blog.csdn.net/czxghostyueqiu，https://github.com/CZXBigBrother )

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MCURLBridgeNative : NSObject

/**
 *  知道你们可能懒 给你们一个全自动的方法
 *  @param request web拦截的请求
 *  @param receiver 需要执行方法的对象
 *  @return 返回NO说明拦截是成功,YES说明拦截失败
 */
+ (BOOL)MC_autoExecute:(NSURLRequest *)request withReceiver:(id)receiver;
/**
 *  返回DES解密后的Request对象
 */
+ (NSURLRequest *)MC_DESDecrypt:(NSURLRequest *)request key:(NSString *)key;
/**
 *  创建并获取Controller对象
 */
+ (id)MC_getViewControllerRequestURL:(NSURLRequest *)request;
/**
 *  将创建的Controller push,如果没有navigation则执行present
 */
+ (void)MC_pushViewControllerRequestURL:(NSURLRequest *)request;
/**
 *  将创建的Controller present
 */
+ (void)MC_presentViewControllerRequestURL:(NSURLRequest *)request;
/**
 *  根据showtype字段判断是push还是present,controller,如没有这个字段则执行MC_push方法
 */
+ (void)MC_showViewControllerRequestURL:(NSURLRequest *)request;
/**
 *  执行一个本地的方法
 */
+ (void)MC_msgSendFuncRequestURL:(NSURLRequest *)request withReceiver:(id)receiver;

/**
 *  判断scheme协议是否和设定的相同
 */
+ (BOOL)MC_checkScheme:(NSURLRequest *)request;
/**
 *  判断host是不是获取controller
 */
+ (BOOL)MC_checkHostisEqualVc:(NSURLRequest *)request;
/**
 *  判断host是不是获取function
 */
+ (BOOL)MC_checkHostisEqualFunc:(NSURLRequest *)request;

@end
