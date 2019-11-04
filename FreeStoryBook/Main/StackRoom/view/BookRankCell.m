//
//  BookRankCell.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/21.
//  Copyright © 2019 GS. All rights reserved.
//

#import "BookRankCell.h"

@implementation BookRankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.rankView = [[RankView alloc] init];
        self.rankView.backgroundColor = [UIColor whiteColor];
        self.rankView.userInteractionEnabled = YES;
        self.rankView.delegate = self;
        [self.contentView addSubview:self.rankView];
        [self.rankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
        }];
    }
    return self;
}
//view上面每本book的点击回调
- (void)lookBookDetail:(CategoryModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookRankCell:clickBook:)])
    {
        [self.delegate bookRankCell:self clickBook:model];
    }
}
//设置cell上面的数据
- (void)setDataModel:(NSArray <CategoryModel*>*)dataModel {
    [self.rankView setBookRankView:dataModel];
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
