//
//  MCRuntimeKeyValue.m
//  MCRuntimeJSON
//
//  Created by marco chen on 2016/12/1.
//  Copyright © 2016年 marco chen. All rights reserved.
//

#import "MCRuntimeKeyValue.h"
#import <objc/runtime.h>

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
@end
