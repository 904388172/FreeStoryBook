//
//  CategoryModel.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/22.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryModel : NSObject
@property (nonatomic ,copy) NSString *target_link;
@property (nonatomic ,copy) NSString *image_link;

//分类
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *pinyin;
@property (nonatomic ,copy) NSString *total;


//排行
@property (nonatomic ,copy) NSString *profiles;
@property (nonatomic ,copy) NSString *author;
@property (nonatomic ,copy) NSString *score;
@property (nonatomic ,copy) NSString *book_id;
@property (nonatomic ,copy) NSString *book_name;
@property (nonatomic ,copy) NSString *word;

@end

NS_ASSUME_NONNULL_END
