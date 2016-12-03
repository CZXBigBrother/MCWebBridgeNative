//
//  MCRuntimeURL.h
//  MCRuntimeJSON
//
//  Created by marco chen on 2016/12/1.
//  Copyright © 2016年 marco chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MCRuntimeURL : NSObject

+ (id)MC_getViewControllerRequestURL:(NSURLRequest *)request;

+ (void)MC_pushViewControllerRequestURL:(NSURLRequest *)request;

+ (void)MC_presentViewControllerRequestURL:(NSURLRequest *)request;

+ (void)MC_msgSendFuncRequestURL:(NSURLRequest *)request withReceiver:(id)receiver;
@end
