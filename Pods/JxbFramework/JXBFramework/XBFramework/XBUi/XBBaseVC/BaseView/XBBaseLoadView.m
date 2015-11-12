//
//  ZJOL_LoadingView.m
//  ZJOL
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/1/22.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import "XBBaseLoadView.h"
#import "XBGlobal.h"
#import "UIColor+hexColor.h"

@implementation XBBaseLoadView

- (id)init
{
    self = [super init];
    if(self)
    {
        actIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        actIndicatorView.frame = CGRectMake((self.bounds.size.width - 32) / 2, (self.bounds.size.height - 32) / 2, 32, 32);
        [actIndicatorView startAnimating];
        [self addSubview:actIndicatorView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        actIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        actIndicatorView.frame = CGRectMake((self.bounds.size.width - 32) / 2, (self.bounds.size.height - 150) / 2, 32, 32);
        [actIndicatorView startAnimating];
        [self addSubview:actIndicatorView];
        
        UILabel* lblInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.bounds.size.height - 150) / 2 + 30, mainWidth, 30)];
        lblInfo.textAlignment = NSTextAlignmentCenter;
        lblInfo.font = [UIFont systemFontOfSize:12];
        lblInfo.textColor = [UIColor hexFloatColor:@"666666"];
        lblInfo.text = @"正在加载，请稍后";
        [self addSubview:lblInfo];
    }
    return self;
}

- (void)removeFromSuperview
{
    if (actIndicatorView)
        [actIndicatorView stopAnimating];
    [super removeFromSuperview];
}


@end
