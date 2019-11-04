//
//  BookCategoryCell.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/21.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryFrame.h"
#import "CategoryView.h"
#import "CategoryModel.h"

@class BookCategoryCell;
@protocol CategoryLookBookDetailDelegate<NSObject>

/**
 * cellType ： 表明是分类的cell还是排行的cell
 */
- (void)bookCategoryCell:(BookCategoryCell *)tableViewCell withModel:(CategoryModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BookCategoryCell : UITableViewCell <BookTypeInfoDelegate>

@property(nonatomic,weak) id<CategoryLookBookDetailDelegate>delagate;

//分类中每个cell上面的view
@property (nonatomic, strong) CategoryView *categoryView;

/** 控件的位置*/
@property (nonatomic, strong) CategoryFrame *categroyFrame;

@end

NS_ASSUME_NONNULL_END
