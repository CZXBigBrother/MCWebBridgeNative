//
//  MCRuntimeURL.m
//  MCRuntimeJSON
//
//  Created by marco chen on 2016/12/1.
//  Copyright © 2016年 marco chen. All rights reserved.
//
#import "MCRuntime.h"
#import "MCRuntimeURL.h"
#import <objc/message.h>

typedef enum : NSUInteger {
    ObjTypeDict = 0,
    ObjTypeArray = 1
}ObjType;

@implementation MCRuntimeURL

+ (id)SeparatedByqueryItems:(NSURLComponents *)urlComponents withType:(ObjType)type {
    NSMutableArray * tempArr = [NSMutableArray array];
    NSMutableDictionary * tempDict = [NSMutableDictionary dictionary];
    if ([urlComponents respondsToSelector:@selector(queryItems)]) {
        NSArray * quryItems = [urlComponents queryItems];
        for (NSURLQueryItem * oneItem in quryItems) {
            switch (type) {
                case ObjTypeDict:
                {
                    [tempDict setValue:oneItem.value forKey:oneItem.name];
                }
                    break;
                case ObjTypeArray:
                {
                    [tempArr addObject:@{oneItem.name:oneItem.value}];
                }
                    break;
                default:
                    break;
            }
        }
    }else {
        switch (type) {
            case ObjTypeDict:
                tempDict = [self SeparatedByUrlItems:urlComponents withType:type];
            case ObjTypeArray:
                tempArr = [self SeparatedByUrlItems:urlComponents withType:type];
            default:
                break;
        }
    }
    switch (type) {
        case ObjTypeDict:
            return tempDict;
        case ObjTypeArray:
            return tempArr;
        default:
            return nil;
            break;
    }
}
+ (id)SeparatedByUrlItems:(NSURLComponents *)urlComponents withType:(ObjType)type {
    NSMutableArray * tempArr = [NSMutableArray array];
    NSMutableDictionary * tempDict = [NSMutableDictionary dictionary];
    NSArray * quryItems = [[urlComponents query] componentsSeparatedByString:@"&"];
    for (NSString *oneItem in quryItems) {
        NSArray *queryNameValue = [oneItem componentsSeparatedByString:@"="];
        switch (type) {
            case ObjTypeDict:
            {
                [tempDict setValue:[queryNameValue lastObject] forKey:[queryNameValue firstObject]];
            }
                break;
            case ObjTypeArray:
            {
                [tempArr addObject:@{[queryNameValue firstObject]:[queryNameValue lastObject]}];
            }
                break;
            default:
                break;
        }
    }
    switch (type) {
        case ObjTypeDict:
            return tempDict;
        case ObjTypeArray:
            return tempArr;
        default:
            return nil;
            break;
    }
}

+ (NSArray *)SeparatedByqueryItemsArray:(NSURLComponents *)urlComponents {
    return (NSArray *)[self SeparatedByqueryItems:urlComponents withType:ObjTypeArray];
}
+ (NSDictionary *)SeparatedByqueryItemsDict:(NSURLComponents *)urlComponents {
    return (NSDictionary *)[self SeparatedByqueryItems:urlComponents withType:ObjTypeDict];
}

+ (NSString *)findKey:(NSString *)key withArray:(NSArray *)arr {
    for (NSDictionary * data in arr) {
        if ([data objectForKey:key]) {
            return [data objectForKey:key];
        }
    }
    return nil;
}
+ (void)MC_msgSendFuncRequestURL:(NSURLRequest *)request withReceiver:(id)receiver {
    NSURLComponents *urlComponents = [[NSURLComponents alloc]initWithString:request.URL.absoluteString];
    NSDictionary * data = [self SeparatedByUrlItems:urlComponents withType:ObjTypeDict];
    if ([data objectForKey:@"func"]) {
        SEL actionSelector = NSSelectorFromString([data objectForKey:@"func"]);
        if ([receiver respondsToSelector:actionSelector]) {
            if (data.allKeys.count > 1) {
                NSMutableDictionary * tempDict = [NSMutableDictionary dictionaryWithDictionary:data];
                [tempDict removeObjectForKey:@"func"];
                objc_msgSend(receiver,actionSelector,tempDict);
            }else {
                objc_msgSend(receiver,actionSelector);
            }
        };
    }
}

+ (id)MC_getViewControllerRequestURL:(NSURLRequest *)request {
    NSURLComponents *urlComponents = [[NSURLComponents alloc]initWithString:request.URL.absoluteString];
    NSDictionary * data = [self SeparatedByqueryItemsDict:urlComponents];
    if ([data objectForKey:classProject]) {
        id vc = [MCRuntimeKeyValue MC_RuntimeClassKey:[data objectForKey:classProject]];
        [MCRuntimeKeyValue MC_ObjectWithkeyValues:data withObjectClass:vc];
        return vc;
    }else {
        return nil;
    }
}
+ (void)MC_pushViewControllerRequestURL:(NSURLRequest *)request {
    if ([[[[[UIApplication sharedApplication] delegate] window] rootViewController] isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [nav pushViewController:[self MC_getViewControllerRequestURL:request] animated:YES];
    }
}
+ (void)MC_presentViewControllerRequestURL:(NSURLRequest *)request {
    [[self getCurrentVC]presentViewController:[self MC_getViewControllerRequestURL:request] animated:YES completion:nil];
}
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
