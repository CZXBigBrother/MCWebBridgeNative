//
//  MCRuntimeURL.h
//  MCRuntimeJSON
//
//  Created by marco chen on 2016/12/1.
//  Copyright © 2016年 marco chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MCURLBridgeNative : NSObject
/**
 *  知道你们懒 给你们一个全自动的方法
 */
+ (BOOL)MC_autoExecute:(NSURLRequest *)request withReceiver:(id)receiver;
/**
 *  创建并获取Controller对象
 */
+ (id)MC_getViewControllerRequestURL:(NSURLRequest *)request;
/**
 *  将创建的Controller push
 */
+ (void)MC_pushViewControllerRequestURL:(NSURLRequest *)request;
/**
 *  将创建的Controller present
 */
+ (void)MC_presentViewControllerRequestURL:(NSURLRequest *)request;
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
