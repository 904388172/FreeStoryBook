//
//  CategoryView.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/21.
//  Copyright © 2019 GS. All rights reserved.
//

#import "CategoryView.h"

@interface CategoryView ()
{
    NSArray *dataArray;
}
@end

@implementation CategoryView

- (void)setBookTypeInfoView:(NSArray <CategoryModel *>*)array {
    dataArray = [NSArray arrayWithArray:array];
    NSInteger num = (array.count + 1) / 2;
    float height = 120;
    float width = (SCREEN_WIDTH - 24*2) / 2;
    
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    UIView *bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(12);
        make.right.mas_equalTo(self).mas_offset(-12);
        make.top.mas_equalTo(self).offset(10);
        make.height.mas_offset((height + 10) * num + 10);
    }];
    
    for (int i = 0; i < array.count; i++) {
        UIView *bookView = [[UIView alloc] init];
        bookView.backgroundColor = [UIColor colorWithRed:(arc4random() % 255 /255.0) green:(arc4random() % 255 /255.0) blue:(arc4random() % 255 /255.0) alpha:0.2];
        bookView.tag = 10+i;
        [bgView addSubview:bookView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookType:)];
        [bookView addGestureRecognizer:tap];
        
        if (i % 2 == 0) {
            [bookView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(bgView.mas_left).offset(0);
                make.top.mas_equalTo(bgView.mas_top).mas_offset(i/2 * (height + 10) + 10);
                make.height.mas_equalTo(height);
                make.width.mas_equalTo(width);
            }];
        } else {
            [bookView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(bgView.mas_right).offset(0);
                make.top.mas_equalTo(bgView.mas_top).mas_offset(i/2 * (height + 10) + 10);
                make.height.mas_equalTo(height);
                make.width.mas_equalTo(width);
            }];
        }
        
        
        UIImageView * headImgView = [[UIImageView alloc] init];
        [headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgUrl,array[i].image_link]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
        [bookView addSubview:headImgView];
        [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bookView.mas_left).offset(8);
            make.top.mas_equalTo(bookView.mas_top).offset(8);
            make.bottom.mas_equalTo(bookView.mas_bottom).offset(-8);
            make.width.mas_equalTo((width - 24)/2);
        }];
        
        UILabel *typeLabel = [[UILabel alloc] init];
        typeLabel.font = [UIFont systemFontOfSize:14];
        typeLabel.text = array[i].title;
        [bookView addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headImgView.mas_right).offset(12);
            make.top.mas_equalTo(headImgView.mas_top).offset(12);
            make.right.mas_equalTo(bookView.mas_right).offset(12);
            make.height.mas_equalTo(30);
        }];
        
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.font = [UIFont systemFontOfSize:12];
        numLabel.textColor = [UIColor grayColor];
        numLabel.text = array[i].total;
        [bookView addSubview:numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(typeLabel.mas_left);
            make.top.mas_equalTo(typeLabel.mas_bottom);
            make.right.mas_equalTo(bookView.mas_right).offset(12);
        }];
    }
}

- (void)bookType:(UITapGestureRecognizer *)tap {
    // 4.通知代理现在选中哪一个
    if ([self.delegate respondsToSelector:@selector(bookTypeInfo:)])
    {
        [self.delegate bookTypeInfo:dataArray[tap.view.tag - 10]];
    }
}
@end
