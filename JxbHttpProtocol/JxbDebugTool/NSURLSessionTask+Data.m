//
//  NSURLSessionTask+Data.m
//  JxbHttpProtocol
//
//  Created by Peter on 16/2/24.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "NSURLSessionTask+Data.h"
#import <objc/runtime.h>

@implementation NSURLSessionTask (Data)

- (NSMutableData*)responseDatas {
    return objc_getAssociatedObject(self, @"responseDatas");
}

- (void)setResponseDatas:(NSMutableData*)data {
    objc_setAssociatedObject(self, @"responseDatas", data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
