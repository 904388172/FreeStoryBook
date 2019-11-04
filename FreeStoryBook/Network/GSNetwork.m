//
//  GSNetwork.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/20.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSNetwork.h"
#import <MBProgressHUD.h>
#import <AFNetworking.h>

@implementation GSNetwork

+ (void)request:(NSString *)url withType:(NSString *)type withParameters:(id)prameters andLoad:(SeletorShowType)showType completion:(nonnull void (^)(NSString * _Nonnull, id _Nonnull))result {
    
    if(showType == kShowLoadInScreen){
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    }
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
//    NSLog(@"请求url+++++++++++++++bodyStr%@",url);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    if ([type isEqualToString:@"POST"]) {
        [manager POST:url parameters:prameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            
            NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([str hasPrefix:@"null"]) {
//                NSLog(@"1.+++++++++++++++++++++++++++++++++++++++++++++str    : %@",str);
                str = [str stringByReplacingOccurrencesOfString:@"null" withString:@""];
                if ([str hasPrefix:@"("]) {
                    str = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
                }
                if ([str hasSuffix:@")"]) {
                    str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
                }
                NSData *date = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:date options:NSJSONReadingAllowFragments error:nil];

                [[self class] setcookies];
                result(@"0",dic);
            } else {
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//                NSLog(@"2.+++++++++++++++++++++++++++++++++++++++++++++str    : %@",str);
                
                [[self class] setcookies];
                result(@"0",dic);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//            NSLog(@"%@%@",@"请求失败:",error);
            result(@"1",error);
        }];
        
    } else {
        [manager GET:url parameters:prameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([str hasPrefix:@"null"]) {
//                 NSLog(@"3+++++++++++++++++++++++++++++++++++++++++++++str    : %@",str);
                str = [str stringByReplacingOccurrencesOfString:@"null" withString:@""];
                if ([str hasPrefix:@"("]) {
                    str = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
                }
                if ([str hasSuffix:@")"]) {
                    str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
                }
               
                NSData *date = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:date options:NSJSONReadingAllowFragments error:nil];
        
                [[self class] setcookies];
                result(@"0",dic);
            } else {
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//                NSLog(@"4+++++++++++++++++++++++++++++++++++++++++++++str    : %@",str);
                [[self class] setcookies];
                result(@"0",dic);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            
//            NSLog(@"%@%@",@"请求失败:",error);
            result(@"1", error);
        }];
    }
}

//添加缓存 并持久化保存
+(void)setcookies{
    NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    for (NSHTTPCookie *tempCookie in cookies)
    {
        //打印cookies
        if([tempCookie.name isEqualToString:@"jeesite.session.id"]){
//            NSLog(@"getCookie:%@",tempCookie);
//            NSLog(@"name:%@",tempCookie.value);
        }
    }
}

@end
