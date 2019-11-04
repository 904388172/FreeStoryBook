//
//  BookDetailController.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/28.
//  Copyright © 2019 GS. All rights reserved.
//

#import "BookDetailController.h"
#import <WebKit/WebKit.h>
#import "BookSQLManager.h"
#import "ReadBookController.h"

@interface BookDetailController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation BookDetailController

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
    NSString *url = [NSString stringWithFormat:@"%@%@%@",@"http://m.duoduoxiaoshuo.com/detail/",self.bookModel.book_id,@".html?from=singlemessage&isappinstalled=0"];
    
    //    NSString *url = [NSString stringWithFormat:@"%@%@%@",@"http://m.duoduoxiaoshuo.com/read/",@"329624/64539730",@".html"];
    NSString *encodedString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *weburl = [NSURL URLWithString:encodedString];
    [_webView loadRequest:[NSURLRequest requestWithURL:weburl]];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //隐藏html上classname的标签
    [_webView evaluateJavaScript:@"document.getElementsByClassName('header inner-header')[0].style.display='none'" completionHandler:nil];
    [_webView evaluateJavaScript:@"document.getElementsByClassName('btns-widget')[0].style.display='none'" completionHandler:nil];
    [_webView evaluateJavaScript:@"document.getElementsByClassName('btns-widget')[0].style.height='0px'" completionHandler:nil];
    [_webView evaluateJavaScript:@"document.getElementsByClassName('footer')[0].style.display='none'" completionHandler:nil];
    [_webView evaluateJavaScript:@"document.getElementsByClassName('footer')[0].style.height='0px'" completionHandler:nil];
    [_webView evaluateJavaScript:@"document.getElementsByClassName('update')[0].style.display='none'" completionHandler:nil];
    
    
    if ([[BookSQLManager shareDatabase] isExistThisBookInCase:self.bookModel]) {
        //修改classname的内容
        [_webView evaluateJavaScript:@"document.getElementsByClassName('btn-primary app-download')[0].innerText='从书架中移除'" completionHandler:nil];
    } else {
        //修改classname的内容
        [_webView evaluateJavaScript:@"document.getElementsByClassName('btn-primary app-download')[0].innerText='加入书架'" completionHandler:nil];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString * requestStr = navigationAction.request.URL.absoluteString;
    
    NSLog(@"%@",requestStr);//监控获取点击返回的字符串
    
    if ([requestStr hasPrefix:@"http://m.duoduoxiaoshuo.com/read/"]){
        decisionHandler(WKNavigationActionPolicyCancel);
        NSLog(@"进入读书");
        //跳转到详细
        
        NSString *page = [[BookSQLManager shareDatabase] getBookReadPage:self.bookModel.book_id];
        
        ReadBookController *vc = [[ReadBookController alloc] init];
        vc.bookModel = self.bookModel;
//        if (![page isEqualToString:@""]) {
//            vc.read_id = [[BookSQLManager shareDatabase] getBookReadPage:self.bookModel.book_id];
//        } else {
            vc.read_id = [[[[requestStr componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."] firstObject];
//        }
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([requestStr hasPrefix:@"https://itunes.apple.com/us/app"]){//字符串//之前的开头
        
        //然后进行此按钮的点击事件填写
        NSLog(@"加入书架");
        decisionHandler(WKNavigationActionPolicyAllow);
        
        
        BOOL isExist = [[BookSQLManager shareDatabase] isExistThisBookInCase:self.bookModel];
        if (isExist) {
            BOOL isdelete = [[BookSQLManager shareDatabase] deleteThisBookInCase:self.bookModel];
            if (isdelete) {
                [_webView evaluateJavaScript:@"document.getElementsByClassName('btn-primary app-download')[0].innerText='加入书架'" completionHandler:nil];
            }
        } else {
            BOOL isAddSuc = [[BookSQLManager shareDatabase] insertBookInCase:self.bookModel];
            if (isAddSuc) {
                [_webView evaluateJavaScript:@"document.getElementsByClassName('btn-primary app-download')[0].innerText='从书架中移除'" completionHandler:nil];
            }
        }
        NSMutableArray *arr = [[BookSQLManager shareDatabase] getAllBookInCase];
        NSLog(@"%@",arr);
        
    }   else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}


@end
