//
//  BookDetailController.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/28.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookDetailController : UIViewController

//当前book的model
@property (nonatomic, strong) BookModel *bookModel;

@end

NS_ASSUME_NONNULL_END
