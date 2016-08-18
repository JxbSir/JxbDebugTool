//
//  JxbHttpDatasource.m
//  JxbHttpProtocol
//
//  Created by Peter on 15/11/13.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import "JxbHttpDatasource.h"
#import "NSURLRequest+Identify.h"
#import "NSURLResponse+Data.h"
#import "NSURLSessionTask+Data.h"
#import "JxbDebugTool.h"

@implementation JxbHttpModel

#pragma mark - deal with response
+ (void)dealwithResponse:(NSData *)data resp:(NSURLResponse*)resp req:(NSURLRequest *)req {
    JxbHttpModel* model = [[JxbHttpModel alloc] init];
    model.requestId = req.requestId;
    model.url = resp.URL;
    model.mineType = resp.MIMEType;
    if (req.HTTPBody) {
        NSData* data = req.HTTPBody;
        if ([[JxbDebugTool shareInstance] isHttpRequestEncrypt]) {
            if ([[JxbDebugTool shareInstance] delegate] && [[JxbDebugTool shareInstance].delegate respondsToSelector:@selector(decryptJson:)]) {
                data = [[JxbDebugTool shareInstance].delegate decryptJson:req.HTTPBody];
            }
        }
        model.requestBody = [JxbHttpDatasource prettyJSONStringFromData:data];
    }
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)resp;
    model.method = httpResponse.allHeaderFields[@"Allow"];
    model.statusCode = [NSString stringWithFormat:@"%d",(int)httpResponse.statusCode];
    model.responseData = data;
    model.isImage = [resp.MIMEType rangeOfString:@"image"].location != NSNotFound;
    
    model.totalDuration = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSince1970] - req.startTime.doubleValue];
    model.startTime = [NSString stringWithFormat:@"%fs",req.startTime.doubleValue];
    
    [[JxbHttpDatasource shareInstance] addHttpRequset:model];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyKeyReloadHttp object:nil];
    });

}

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
        _arrRequest = [NSMutableArray array];
    }
    return self;
}

- (void)addHttpRequset:(JxbHttpModel*)model {
    @synchronized(self.httpArray) {
        [self.httpArray insertObject:model atIndex:0];
        
    }
    @synchronized(self.arrRequest) {
        if (model.requestId&& model.requestId.length > 0) {
            [self.arrRequest addObject:model.requestId];
        }
    }
}

- (void)clear {
    @synchronized(self.httpArray) {
        [self.httpArray removeAllObjects];
    }
    @synchronized(self.arrRequest) {
        [self.arrRequest removeAllObjects];
    }
}


#pragma mark - parse
+ (NSString *)prettyJSONStringFromData:(NSData *)data
{
    NSString *prettyString = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    if ([NSJSONSerialization isValidJSONObject:jsonObject]) {
        prettyString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:NULL] encoding:NSUTF8StringEncoding];
        // NSJSONSerialization escapes forward slashes. We want pretty json, so run through and unescape the slashes.
        prettyString = [prettyString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    } else {
        prettyString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return prettyString;
}

@end
