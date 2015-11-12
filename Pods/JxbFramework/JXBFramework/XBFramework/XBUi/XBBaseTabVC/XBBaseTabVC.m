//
//  XBBaseTabVC.m
//  JXBFramework
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/3/22.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import "XBBaseTabVC.h"
#import "UIColor+hexColor.h"
#import "UIImage+RenderedImage.h"
#import "XBGlobal.h"

@implementation XBBaseTabItem
@end

@implementation XBBaseTabVC

- (XBBaseTabVC*)initWithItems:(NSArray *)items btnMiddle:(UIButton*)btnMiddle
{
    self = [super init];
    if(self)
    {
        NSMutableArray* navVCs = [NSMutableArray array];
        for(XBBaseTabItem* item in items)
        {
            item.rootVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:item.title image:[[UIImage imageNamed:item.unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:item.selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:item.rootVC];
            [navVCs addObject:nav];
        }
        self.viewControllers = navVCs;
        self.tabBar.backgroundColor = [UIColor clearColor];
        
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:mainColor} forState:UIControlStateSelected];
        
        // customise NavigationBar UI Effect
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithRenderColor:mainColor renderSize:CGSizeMake(10., 10.)] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.],NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        if (btnMiddle) {
            [[UITabBar appearance] setShadowImage:[UIImage new]];
            [[UITabBar appearance] setBackgroundImage:[UIImage imageWithRenderColor:RGB(248, 248, 248) renderSize:CGSizeMake(100, 50)]];
            
            UIView *viewLineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 0.5)];
            viewLineTop.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
            [self.tabBar addSubview:viewLineTop];
            [self.tabBar addSubview:btnMiddle];
        }
    }
    return self;
}
@end
