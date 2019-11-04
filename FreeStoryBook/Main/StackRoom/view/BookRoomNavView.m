//
//  BookRoomNavView.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/21.
//  Copyright © 2019 GS. All rights reserved.
//

#import "BookRoomNavView.h"

@interface BookRoomNavView (){
    
    UIView *leftView;
    UILabel *leftLabel;
    UILabel *leftLine;
    
    
    UIView *rightView;
    UILabel *rightLabel;
    UILabel *rightLine;
}
@end

@implementation BookRoomNavView

- (instancetype) initWithFrame:(CGRect)frame {
    
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        leftView = [[UIView alloc] init];
        [self addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self);
            make.top.mas_equalTo(self).offset(20);
            make.bottom.mas_equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
        }];
        leftView.tag = 1;
        //添加手势
        UITapGestureRecognizer * leftTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemBarCilck:)];
        
        [leftView addGestureRecognizer:leftTapGesture];
        
        leftLabel = [[UILabel alloc] init];
        leftLabel.text = @"分类";
        leftLabel.textColor = [UIColor redColor];
        leftLabel.font = [UIFont systemFontOfSize:16];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        [leftView addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self->leftView);
            make.top.mas_equalTo(self->leftView);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
            make.bottom.mas_equalTo(self->leftView.mas_bottom).offset(-5);
        }];
        
        leftLine = [[UILabel alloc] init];
        leftLine.backgroundColor = [UIColor redColor];
        [leftView addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self->leftView.mas_centerX);
            make.top.mas_equalTo(self->leftLabel.mas_bottom);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(2);
        }];
        
        
        
        
        rightView = [[UIView alloc] init];
        [self addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self);
            make.top.mas_equalTo(self).offset(20);
            make.bottom.mas_equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
        }];
        rightView.tag = 2;
        //添加手势
        UITapGestureRecognizer * rightTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemBarCilck:)];
        [rightView addGestureRecognizer:rightTapGesture];
        
        rightLabel = [[UILabel alloc] init];
        rightLabel.text = @"排行";
        rightLabel.textColor = [UIColor grayColor];
        rightLabel.font = [UIFont systemFontOfSize:16];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        [rightView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self->rightView);
            make.top.mas_equalTo(self->rightView);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
            make.bottom.mas_equalTo(self->rightView.mas_bottom).offset(-5);
        }];
        
        rightLine = [[UILabel alloc] init];
        
        [rightView addSubview:rightLine];
        rightLine.backgroundColor = [UIColor whiteColor];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self->rightView.mas_centerX);
            make.top.mas_equalTo(self->rightLabel.mas_bottom);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(2);
        }];
        
        
        
    }
    return self;
}

- (void)itemBarCilck:(UITapGestureRecognizer *)tap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnSelectedViewIndex:)]) {
        [self.delegate returnSelectedViewIndex:(int)tap.view.tag];
    }
    if (tap.view.tag == 2) {
        leftLabel.textColor = [UIColor grayColor];
        leftLine.backgroundColor = [UIColor whiteColor];
        rightLabel.textColor = [UIColor redColor];
        rightLine.backgroundColor = [UIColor redColor];
    } else {
        leftLabel.textColor = [UIColor redColor];
        leftLine.backgroundColor = [UIColor redColor];
        rightLabel.textColor = [UIColor grayColor];
        rightLine.backgroundColor = [UIColor whiteColor];
    }
}
@end
