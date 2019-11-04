//
//  BookRankCell.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/21.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
#import "RankView.h"
NS_ASSUME_NONNULL_BEGIN

@class BookRankCell;
@protocol RankLookBookDetailDelegate <NSObject>

- (void)bookRankCell:(BookRankCell *)tableViewCell clickBook:(CategoryModel *)model;


@end

@interface BookRankCell : UITableViewCell <ClickBookInRankViewDelegate>

@property (nonatomic, weak) id<RankLookBookDetailDelegate>delegate;

@property (nonatomic, strong) NSArray <CategoryModel*>*dataModel;

//分类中每个cell上面的view
@property (nonatomic, strong) RankView *rankView;

//- (void)setCellData:(NSArray <CategoryModel *>*)dataModel;


@end

NS_ASSUME_NONNULL_END
