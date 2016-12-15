//
//  MCRuntimeKeyValue.m
//  MCRuntimeJSON
//
//  Created by marco chen on 2016/12/1.
//  Copyright © 2016年 marco chen. All rights reserved.
//
#import "MCWebBridgeNative.h"
#import "MCRuntimeKeyValue.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation MCRuntimeKeyValue

+ (id)MC_RuntimeClassKey:(NSString *)name {
    return [[NSClassFromString(name) alloc]init];
}
+ (NSArray *)MCStringPropertyKey:(NSString *)name {
    NSMutableArray * temp = [NSMutableArray array];
    u_int count;
    objc_property_t *properties=class_copyPropertyList([NSClassFromString(name) class], &count);
    for (int i = 0; i < count ; i++) {
        const char* propertyName = property_getName(properties[i]);
        NSString *strName = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        [temp addObject:strName];
    }
    return [NSArray arrayWithArray:temp];
}
//这里可以改成MJExtension就可支持自定义类的赋值
+ (void)MC_ObjectWithkeyValues:(NSDictionary *)dict withObjectClass:(id)Vc {
    NSArray * arrAttr = [MCRuntimeKeyValue MCStringPropertyKey:[NSString stringWithUTF8String:object_getClassName(Vc)]];
    for (NSString * objAttr in arrAttr) {
        if ([dict objectForKey:objAttr]) {
            [Vc setValue:[dict objectForKey:objAttr] forKey:objAttr];
        }
    }
}


+ (void)MC_msgSendFuncData:(NSDictionary *)data withReceiver:(id)receiver {
    if ([data objectForKey:MCFunc]) {
        SEL actionSelector = NSSelectorFromString([data objectForKey:MCFunc]);
        if ([receiver respondsToSelector:actionSelector]) {
            if (data.allKeys.count > 1) {
                NSMutableDictionary * tempDict = [NSMutableDictionary dictionaryWithDictionary:data];
                [tempDict removeObjectForKey:MCFunc];
                [tempDict removeObjectForKey:MCType];
                objc_msgSend(receiver,actionSelector,tempDict);
            }else {
                objc_msgSend(receiver,actionSelector);
            }
        };
    }
}

+ (id)MC_getViewControllerData:(NSDictionary *)data {
    if ([data objectForKey:MCClass]) {
        id vc = [MCRuntimeKeyValue MC_RuntimeClassKey:[data objectForKey:MCClass]];
        [MCRuntimeKeyValue MC_ObjectWithkeyValues:data withObjectClass:vc];
        return vc;
    }else {
        return nil;
    }
}




#pragma mark - getCurrentViewController
+ (UIViewController *)getCurrentVCFromRootViewController:(UIViewController *)rootVC
{
    UIViewController *currentVC = rootVC;
    
    if ([currentVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)currentVC;
        currentVC = nav.topViewController;
        
        return [self getCurrentVCFromRootViewController:currentVC];
    }
    if (currentVC.presentedViewController) {
        currentVC = currentVC.presentedViewController;
        
        return [self getCurrentVCFromRootViewController:currentVC];
    }
    
    return currentVC;
}
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    return [self getCurrentVCFromRootViewController:rootVC];
}

@end
