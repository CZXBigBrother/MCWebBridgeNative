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
@end
