//
//  CategoryFrame.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/21.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryFrame : NSObject

/** cell上面view的frame*/
@property (nonatomic, assign) CGRect listViewF;

/** cell高度*/
@property (nonatomic, assign, readonly) CGFloat cellHeight;

/** 每个cell上面显示的数据*/
@property (nonatomic, strong) NSArray <CategoryModel *>*showFamilyData;


@end

NS_ASSUME_NONNULL_END
