//
//  XBEmptyView.m
//  FanWaAdmin
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/1/22.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import "XBEmptyView.h"
#import "UIImage+TintColor.h"
#import "UIColor+hexColor.h"
#import "XBGlobal.h"

@interface XBEmptyView()
{
    UIImageView *imgEmpty;
    UILabel     *lblEmpty;
}
@end

@implementation XBEmptyView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat w = 70;
        imgEmpty = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width / 2 - w / 2, frame.size.height / 2 - w * 2, w, w)];
        [self addSubview:imgEmpty];
        
        lblEmpty = [[UILabel alloc] initWithFrame:CGRectMake(0, imgEmpty.frame.origin.y + imgEmpty.frame.size.height + 20, frame.size.width, 20)];
        lblEmpty.textColor = mainColor;
        lblEmpty.textAlignment = NSTextAlignmentCenter;
        lblEmpty.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblEmpty];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    lblEmpty.text = title;
}

- (void)setImageName:(NSString *)imageName {
    imgEmpty.image = [[UIImage imageNamed:imageName] imageWithTintColor:mainColor];
}
@end
