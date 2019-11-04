//
//  BookSQLManager.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/25.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookSQLManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *queue;
@property (nonatomic, strong) FMDatabase *db;

+ (instancetype)shareDatabase;

/** 插入数据*/
- (BOOL)insertSearchKey:(NSString *)searchkey;
/** 获取全部数据*/
- (NSMutableArray *)querySearchHistoryBookName;
/** 删除数据*/
- (BOOL)deleteSearchName:(NSString *)searchkey;
/** 判断当前书名有没有存储过*/
- (BOOL)isExistBookName:(NSString *)bookName;
/** 清空缓存*/
- (void)clearData;

/** 获取书架上的所有book*/
- (NSMutableArray *)getAllBookInCase;
/** 往书架上新增book*/
- (BOOL)insertBookInCase:(BookModel *)model;
/** 删除书架上的某一个book*/
- (BOOL)deleteThisBookInCase:(BookModel *)model;
/** 判断书架上是否已存在该book*/
- (BOOL)isExistThisBookInCase:(BookModel *)model;
/** 删除书架上的所有book*/
- (void)clearBookCase;

/** 往数据库中添加已读书籍的页码*/
- (BOOL)insertBookReadPage:(NSString *)bookId withPage:(NSString *)readId;
/** 获取某一本书已经读到那一页了*/
- (NSString *)getBookReadPage:(NSString *)bookId;
/** 更新已读的页码*/
- (BOOL)updateBookReadPage:(NSString *)bookId withPage:(NSString *)readId;
/** 判断当前书有没有读过*/
- (BOOL)isExistReadBook:(NSString *)bookId;


#if 0
/******暂时不需要的*****/

//写入数据
- (void)addObjectToDB:(NSDictionary *)dic;
//删除数据
- (void)deleteObjectByItemid:(NSDictionary *)dic;
//修改数据
- (void)updateObjectDB:(NSDictionary *)dic;

/** 获取当前表中数据总条数*/
- (int)getSearchKeyCount;
/** 判断当前账号有没有存储过*/
- (BOOL)isExistAccount:(NSString *)account;
#endif



@end

NS_ASSUME_NONNULL_END
