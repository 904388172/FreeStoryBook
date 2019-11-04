//
//  ReadBookController.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/26.
//  Copyright © 2019 GS. All rights reserved.
//


#import "ReadBookController.h"
#import <WebKit/WebKit.h>
#import "BookSQLManager.h"

@interface ReadBookController () <WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ReadBookController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.bookModel.book_name;
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    //注册方法
    [configuration.userContentController addScriptMessageHandler:self name:@"方法名"];
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:configuration];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@%@",@"http://m.duoduoxiaoshuo.com/read/",self.bookModel.book_id,self.read_id,@".html"];
    
    NSString *encodedString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *weburl = [NSURL URLWithString:encodedString];
    [_webView loadRequest:[NSURLRequest requestWithURL:weburl]];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [_webView evaluateJavaScript:@"document.getElementsByClassName('header inner-header')[0].style.display='none'" completionHandler:nil];
//    [_webView evaluateJavaScript:@"document.getElementsByClassName('header inner-header')[0].style.height='0px'" completionHandler:nil];
//    [_webView evaluateJavaScript:@"document.getElementsByClassName('tools-list')[0].style.display='none'" completionHandler:nil];
//    [_webView evaluateJavaScript:@"document.getElementsByClassName('home iconfont icon-home')[0].style.display='none'" completionHandler:nil];
//    [_webView evaluateJavaScript:@"document.getElementsByClassName('back')[0].style.display='none'" completionHandler:nil];
//    
//    
//    [webView evaluateJavaScript:@"" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//        NSLog(@"response: %@ error: %@", response, error);
//    }];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString * requestStr = navigationAction.request.URL.absoluteString;
    
    NSLog(@"%@",requestStr);//监控获取点击返回的字符串
    decisionHandler(WKNavigationActionPolicyAllow);
    
    BOOL isRead = [[BookSQLManager shareDatabase] isExistReadBook:self.bookModel.book_id];
    if (isRead) {
        BOOL isUpdateSuc = [[BookSQLManager shareDatabase] updateBookReadPage:self.bookModel.book_id withPage:[[[[requestStr componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."] firstObject]];
    } else {
        BOOL isAddSuc = [[BookSQLManager shareDatabase] insertBookReadPage:self.bookModel.book_id withPage:[[[[requestStr componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."] firstObject]];
    }
    
}

@end
