//
//  MCRuntimeKeyValue.h
//  MCRuntimeJSON
//
//  Created by marco chen on 2016/12/1.
//  Copyright © 2016年 marco chen. All rights reserved.
//
//  Copyright (c) 2016 czxghostyueqiu (http://blog.csdn.net/czxghostyueqiu，https://github.com/CZXBigBrother)

#import <Foundation/Foundation.h>

@interface MCRuntimeKeyValue : NSObject

+ (id)MC_RuntimeClassKey:(NSString *)name;

+ (void)MC_ObjectWithkeyValues:(NSDictionary *)dict withObjectClass:(id)Vc;

@end
