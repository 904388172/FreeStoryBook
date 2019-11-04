//
//  MineController.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/19.
//  Copyright © 2019 GS. All rights reserved.
//

#import "MineController.h"
#import "SearchBookController.h"
#import "SystemSettingController.h"

@interface MineController ()

@end

@implementation MineController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航左右按钮
    [self setNavBarButtonItem];
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.backgroundColor = [UIColor redColor];
    setBtn.frame = CGRectMake(100, 100, 80, 44);
    [setBtn addTarget:self action:@selector(setSystem1:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setTitle:@"支付宝登录" forState:UIControlStateNormal];
    [self.view addSubview:setBtn];
    
    UIButton *setBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn1.backgroundColor = [UIColor redColor];
    setBtn1.frame = CGRectMake(100, 100, 80, 44);
    [setBtn1 addTarget:self action:@selector(setSystem2:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn1 setTitle:@"微信登录" forState:UIControlStateNormal];
    [self.view addSubview:setBtn1];
    
}
- (void)setSystem2:(UIButton *)sender {
    
}
- (void)setSystem1:(UIButton *)sender {
    //你在info中/或plist中设置的appScheme
    NSString *appScheme = @"demoAuthd";
    //authStr参数后台获取！和开发中心配置的app有关系，包含appid\name等等信息。
    NSString *authStr = @"https://openapi.alipaydev.com/gateway.do";
    //没有安装支付宝客户端的跳到网页授权时会在这个方法里回调
    [[AFAuthSDK defaultService] authv2WithInfo:authStr fromScheme:appScheme callback:^(NSDictionary *result) {
        // 解析 auth code
        NSString *resultString = result[@"result"];
        NSString *authCode = nil;
        if (resultString.length>0) {
            NSArray *resultArr = [resultString componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        NSLog(@"resultString = %@",resultString);
        //        NSLog(@"authv2WithInfo授权结果 authCode = %@", authCode?:@"");
    }];
}
#pragma mark -- 点击左右按钮
- (void)searchBook:(UIButton *)sender {
    
    SearchBookController *vc = [[SearchBookController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setSystem:(UIButton *)sender {
    SystemSettingController *vc = [[SystemSettingController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 设置导航左右按钮
- (void)setNavBarButtonItem {
    //修改导航栏
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 44, 44);
    [searchBtn addTarget:self action:@selector(searchBook:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setImage:[UIImage imageNamed:@"sousuo.png"]forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    
//    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    setBtn.frame = CGRectMake(0, 0, 44, 44);
//    [setBtn addTarget:self action:@selector(setSystem:) forControlEvents:UIControlEventTouchUpInside];
//    [setBtn setImage:[UIImage imageNamed:@"shezhi.png"] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:setBtn];
}

@end
