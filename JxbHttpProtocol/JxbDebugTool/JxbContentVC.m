//
//  JxbContentVC.m
//  JxbHttpProtocol
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/11/12.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import "JxbContentVC.h"
#import "JxbDebugTool.h"

@interface JxbContentVC ()
{
    UITextView  *txt;
}
@end

@implementation JxbContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btnclose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnclose.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnclose setTitle:@"Back" forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [btnclose setTitleColor:[JxbDebugTool shareInstance].mainColor forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc] initWithCustomView:btnclose];
    self.navigationItem.leftBarButtonItem = btnleft;
    
    UIButton *btnCopy = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnCopy.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnCopy setTitle:@"Copy" forState:UIControlStateNormal];
    [btnCopy addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    [btnCopy setTitleColor:[JxbDebugTool shareInstance].mainColor forState:UIControlStateNormal];
    UIBarButtonItem *btnright = [[UIBarButtonItem alloc] initWithCustomView:btnCopy];
    self.navigationItem.rightBarButtonItem = btnright;
    
    txt = [[UITextView alloc] initWithFrame:self.view.bounds];
    [txt setEditable:NO];
    txt.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    txt.font = [UIFont systemFontOfSize:13];
    txt.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    txt.text = self.content;
    
    [self.view addSubview:txt];
    
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:13],
                                 NSParagraphStyleAttributeName : style};
    CGRect r = [self.content boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, MAXFLOAT) options:option attributes:attributes context:nil];
    txt.contentSize = CGSizeMake(self.view.bounds.size.width, r.size.height);
}

- (void)copyAction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self.content copy];
    
    txt.text = [NSString stringWithFormat:@"%@\n\n%@",@"复制成功！",self.content];
    
    __weak typeof (txt) weakTxt = txt;
    __weak typeof (self) wSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakTxt.text = wSelf.content;
        NSLog(@"%@",wSelf.content);
    });
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
