//
//  JxbCrashHelper.m
//  JxbHttpProtocol
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/11/12.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import "JxbCrashHelper.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

const int maxCrashLogNum  = 20;

@interface JxbCrashHelper() {
    NSString*       _crashLogPath;
    NSMutableArray* _plist;
}
@property (nonatomic,assign) BOOL isInstalled;
@end

@implementation JxbCrashHelper

+ (instancetype)sharedInstance
{
    static JxbCrashHelper* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [JxbCrashHelper new];
    });
    return instance;
}


+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (i = 0;i < 32;i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString* sandBoxPath  = [paths objectAtIndex:0];
        
        
        _crashLogPath = [sandBoxPath stringByAppendingPathComponent:@"JxbCrashLog"];
        
        if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:_crashLogPath] )
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:_crashLogPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        
        //creat plist
        if (YES == [[NSFileManager defaultManager] fileExistsAtPath:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"]])
        {
            _plist = [[NSMutableArray arrayWithContentsOfFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"]] mutableCopy];
        }
        else
            _plist = [NSMutableArray new];
    }
    return self;
}

- (NSDictionary* )crashForKey:(NSString *)key
{
    NSString* filePath = [[_crashLogPath stringByAppendingPathComponent:key] stringByAppendingString:@".plist"];
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return dict;
}

- (NSArray* )crashPlist
{
    return [_plist copy];
}

- (NSArray* )crashLogs
{
    NSMutableArray* ret = [NSMutableArray new];
    for (NSString* key in _plist) {
        
        NSString* filePath = [_crashLogPath stringByAppendingPathComponent:key];
        NSString* path = [filePath stringByAppendingString:@".plist"];
        NSDictionary* log = [NSDictionary dictionaryWithContentsOfFile:path];
        [ret addObject:log];
    }
    return [ret copy];
}


- (NSDictionary* )crashReport
{
    for (NSString* key in _plist) {
        NSString* filePath = [_crashLogPath stringByAppendingPathComponent:key];
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        return dict;
    }
    return nil;
    
}

- (void)saveException:(NSException*)exception
{
    NSMutableDictionary * detail = [NSMutableDictionary dictionary];
    if ( exception.name )
    {
        [detail setObject:exception.name forKey:@"name"];
    }
    if ( exception.reason )
    {
        [detail setObject:exception.reason forKey:@"reason"];
    }
    if ( exception.userInfo )
    {
        [detail setObject:exception.userInfo forKey:@"userInfo"];
    }
    if ( exception.callStackSymbols )
    {
        [detail setObject:exception.callStackSymbols forKey:@"callStack"];
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:@"exception" forKey:@"type"];
    [dict setObject:detail forKey:@"info"];
    
    [self saveToFile:dict];
    
}

- (void)saveSignal:(int) signal
{
    NSMutableDictionary * detail = [NSMutableDictionary dictionary];

    [detail setObject:@(signal) forKey:@"signal type"];

    [self saveToFile:detail];
}

- (void)saveToFile:(NSMutableDictionary*)dict
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    
    //add date
    [dict setObject:dateString forKey:@"date"];
    
    //save path
    NSString* savePath = [[_crashLogPath stringByAppendingPathComponent:dateString] stringByAppendingString:@".plist"];
    
    //save to disk
    BOOL succeed = [ dict writeToFile:savePath atomically:YES];
    if ( NO == succeed )
    {
        NSLog(@"JxbDebugTool:crash report failed!");
    }
    else
        NSLog(@"JxbDebugTool:save crash report succeed!");
    
    [_plist insertObject:dateString atIndex:0];
    [_plist writeToFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"] atomically:YES];
    
    if (_plist.count > maxCrashLogNum)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[_crashLogPath stringByAppendingPathComponent:_plist[0]] error:nil];
        [_plist writeToFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"] atomically:YES];
    }
}

#pragma mark - register
void jxb_HandleException(NSException *exception)
{
    [[JxbCrashHelper sharedInstance] saveException:exception];
    [exception raise];
}

void jxb_SignalHandler(int sig)
{
//    [[JxbCrashHelper sharedInstance] saveSignal:sig];
//    signal(sig, SIG_DFL);
//    raise(sig);
}

- (void)install
{
    if (_isInstalled) {
        return;
    }
    _isInstalled = YES;
    //注册回调函数
    NSSetUncaughtExceptionHandler(&jxb_HandleException);
    signal(SIGABRT, jxb_SignalHandler);
    signal(SIGILL, jxb_SignalHandler);
    signal(SIGSEGV, jxb_SignalHandler);
    signal(SIGFPE, jxb_SignalHandler);
    signal(SIGBUS, jxb_SignalHandler);
    signal(SIGPIPE, jxb_SignalHandler);
}

- (void)dealloc
{
    signal( SIGABRT,	SIG_DFL );
    signal( SIGBUS,		SIG_DFL );
    signal( SIGFPE,		SIG_DFL );
    signal( SIGILL,		SIG_DFL );
    signal( SIGPIPE,	SIG_DFL );
    signal( SIGSEGV,	SIG_DFL );
}
@end

