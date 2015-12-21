//
//  JxbLogVC.m
//  JxbHttpProtocol
//
//  Created by Peter on 15/11/16.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import "JxbLogVC.h"
#import <asl.h>
#include <stdio.h>
#import "JxbDebugTool.h"

@interface JxbLogModel:NSObject
@property (nonatomic, strong)   NSDate *date;
@property (nonatomic, copy)     NSString *sender;
@property (nonatomic, copy)     NSString *messageText;
@property (nonatomic, assign)   long long messageID;
@end

@implementation JxbLogModel

+(instancetype)messageFromASLMessage:(aslmsg)aslMessage
{
    JxbLogModel *logMessage = [[JxbLogModel alloc] init];
    
    const char *timestamp = asl_get(aslMessage, ASL_KEY_TIME);
    if (timestamp) {
        NSTimeInterval timeInterval = [@(timestamp) integerValue];
        const char *nanoseconds = asl_get(aslMessage, ASL_KEY_TIME_NSEC);
        if (nanoseconds) {
            timeInterval += [@(nanoseconds) doubleValue] / NSEC_PER_SEC;
        }
        logMessage.date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    }
    
    const char *sender = asl_get(aslMessage, ASL_KEY_SENDER);
    if (sender) {
        logMessage.sender = @(sender);
    }
    
    const char *messageText = asl_get(aslMessage, ASL_KEY_MSG);
    if (messageText) {
        logMessage.messageText = @(messageText);
        
    }
    
    const char *messageID = asl_get(aslMessage, ASL_KEY_MSG_ID);
    if (messageID) {
        logMessage.messageID = [@(messageID) longLongValue];
        
    }
    
    return logMessage;
}

+ (NSString *)stringFormatFromDate:(NSDate *)date
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    });
    
    return [formatter stringFromDate:date];
}
@end

@interface JxbLogVC ()
{
    int maxCount;
    UITextView  *txt;
}
@end

@implementation JxbLogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Log";
    maxCount = [JxbDebugTool shareInstance].maxLogsCount;
    if (maxCount == 0)
        maxCount = 50;
    
    txt = [[UITextView alloc] init];
    [txt setEditable:NO];
    txt.backgroundColor = [UIColor blackColor];
    txt.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    txt.frame = self.view.bounds;
    [self.view addSubview:txt];
    
    
    UIButton *btnclose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnclose.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnclose setTitle:@"关闭" forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [btnclose setTitleColor:[JxbDebugTool shareInstance].mainColor forState:UIControlStateNormal];
    
    UIBarButtonItem *barclose = [[UIBarButtonItem alloc] initWithCustomView:btnclose];
    self.navigationItem.leftBarButtonItem = barclose;
    
    UIButton *btnrefresh = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnrefresh.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnrefresh setTitle:@"刷新" forState:UIControlStateNormal];
    [btnrefresh addTarget:self action:@selector(loadLogs) forControlEvents:UIControlEventTouchUpInside];
    [btnrefresh setTitleColor:[JxbDebugTool shareInstance].mainColor forState:UIControlStateNormal];
    
    UIBarButtonItem *barrefresh = [[UIBarButtonItem alloc] initWithCustomView:btnrefresh];
    self.navigationItem.rightBarButtonItem = barrefresh;
    
    
    [self loadLogs];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadLogs {
    __weak UITextView* weakTxt = txt;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray* arr = [self logs];
        if (arr.count > 0) {
            NSMutableAttributedString* string = [[NSMutableAttributedString alloc] init];
            for (JxbLogModel* model in arr) {
                NSString* date = [JxbLogModel stringFormatFromDate:model.date];
                NSMutableAttributedString* att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",date]];
                [att addAttribute:NSForegroundColorAttributeName value:[JxbDebugTool shareInstance].mainColor range:NSMakeRange(0, att.string.length)];
                
                NSMutableAttributedString* att2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",model.messageText]];
                [att2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, att2.string.length)];
                
                [string appendAttributedString:att];
                [string appendAttributedString:att2];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakTxt.attributedText = string;
            });
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//               [weakTxt scrollRectToVisible:CGRectMake(0, weakTxt.contentSize.height, weakTxt.frame.size.width, 1) animated:NO];
//            });
        }
    });
}

- (NSArray* )logs {
    asl_object_t query = asl_new(ASL_TYPE_QUERY);
    char pidStr[100];
    sprintf(pidStr,"%d",[[NSProcessInfo processInfo] processIdentifier]);
    asl_set_query(query, ASL_KEY_PID, pidStr, ASL_QUERY_OP_EQUAL);
    
    //this is too slow!
    aslresponse response = asl_search(NULL, query);
    NSUInteger numberOfLogs = maxCount;
    NSMutableArray *logMessages = [NSMutableArray arrayWithCapacity:numberOfLogs];
    size_t count = asl_count(response);
    for (int i=0; i<numberOfLogs; i++) {
        aslmsg msg = asl_get_index(response, count - i - 1);
        if (msg != NULL) {
            JxbLogModel* model = [JxbLogModel messageFromASLMessage:msg];
            [logMessages addObject:model];
        }
        else
            break;
    }
    asl_release(response);
    return logMessages;
}

@end
