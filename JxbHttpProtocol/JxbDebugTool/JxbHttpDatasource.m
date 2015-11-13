//
//  JxbHttpDatasource.m
//  JxbHttpProtocol
//
//  Created by Peter on 15/11/13.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import "JxbHttpDatasource.h"

@implementation JxbHttpModel
@end

@implementation JxbHttpDatasource

+ (instancetype)shareInstance {
    static JxbHttpDatasource* tool;
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        tool = [[JxbHttpDatasource alloc] init];
    });
    return tool;
}

- (id)init {
    self = [super init];
    if (self) {
        _httpArray = [NSMutableArray array];
    }
    return self;
}

- (void)addHttpRequset:(JxbHttpModel*)model {
    @synchronized(self.httpArray) {
        [self.httpArray insertObject:model atIndex:0];
    }
}

- (void)clear {
    @synchronized(self.httpArray) {
        [self.httpArray removeAllObjects];
    }
}
@end
