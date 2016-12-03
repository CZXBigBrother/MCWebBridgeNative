//
//  MCRuntimeKeyValue.h
//  MCRuntimeJSON
//
//  Created by marco chen on 2016/12/1.
//  Copyright © 2016年 marco chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCRuntimeKeyValue : NSObject

+ (id)MC_RuntimeClassKey:(NSString *)name;
+ (void)MC_ObjectWithkeyValues:(NSDictionary *)dict withObjectClass:(id)Vc;

@end
