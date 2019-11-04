//
//  RankView.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/22.
//  Copyright © 2019 GS. All rights reserved.
//

#import "RankView.h"

@interface RankView ()
{
    NSArray *dataArray;
}
@end

@implementation RankView

- (void)setBookRankView:(NSArray <CategoryModel*>*)array {
    dataArray = array;
    
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    for (int i = 0; i < array.count; i++) {
        
        UIView *bgView = [[UIView alloc] init];
        bgView.tag = 10+i;
        [self addSubview:bgView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookDetail:)];
        [bgView addGestureRecognizer:tap];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset((SCREEN_WIDTH/4) * i);
            make.top.mas_equalTo(self).offset(24);
            make.bottom.mas_equalTo(self).offset(-24);
            make.width.mas_equalTo(SCREEN_WIDTH/4);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = array[i].book_name;
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.textColor = [UIColor grayColor];
        nameLabel.numberOfLines = 1;
        [bgView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(12);
            make.right.mas_equalTo(bgView.mas_right).offset(-12);
            make.bottom.mas_equalTo(bgView.mas_bottom);
            make.height.mas_equalTo(20);
        }];
        
        
        UIImageView * imgView = [[UIImageView alloc] init];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgUrl,array[i].image_link]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
        [bgView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(12);
            make.right.mas_equalTo(bgView.mas_right).offset(-12);
            make.top.mas_equalTo(bgView.mas_top);
            make.bottom.mas_equalTo(nameLabel.mas_top).offset(-10);
        }];
        
    }
}
- (void)bookDetail:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(lookBookDetail:)]) {
        [self.delegate lookBookDetail:dataArray[tap.view.tag - 10]];
    }
}

@end
