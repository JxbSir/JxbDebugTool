//
//  NSURLSessionTask+Data.h
//  JxbHttpProtocol
//
//  Created by Peter on 16/2/24.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSessionTask (Data)

- (NSMutableData*)responseDatas;
- (void)setResponseDatas:(NSMutableData*)data;

@end
