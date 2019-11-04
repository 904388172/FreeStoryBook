//
//  BookModel.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/20.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookModel : NSObject

@property (nonatomic , copy) NSString *book_id;
@property (nonatomic , copy) NSString *book_name;
@property (nonatomic , copy) NSString *author;
@property (nonatomic , copy) NSString *category;
@property (nonatomic , copy) NSString *is_vip;
@property (nonatomic , copy) NSString *price;
@property (nonatomic , copy) NSString *image_link;
@property (nonatomic , copy) NSString *is_new;
@property (nonatomic , copy) NSString *word;
@property (nonatomic , copy) NSString *profiles;
@property (nonatomic , copy) NSString *is_over;
@property (nonatomic , copy) NSString *book_type;
@property (nonatomic , copy) NSString *score;
@property (nonatomic , copy) NSString *latest_chapter;

@end

NS_ASSUME_NONNULL_END
