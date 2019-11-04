//
//  CategoryView.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/21.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BookTypeInfoDelegate <NSObject>

- (void)bookTypeInfo:(CategoryModel *)model;

@end

@interface CategoryView : UIView

// 代理属性
@property (nonatomic, weak) id<BookTypeInfoDelegate> delegate;

- (void)setBookTypeInfoView:(NSArray <CategoryModel*>*)array;
@end

NS_ASSUME_NONNULL_END
