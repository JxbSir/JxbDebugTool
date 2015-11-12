//
//  JxbCrashHelper.h
//  JxbHttpProtocol
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/11/12.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JxbCrashHelper : NSObject
+ (instancetype)sharedInstance;
- (void)install;
- (NSDictionary* )crashForKey:(NSString* )key;
- (NSArray* )crashPlist;
- (NSArray* )crashLogs;
@end
