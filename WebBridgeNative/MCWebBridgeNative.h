//
//  MCRuntime.h
//  MCRuntimeJSON
//
//  Created by marco chen on 2016/12/1.
//  Copyright © 2016年 marco chen. All rights reserved.
//
//  Copyright (c) 2016 czxghostyueqiu (http://blog.csdn.net/czxghostyueqiu，https://github.com/CZXBigBrother)

#ifndef MCRuntime_h
#define MCRuntime_h
//    OC          对照    js对象
//    nil          |     undefined
//    NSNull       |     null
//    NSString     |     string
//    NSNumber     |     number, boolean
//    NSDictionary |     Object object
//    NSArray      |     Array object
//    NSDate       |     Date object
//    NSBlock (1)  |     Function object (1)
//    id (2)       |     Wrapper object (2)
//    Class (3)    |     Constructor object (3)
#define MCFunc @"func"
#define MCClass @"class"
#define MCHostFunc @"mcfunc"
#define MCHostVc @"mcvc"
#define MCScheme @"mc"
#define MCShowType @"showtype"
#define MCType @"type"

#endif /* MCRuntime_h */
#import "MCRuntimeKeyValue.h"
#import "MCURLBridgeNative.h"
#import "MCJSBridgeNative.h"
#import "MCEncrypt.h"

#define WEAK_SELF __weak typeof(self) weakSelf = self
