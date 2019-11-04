//
//  ReadBookController.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/26.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReadBookController : UIViewController

//当前book的model
@property (nonatomic, strong) BookModel *bookModel;
//当前开始读的id
@property (nonatomic, copy) NSString *read_id;
@end

NS_ASSUME_NONNULL_END
