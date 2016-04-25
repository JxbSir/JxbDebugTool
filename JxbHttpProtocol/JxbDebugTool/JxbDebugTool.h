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


@protocol JxbDebugDelegate <NSObject>
- (NSData*)decryptJson:(NSData*)data;
@end

@interface JxbDebugTool : NSObject

/**
 *  主色调
 */
@property (nonatomic, copy)     UIColor     *mainColor;

/**
 *  设置代理
 */
@property (nonatomic, weak) id<JxbDebugDelegate> delegate;

/**
 *  http请求数据是否加密，默认不加密
 */
@property (nonatomic, assign)   BOOL        isHttpRequestEncrypt;

/**
 *  http响应数据是否加密，默认不加密
 */
@property (nonatomic, assign)   BOOL        isHttpResponseEncrypt;

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
