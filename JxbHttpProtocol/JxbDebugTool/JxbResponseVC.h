//
//  JxbResponseVC.h
//  JxbHttpProtocol
//
//  Created by Peter on 16/5/5.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JxbBaseVC.h"

@interface JxbResponseVC : JxbBaseVC
@property (nonatomic, strong) NSData    *data;
@property (nonatomic, assign) BOOL      isImage;
@end
