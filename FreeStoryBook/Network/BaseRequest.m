//
//  BaseRequest.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/20.
//  Copyright © 2019 GS. All rights reserved.
//

#import "BaseRequest.h"
#import "GSNetwork.h"

@implementation BaseRequest

#pragma mark --- 书架
+ (void)getBookCase:(NSString *)url withResult:(nonnull void (^)(NSString * _Nonnull, id _Nonnull))callBack {
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",HOST,url];
    
    [GSNetwork request:newUrl withType:@"GET" withParameters:nil andLoad:kShowLoadInScreen completion:^(NSString * _Nonnull isSuccess, id _Nonnull resopnse) {
        
        callBack(isSuccess,resopnse);
    }];
}

#pragma mark --- 精选
+ (void)HotBookRequest:(NSString *)url withPage:(int)index withResult:(void (^)(NSString * _Nonnull, id _Nonnull))callBack {
    
    NSString *newUrl = [NSString stringWithFormat:@"%@%@%d%@",HOST,url,index,@"/0"];
    
    [GSNetwork request:newUrl withType:@"GET" withParameters:nil andLoad:kShowLoadInScreen completion:^(NSString * _Nonnull isSuccess, id _Nonnull resopnse) {
        
        callBack(isSuccess,resopnse);
    }];
}

#pragma mark --- 书库分类
+ (void)getBookCategory:(NSString *)url withResult:(void (^)(NSString* errCode, id))callBack {
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",HOST,url];
    
    [GSNetwork request:newUrl withType:@"GET" withParameters:nil andLoad:kShowLoadInScreen completion:^(NSString * _Nonnull isSuccess, id _Nonnull resopnse) {
        
        callBack(isSuccess,resopnse);
    }];
    
}

#pragma mark --- 书库排行
+ (void)getBookRank:(NSString *)url withResult:(void (^)(NSString* errCode, id))callBack {
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",HOST,url];
    
    [GSNetwork request:newUrl withType:@"GET" withParameters:nil andLoad:kShowLoadInScreen completion:^(NSString * _Nonnull isSuccess, id _Nonnull resopnse) {
        
        callBack(isSuccess,resopnse);
    }];
}

#pragma mark --- 书库排行更多
+ (void)getBookRankDetail:(NSString *)url withPage:(int)index withResult:(void (^)(NSString* errCode, id))callBack {
    NSString *newUrl = [NSString stringWithFormat:@"%@%@%d",HOST,url,index];
    [GSNetwork request:newUrl withType:@"GET" withParameters:nil andLoad:kShowLoadInScreen completion:^(NSString * _Nonnull isSuccess, id _Nonnull resopnse) {
        
        callBack(isSuccess,resopnse);
    }];
}

#pragma mark --- 搜索
+ (void)searchBook:(NSString *)url withkey:(nonnull NSString *)searchKey withPage:(int)index withResult:(nonnull void (^)(NSString * _Nonnull, id _Nonnull))callBack {
    NSString *newUrl = [NSString stringWithFormat:@"%@%@%@/%d",HOST,url,searchKey,index];
    
    [GSNetwork request:newUrl withType:@"GET" withParameters:nil andLoad:kShowLoadInScreen completion:^(NSString * _Nonnull isSuccess, id _Nonnull resopnse) {
        
        callBack(isSuccess,resopnse);
    }];
}

#pragma mark -- 推荐
+ (void)searchRecommendBook:(NSString *)url withPage:(int)index withResult:(void (^)(NSString* errCode, id))callBack {
    NSString *newUrl = [NSString stringWithFormat:@"%@%@%d",HOST,url,index];
    
    [GSNetwork request:newUrl withType:@"GET" withParameters:nil andLoad:kShowLoadInScreen completion:^(NSString * _Nonnull isSuccess, id _Nonnull resopnse) {
        
        callBack(isSuccess,resopnse);
    }];
}



+ (void)getBook:(NSString *)url withResult:(void (^)(NSString* errCode, id))callBack {
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",HOST,url];
    
    [GSNetwork request:newUrl withType:@"GET" withParameters:nil andLoad:kShowLoadInScreen completion:^(NSString * _Nonnull isSuccess, id _Nonnull resopnse) {
        
        callBack(isSuccess,resopnse);
    }];
}

@end

