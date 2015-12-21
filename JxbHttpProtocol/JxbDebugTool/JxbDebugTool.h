//
//  JxbDebugTool.h
//  JxbHttpProtocol
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/11/12.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kNotifyKeyReloadHttp    @"kNotifyKeyReloadHttp"


@interface JxbDebugTool : NSObject

/**
 *  主色调
 */
@property (nonatomic, copy)     UIColor     *mainColor;

/**
 *  日志最大数量，默认50条
 */
@property (nonatomic, assign)   int         maxLogsCount;

/**
 *  设置只抓取的域名，忽略大小写，默认抓取所有
 */
@property (nonatomic, strong)   NSArray     *arrOnlyHosts;


+ (instancetype)shareInstance;
/**
 *  启用
 */
- (void)enableDebugMode;


@end
