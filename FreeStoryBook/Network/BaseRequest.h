//
//  BaseRequest.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/20.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *HOST = @"http://app.duoduoxiaoshuo.com/";

NS_ASSUME_NONNULL_BEGIN

@interface BaseRequest : NSObject

#pragma mark --- 书架
+ (void)getBookCase:(NSString *)url withResult:(void (^)(NSString* errCode, id))callBack;

#pragma mark --- 精选
+ (void)HotBookRequest:(NSString *)url withPage:(int)index withResult:(void (^)(NSString* errCode, id))callBack;

#pragma mark --- 书库分类
+ (void)getBookCategory:(NSString *)url withResult:(void (^)(NSString* errCode, id))callBack;

#pragma mark --- 书库排行
+ (void)getBookRank:(NSString *)url withResult:(void (^)(NSString* errCode, id))callBack;

#pragma mark --- 书库排行更多
+ (void)getBookRankDetail:(NSString *)url withPage:(int)index withResult:(void (^)(NSString* errCode, id))callBack;

#pragma mark --- 搜索
+ (void)searchBook:(NSString *)url withkey:(NSString *)searchKey withPage:(int)index withResult:(void (^)(NSString* errCode, id))callBack;

#pragma mark -- 推荐
+ (void)searchRecommendBook:(NSString *)url withPage:(int)index withResult:(void (^)(NSString* errCode, id))callBack;

+ (void)getBook:(NSString *)url withResult:(void (^)(NSString* errCode, id))callBack;
@end

NS_ASSUME_NONNULL_END
