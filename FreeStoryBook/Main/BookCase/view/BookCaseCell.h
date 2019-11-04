//
//  BookCaseCell.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/20.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookCaseCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImgView;

@property (nonatomic, strong) UILabel *namelabel;

@property (nonatomic, strong) UILabel *profilesLabel;

@property (nonatomic, strong) UILabel *authorlabel;

@property (nonatomic, strong) UILabel *statelabel;


@end

NS_ASSUME_NONNULL_END
