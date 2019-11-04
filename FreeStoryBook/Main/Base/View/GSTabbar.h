//
//  GSTabbar.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/19.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSTabbar;

@protocol GSTabbarDelagate <NSObject>

@optional
- (void)tabBarPlusBtnClick:(GSTabbar *)tabBar;

@end

NS_ASSUME_NONNULL_BEGIN

@interface GSTabbar : UITabBar

/** tabbar的代理 */
@property (nonatomic, weak) id<GSTabbarDelagate> delegate;

@end

NS_ASSUME_NONNULL_END
