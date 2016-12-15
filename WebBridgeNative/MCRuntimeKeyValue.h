//
//  MCRuntimeKeyValue.h
//  MCRuntimeJSON
//
//  Created by marco chen on 2016/12/1.
//  Copyright © 2016年 marco chen. All rights reserved.
//
//  Copyright (c) 2016 czxghostyueqiu (http://blog.csdn.net/czxghostyueqiu，https://github.com/CZXBigBrother)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MCRuntimeKeyValue : NSObject

+ (id)MC_RuntimeClassKey:(NSString *)name;

+ (void)MC_ObjectWithkeyValues:(NSDictionary *)dict withObjectClass:(id)Vc;

+ (void)MC_msgSendFuncData:(NSDictionary *)data withReceiver:(id)receiver;

+ (id)MC_getViewControllerData:(NSDictionary *)data;

+ (UIViewController *)getCurrentVCFromRootViewController:(UIViewController *)rootVC;

+ (UIViewController *)getCurrentVC;
@end
