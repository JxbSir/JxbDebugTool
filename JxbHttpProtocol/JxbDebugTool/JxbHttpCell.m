//
//  JxbHttpCell.m
//  JxbHttpProtocol
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/11/12.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import "JxbHttpCell.h"
#import "JxbDebugTool.h"

@interface JxbHttpCell()
{
    UILabel *lblTitle;
    UILabel *lblValue;
}
@end

@implementation JxbHttpCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width - 40, 20)];
        lblTitle.textColor = [JxbDebugTool shareInstance].mainColor;
        lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
        [self addSubview:lblTitle];
        
        lblValue = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, [UIScreen mainScreen].bounds.size.width - 40, 16)];
        lblValue.textColor = [UIColor lightGrayColor];
        lblValue.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblValue];
    }
    return self;
}

- (void)setTitle:(NSString*)title value:(NSString*)value {
    lblTitle.text = title;
    lblValue.text = value;
}

@end
