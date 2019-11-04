//
//  BookRoomNavView.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/21.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BookRoomNavViewDelegate <NSObject>

@optional
- (void)returnSelectedViewIndex:(int)index;

@end

@interface BookRoomNavView : UIView

@property (nonatomic, weak) id<BookRoomNavViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
