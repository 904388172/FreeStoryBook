//
//  BookSQLManager.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/25.
//  Copyright © 2019 GS. All rights reserved.
//

#import "BookSQLManager.h"

@implementation BookSQLManager

+ (instancetype)shareDatabase {
    static BookSQLManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BookSQLManager alloc] init];
        [instance creatQueue];
    });
    return instance;
}

#pragma mark -- 创建路径
- (void)creatQueue {
    NSString *queuePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"BookSearchRecord.db"];
    _queue = [FMDatabaseQueue databaseQueueWithPath:queuePath];
    if (_queue) {
        NSLog(@"BookSearchRecord数据库创建成功~");
        [self creatTable];
    } else {
        NSLog(@"怎么回事？失败了？");
    }
}
#pragma mark -- 创建表格
- (void)creatTable {
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            //单引号‘’中为表格的字段名，逗号后面为字段所属类型，字段类型是整形就用interger，字符串就用text。
    //        BOOL res = [db executeStatements:@"CREATE TABLE IF NOT EXISTS 'BookSearchRecord' ('username' text, 'searchkey' text, idNew INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT);"];
            
    //        NSString *sql_account = @"CREATE TABLE IF NOT EXISTS BookSearchRecord ('searchkey' text,account text NOT NULL);";
            NSString *sql_searchkey = @"CREATE TABLE IF NOT EXISTS BookSearchRecord (searchkey text NOT NULL);";
            
            NSString *sql_book = @"CREATE TABLE IF NOT EXISTS BookCaseDB (bookId text NOT NULL,bookName text NOT NULL,author text,category text,isVip text,price text,imageLink text,isNew text,word text,profiles text,bookType text,score text,latestChapter text);";
            
            NSString *sql_read = @"CREATE TABLE IF NOT EXISTS BookReadDB (bookId text NOT NULL,readId text NOT NULL);";
            
            BOOL res_searchkey = [db executeUpdate:sql_searchkey];
            BOOL res_book = [db executeUpdate:sql_book];
            BOOL res_read = [db executeUpdate:sql_read];
            
            NSLog(@"%@",res_searchkey ? @"创建表格成功" : @"创建表格失败");
            NSLog(@"%@",res_book ? @"创建res_book表格成功" : @"创建res_book表格失败");
        } else {
            NSLog(@"打开数据库失败：creatTable");
        }
    }];
}

/** 插入数据*/
-(BOOL)insertSearchKey:(NSString *)searchkey {
    __block BOOL result = NO;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = @"INSERT OR REPLACE INTO BookSearchRecord(searchkey)""VALUES(?);";
            
            BOOL res = [db executeUpdate:sql, searchkey];
            
            if (!res) {
                NSLog(@"增加失败");
                result = NO;
            } else {
                NSLog(@"增加成功");
                result = YES;
            }
        } else {
            NSLog(@"打开数据库失败");
            result = NO;
        }
    }];
    
    return result;
}


/** 获取全部数据*/
- (NSMutableArray *)querySearchHistoryBookName {
    __block NSMutableArray *bookNameArray = [[NSMutableArray alloc] init];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = @"SELECT * FROM BookSearchRecord";
            
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                NSString *searchkey = [rs stringForColumn:@"searchkey"];
                
                [bookNameArray addObject:searchkey];
            }
        } else {
            NSLog(@"打开数据库失败");
        }
    }];
    
    return bookNameArray;
}

/** 删除数据*/
- (BOOL)deleteSearchName:(NSString *)searchkey {
    __block BOOL result = NO;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = @"DELETE FROM BookSearchRecord WHERE searchkey = ?";
            
            BOOL res = [db executeUpdate:sql, searchkey];
            
            if (!res) {
                NSLog(@"删除失败");
                result = NO;
            } else {
                NSLog(@"删除成功");
                result = YES;
            }
        } else {
            NSLog(@"打开数据库失败");
            result = NO;
        }
    }];
    
    return result;
}

//- (int)getSearchKeyCount {
//    __block int keyCount = -1;
//    [self.queue inDatabase:^(FMDatabase *db) {
//        if ([db open]) {
//            NSString *sql = @"SELECT SUM(searchkey) keyCount FROM BookSearchRecord";
//            
//            FMResultSet *rs = [db executeQuery:sql];
//            
//            while ([rs next]) {
//                keyCount = [rs intForColumn:@"keyCount"];
//            }
//        } else {
//            NSLog(@"打开数据库失败");
//        }
//    }];
//    
//    return keyCount;
//}


/** 判断当前书名有没有存储过*/
- (BOOL)isExistBookName:(NSString *)bookName {
    __block BOOL result = NO;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = @"SELECT * FROM BookSearchRecord WHERE searchkey = ?";
            
            FMResultSet *rs = [db executeQuery:sql, bookName];
            
            while ([rs next]) {
                result = YES;
            }
        } else {
            NSLog(@"打开数据库失败");
            result = NO;
        }
    }];
    
    return result;
}

/** 删除数据库*/
- (void)clearData {
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            BOOL res = [db executeUpdate:@"DELETE FROM BookSearchRecord"];
            
            if (!res) {
                NSLog(@"删除数据库失败");
            } else {
                NSLog(@"删除数据库成功");
            }
            
        } else {
            NSLog(@"打开数据库失败");
        }
    }];
}





/** 获取书架上的所有book*/
- (NSMutableArray *)getAllBookInCase {
    __block NSMutableArray *bookArray = [[NSMutableArray alloc] init];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = @"SELECT * FROM BookCaseDB";
            
            FMResultSet *rs = [db executeQuery:sql];
            
            while ([rs next]) {
                NSString *bookId = [rs stringForColumn:@"bookId"];
                NSString *bookName = [rs stringForColumn:@"bookName"];
                NSString *author = [rs stringForColumn:@"author"];
                NSString *category = [rs stringForColumn:@"category"];
                NSString *isVip = [rs stringForColumn:@"isVip"];
                NSString *price = [rs stringForColumn:@"price"];
                NSString *imageLink = [rs stringForColumn:@"imageLink"];
                NSString *isNew = [rs stringForColumn:@"isNew"];
                NSString *word = [rs stringForColumn:@"word"];
                NSString *profiles = [rs stringForColumn:@"profiles"];
                NSString *isOver = [rs stringForColumn:@"isOver"];
                NSString *bookType = [rs stringForColumn:@"bookType"];
                NSString *score = [rs stringForColumn:@"score"];
                NSString *latestChapter = [rs stringForColumn:@"latestChapter"];
                
                NSMutableDictionary *bookDic = [[NSMutableDictionary alloc] init];
                [bookDic setValue:bookId forKey:@"book_id"];
                [bookDic setValue:bookName forKey:@"book_name"];
                [bookDic setValue:author forKey:@"author"];
                [bookDic setValue:category forKey:@"category"];
                [bookDic setValue:isVip forKey:@"is_vip"];
                [bookDic setValue:price forKey:@"price"];
                [bookDic setValue:imageLink forKey:@"image_link"];
                [bookDic setValue:isNew forKey:@"is_new"];
                [bookDic setValue:word forKey:@"word"];
                [bookDic setValue:profiles forKey:@"profiles"];
                [bookDic setValue:isOver forKey:@"is_over"];
                [bookDic setValue:bookType forKey:@"book_type"];
                [bookDic setValue:score forKey:@"score"];
                [bookDic setValue:latestChapter forKey:@"latest_chapter"];
                
                BookModel *bookModel = [[BookModel alloc] mj_setKeyValues:bookDic];
                
                [bookArray addObject:bookModel];
            }
        } else {
            NSLog(@"打开数据库失败");
        }
        [db close];
    }];
    
    return bookArray;
}
/** 往书架上新增book*/
- (BOOL)insertBookInCase:(BookModel *)model {
    __block BOOL result = NO;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            
            NSString *sql = @"INSERT OR REPLACE INTO BookCaseDB(bookId, bookName, author, category, isVip, price, imageLink, isNew, word, profiles, bookType, score, latestChapter) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?);";
            
            BOOL res = [db executeUpdate:sql,model.book_id,model.book_name,model.author,model.category,model.is_vip,model.price,model.image_link,model.is_new,model.word,model.profiles,model.book_type,model.score,model.latest_chapter,model.book_id];
            
            if (!res) {
                NSLog(@"增加失败");
                result = NO;
            } else {
                NSLog(@"增加成功");
                result = YES;
            }
        } else {
            NSLog(@"打开数据库失败");
            result = NO;
        }
        [db close];
    }];
    
    return result;
}
/** 删除书架上的某一个book*/
- (BOOL)deleteThisBookInCase:(BookModel *)model {
    __block BOOL result = NO;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = @"DELETE FROM BookCaseDB WHERE bookId = ?";
            
            BOOL res = [db executeUpdate:sql, model.book_id];
            
            if (!res) {
                NSLog(@"删除失败");
                result = NO;
            } else {
                NSLog(@"删除成功");
                result = YES;
            }
        } else {
            NSLog(@"打开数据库失败");
            result = NO;
        }
        [db close];
    }];
    
    return result;
}

/** 判断书架上是否已存在该book*/
- (BOOL)isExistThisBookInCase:(BookModel *)model {
    __block BOOL result = NO;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = @"SELECT * FROM BookCaseDB WHERE bookId = ?";
            
            FMResultSet *rs = [db executeQuery:sql, model.book_id];
            
            while ([rs next]) {
                result = YES;
            }
        } else {
            NSLog(@"打开数据库失败");
            result = NO;
        }
        [db close];
    }];
    
    return result;
}
/** 删除书架上的所有book*/
- (void)clearBookCase {
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            BOOL res = [db executeUpdate:@"DELETE FROM BookCaseDB"];
            
            if (!res) {
                NSLog(@"删除数据库失败");
            } else {
                NSLog(@"删除数据库成功");
            }
            
        } else {
            NSLog(@"打开数据库失败");
        }
        [db close];
    }];
}



/** 往数据库中添加已读书籍的页码*/
- (BOOL)insertBookReadPage:(NSString *)bookId withPage:(NSString *)readId {
    __block BOOL result = NO;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            
            NSString *sql = @"INSERT OR REPLACE INTO BookReadDB(bookId, readId) VALUES (?,?);";
        
            BOOL res = [db executeUpdate:sql,bookId,readId,bookId];
            
            
            if (!res) {
                NSLog(@"增加失败");
                result = NO;
            } else {
                NSLog(@"增加成功");
                result = YES;
            }
        } else {
            NSLog(@"打开数据库失败");
            result = NO;
        }
        [db close];
    }];
    
    return result;
}
/** 获取某一本书已经读到那一页了*/
- (NSString *)getBookReadPage:(NSString *)bookId {
    __block NSString *page = [[NSString alloc] init];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = @"SELECT * FROM BookReadDB";
            
            FMResultSet *rs = [db executeQuery:sql];
            
            while ([rs next]) {
                NSString *cbookId = [rs stringForColumn:@"bookId"];
                NSString *creadId = [rs stringForColumn:@"readId"];
                
                if ([bookId isEqualToString:cbookId]) {
                    page = creadId;
                }
            }
        } else {
            NSLog(@"打开数据库失败");
        }
        [db close];
    }];
    
    return page;
}
/** 更新已读的页码*/
- (BOOL)updateBookReadPage:(NSString *)bookId withPage:(NSString *)readId {
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            //创建sql语句
            NSString *sql = [NSString stringWithFormat:@"UPDATE BookReadDB set readId = '%@' where bookId = '%@'",readId,bookId];
            //修改图书
            if ([db executeUpdate:sql]) {
                NSLog(@"修改图书成功！");
            }else{
                NSLog(@"修改图书失败！");
            }
        }else{
            NSLog(@"打开数据库失败！");
        }
        //关闭数据库
        [db close];
    }];
    
    return NO;
}
/** 判断当前书有没有读过*/
- (BOOL)isExistReadBook:(NSString *)bookId {
    __block BOOL result = NO;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = @"SELECT * FROM BookReadDB WHERE bookId = ?";
            
            FMResultSet *rs = [db executeQuery:sql, bookId];
            
            while ([rs next]) {
                result = YES;
            }
        } else {
            NSLog(@"打开数据库失败");
            result = NO;
        }
        [db close];
    }];
    
    return result;
}



#pragma mark -- 下面暂时不需要
#if 0
#pragma mark -- 写入数据
- (void)addObjectToDB:(NSDictionary *)dic {
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            BOOL isOK = [db executeStatements:[NSString stringWithFormat:@"INSERT INFO BookSearchRecord (username,searchkey,idNew) VALUES ('%@','%@','%zd')", dic[@"userName"],dic[@"searchKey"]]];
            
            if (isOK) {
                NSLog(@"写入数据成功～");
            } else {
                NSLog(@"写入数据失败～");
            }
        }
        [db close];
    }];
}
#pragma mark -- 删除数据
- (void)deleteObjectByItemid:(NSDictionary *)dic {
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            BOOL isOK = [db executeStatements:[NSString stringWithFormat:@"DELETE FROM BookSearchRecord WHERE itemid = '%@'",dic[@"itemid"]]];
            
            if (isOK) {
                NSLog(@"删除BookSearchRecord itemid = %@ searchKey = %@ 这一行",dic[@"itemid"],dic[@"searchKey"]);
            } else {
                NSLog(@"删除BookSearchRecord 行失败～");
            }
        }
        [db close];
    }];
}
#pragma mark -- 修改数据
- (void)updateObjectDB:(NSDictionary *)dic {
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE idNew = %@",@"BookSearchRecord", dic[@"idNew"]];
            
            FMResultSet *set = [db executeQuery:selectSql];
            
            if ([set next]) { //为真，查到了结果集
                NSString *modifySql = [NSString stringWithFormat:@"UPDATE BookSearchRecord SET searchkey = '%@' WHERE idNew = %zd", dic[@"searchKey"], dic[@"idNew"]];
                
                BOOL isModifySuccess = [db executeUpdate:modifySql];
                
                if (isModifySuccess) {
                    NSLog(@"修改成功～");
                }
                
            } else {
                NSLog(@"未查询到需要修改的数据，所以无法修改");
            }
            [set close];
        }
        [db close];
    }];
}






- (BOOL)isExistAccount:(NSString *)account {
    __block BOOL result = NO;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = @"SELECT * FROM BookSearchRecord WHERE account = ?";
            
            FMResultSet *rs = [db executeQuery:sql, account];
            
            while ([rs next]) {
                result = YES;
            }
        } else {
            NSLog(@"打开数据库失败");
            result = NO;
        }
    }];
    
    return result;
}
#endif

@end
