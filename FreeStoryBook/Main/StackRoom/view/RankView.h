//
//  RankView.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/22.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ClickBookInRankViewDelegate <NSObject>

- (void)lookBookDetail:(CategoryModel *)model;

@end

@interface RankView : UIView

@property (nonatomic, weak) id<ClickBookInRankViewDelegate>delegate;

- (void)setBookRankView:(NSArray <CategoryModel*>*)array;

@end

NS_ASSUME_NONNULL_END
