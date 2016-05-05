//
//  ViewController.m
//  JxbHttpProtocol
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/11/12.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import "ViewController.h"
#import "XBFramework.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"hehehe";
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 30)];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
        }];
    });
  
    
        NSString* url = @"http://api.cuitrip.com/baseservice/getUserInfo";
    NSDictionary* dicParas = @{@"otherId":@"1",
                               @"uid":@"1",
                               @"clientVersion":@"1.4.0",
                               @"token":@"",
                               @"client":@"iOS"};
    
        [[XBApi SharedXBApi] requestWithURL:url paras:dicParas type:XBHttpResponseType_Json success:^(AFHTTPRequestOperation* operation,NSObject* result){
        } failure:^(NSError* error){
            NSLog(@"%@",error);
        }];
    
    
    NSArray* aaa = @[];
//    NSLog(@"%@",aaa[2]);
}

- (void)btnAction {

    ViewController* vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
