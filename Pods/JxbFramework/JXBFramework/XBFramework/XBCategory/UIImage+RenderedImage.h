//
//  UIImage+RenderedImage.h
//  ZJOL
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/1/6.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RenderedImage)

+ (UIImage *)imageWithRenderColor:(UIColor *)color renderSize:(CGSize)size;
@end
