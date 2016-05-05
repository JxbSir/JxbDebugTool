//
//  JxbResponseVC.m
//  JxbHttpProtocol
//
//  Created by Peter on 16/5/5.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "JxbResponseVC.h"
#import "JxbDebugTool.h"
#import "JxbHttpDatasource.h"

@interface JxbResponseVC ()
{
    UITextView   *txt;
    UIImageView  *img;

}
@property (nonatomic, strong) NSString    *contentString;
@end

@implementation JxbResponseVC

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
    
    if (!self.isImage) {
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
        
        NSData* contentdata = self.data;
        if ([[JxbDebugTool shareInstance] isHttpResponseEncrypt]) {
            if ([[JxbDebugTool shareInstance] delegate] && [[JxbDebugTool shareInstance].delegate respondsToSelector:@selector(decryptJson:)]) {
                contentdata = [[JxbDebugTool shareInstance].delegate decryptJson:self.data];
            }
        }
        txt.text = [JxbHttpDatasource prettyJSONStringFromData:contentdata];;
        _contentString = txt.text;
        
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:13],
                                     NSParagraphStyleAttributeName : style};
        CGRect r = [txt.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, MAXFLOAT) options:option attributes:attributes context:nil];
        txt.contentSize = CGSizeMake(self.view.bounds.size.width, r.size.height);
        [self.view addSubview:txt];
    }
    else {
        img = [[UIImageView alloc] initWithFrame:self.view.bounds];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.image = [UIImage imageWithData:self.data];
        [self.view addSubview:img];
    }
}

- (void)copyAction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [txt.text copy];
    
    txt.text = [NSString stringWithFormat:@"%@\n\n%@",@"复制成功！",txt.text];
    
    __weak typeof (txt) weakTxt = txt;
    __weak typeof (self) wSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakTxt.text = wSelf.contentString;
    });
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
