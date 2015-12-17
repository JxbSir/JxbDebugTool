//
//  JxbDebugTool.m
//  JxbHttpProtocol
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/11/12.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import "JxbDebugTool.h"
#import "JxbHttpProtocol.h"
#import "JxbDebugVC.h"
#import "JxbCrashVC.h"
#import "JxbHttpVC.h"
#import "JxbLogVC.h"
#import "JxbCrashHelper.h"
#import "JxbMemoryHelper.h"

#define KB	(1024)
#define MB	(KB * 1024)
#define GB	(MB * 1024)

@interface JxbDebugWindow : UIWindow

@end

@implementation JxbDebugWindow

- (void)becomeKeyWindow {
    //uisheetview
    [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
}

@end

@interface JxbDebugTool()
@property (nonatomic, strong) JxbDebugVC        *debugVC;
@property (nonatomic, strong) JxbDebugWindow    *debugWin;
@property (nonatomic, strong) UIButton          *debugBtn;
@property (nonatomic, strong) NSTimer           *debugTimer;
@end

@implementation JxbDebugTool

+ (instancetype)shareInstance {
    static JxbDebugTool* tool;
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        tool = [[JxbDebugTool alloc] init];
    });
    return tool;
}

- (id)init {
    self = [super init];
    if (self) {
        self.mainColor = [UIColor redColor];
        self.debugWin = [[JxbDebugWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        
        self.debugTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMonitor) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.debugTimer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)enableDebugMode {
   [NSURLProtocol registerClass:[JxbHttpProtocol class]];
    [[JxbCrashHelper sharedInstance] install];
    
    __weak typeof (self) wSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wSelf showOnStatusBar];
    });
}

- (void)showOnStatusBar {
    self.debugWin.windowLevel = UIWindowLevelStatusBar+1;
    self.debugWin.hidden = NO;
    
    self.debugBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, 91, 15)];
    self.debugBtn.backgroundColor = self.mainColor;
    self.debugBtn.layer.cornerRadius = 3;
    self.debugBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.debugBtn setTitle:@"Debug Starting" forState:UIControlStateNormal];
    [self.debugBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.debugBtn addTarget:self action:@selector(showDebug) forControlEvents:UIControlEventTouchUpInside];
    [self.debugWin addSubview:self.debugBtn];
}

- (void)showDebug {
    if (!self.debugVC) {
        self.debugVC = [[JxbDebugVC alloc] init];

        UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:[JxbHttpVC new]];
        UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:[JxbCrashVC new]];
        UINavigationController* nav3 = [[UINavigationController alloc] initWithRootViewController:[JxbLogVC new]];
        
        [nav1.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:self.mainColor}];
        [nav2.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:self.mainColor}];
        [nav3.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:self.mainColor}];
        
        nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Http" image:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [nav1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:30]} forState:UIControlStateNormal];
        [nav1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:self.mainColor,NSFontAttributeName:[UIFont systemFontOfSize:30]} forState:UIControlStateSelected];
        
        
        nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Crash" image:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [nav2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:30]} forState:UIControlStateNormal];
        [nav2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:self.mainColor,NSFontAttributeName:[UIFont systemFontOfSize:30]} forState:UIControlStateSelected];
        
        nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Log" image:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [nav3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:30]} forState:UIControlStateNormal];
        [nav3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:self.mainColor,NSFontAttributeName:[UIFont systemFontOfSize:30]} forState:UIControlStateSelected];

        self.debugVC.viewControllers = @[nav1,nav2,nav3];
        UIViewController* vc = [[[UIApplication sharedApplication].delegate window] rootViewController];
        UIViewController* vc2 = vc.presentedViewController;
        [vc2?:vc presentViewController:self.debugVC animated:YES completion:nil];
    }
    else {
        [self.debugVC dismissViewControllerAnimated:YES completion:nil];
        self.debugVC = nil;
    }
}

- (void)timerMonitor {
    unsigned long long used = [JxbMemoryHelper bytesOfUsedMemory];
    NSString* text = [self number2String:used];
    [self.debugBtn setTitle:[NSString stringWithFormat:@"Debug(%@)",text] forState:UIControlStateNormal];
}

- (NSString* )number2String:(int64_t)n
{
    if ( n < KB )
    {
        return [NSString stringWithFormat:@"%lldB", n];
    }
    else if ( n < MB )
    {
        return [NSString stringWithFormat:@"%.1fK", (float)n / (float)KB];
    }
    else if ( n < GB )
    {
        return [NSString stringWithFormat:@"%.1fM", (float)n / (float)MB];
    }
    else
    {
        return [NSString stringWithFormat:@"%.1fG", (float)n / (float)GB];
    }
}
@end
