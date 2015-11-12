//
//  UITableViewCell+SeparatorLine.h
//  QuicklyShop
//
//  Copyright (c) 2014年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,SeparatorType)
{
    SeparatorTypeHead    =   1,
    SeparatorTypeMiddle      ,
    SeparatorTypeBottom      ,
    SeparatorTypeSingle,
    SeparatorTypeShort,
};


@interface UITableViewCell (SeparatorLine)

- (void)addSeparatorLineWithType:(SeparatorType)separatorType;

@end
