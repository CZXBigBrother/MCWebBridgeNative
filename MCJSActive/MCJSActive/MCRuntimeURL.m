//
//  MCRuntimeURL.m
//  MCRuntimeJSON
//
//  Created by marco chen on 2016/12/1.
//  Copyright © 2016年 marco chen. All rights reserved.
//

#import "MCRuntimeURL.h"
#import "MCRuntimeKeyValue.h"

#define classProject @"class"

@implementation MCRuntimeURL

+ (NSArray *)SeparatedByqueryItems:(NSURLComponents *)urlComponents {
    NSMutableArray * tempArr = [NSMutableArray array];
    if ([urlComponents respondsToSelector:@selector(queryItems)]) {
        NSArray * quryItems = [urlComponents queryItems];
        for (NSURLQueryItem * oneItem in quryItems) {
            [tempArr addObject:@{oneItem.name:oneItem.value}];
        }
    }else {
        NSArray * quryItems = [[urlComponents query] componentsSeparatedByString:@"&"];
        for (NSString *oneItem in quryItems) {
            NSArray *queryNameValue = [oneItem componentsSeparatedByString:@"="];
            [tempArr addObject:@{[queryNameValue firstObject]:[queryNameValue lastObject]}];
        }
    }
    return tempArr;
}
+ (NSDictionary *)SeparatedByqueryItemsDict:(NSURLComponents *)urlComponents {
    NSMutableDictionary * tempArr = [NSMutableDictionary dictionary];
    if ([urlComponents respondsToSelector:@selector(queryItems)]) {
        NSArray * quryItems = [urlComponents queryItems];
        for (NSURLQueryItem * oneItem in quryItems) {
            [tempArr setValue:oneItem.value forKey:oneItem.name];
        }
    }else {
        NSArray * quryItems = [[urlComponents query] componentsSeparatedByString:@"&"];
        for (NSString *oneItem in quryItems) {
            NSArray *queryNameValue = [oneItem componentsSeparatedByString:@"="];
            [tempArr setValue:[queryNameValue lastObject] forKey:[queryNameValue firstObject]];

        }
    }
    return tempArr;
}

+ (NSString *)findKey:(NSString *)key withArray:(NSArray *)arr {
    for (NSDictionary * data in arr) {
        if ([data objectForKey:key]) {
            return [data objectForKey:key];
        }
    }
    return nil;
}

+ (id)MC_getViewControllerRequestURL:(NSURLRequest *)request {
    NSURLComponents *urlComponents = [[NSURLComponents alloc]initWithString:request.URL.absoluteString];
    NSDictionary * data = [self SeparatedByqueryItemsDict:urlComponents];
    id vc = [MCRuntimeKeyValue MC_RuntimeClassKey:[data objectForKey:classProject]];
    [MCRuntimeKeyValue MC_ObjectWithkeyValues:data withObjectClass:vc];
    return vc;
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
// 循环获取 Window 当前显示 VC
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
