//
//  BookCategoryCell.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/21.
//  Copyright © 2019 GS. All rights reserved.
//

#import "BookCategoryCell.h"

@implementation BookCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.categoryView = [[CategoryView alloc] init];
        self.categoryView.backgroundColor = [UIColor whiteColor];
        self.categoryView.userInteractionEnabled = YES;
        self.categoryView.delegate = self;
        [self.contentView addSubview:self.categoryView];
    }
    return self;
}

- (void)bookTypeInfo:(CategoryModel *)model {
    if ([self.delagate respondsToSelector:@selector(bookCategoryCell:withModel:)])
    {
        [self.delagate bookCategoryCell:self withModel:model];
    }
}
//
- (void)setCategroyFrame:(CategoryFrame *)categoryFrame {
    _categroyFrame = categoryFrame;
    
    
    self.categoryView.frame = _categroyFrame.listViewF;
    [self.categoryView setBookTypeInfoView:_categroyFrame.showFamilyData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
