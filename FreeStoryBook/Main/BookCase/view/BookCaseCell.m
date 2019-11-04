//
//  BookCaseCell.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/20.
//  Copyright © 2019 GS. All rights reserved.
//

#import "BookCaseCell.h"

@implementation BookCaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.headImgView = [[UIImageView alloc] init];
        self.headImgView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.headImgView];
        [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).offset(12);
            make.size.mas_equalTo(CGSizeMake(70, 120 - 24));
            make.top.mas_equalTo(self).offset(12);
        }];
        
        // 名称
        self.namelabel = [[UILabel alloc]init];
        self.namelabel.font = [UIFont systemFontOfSize:16];
        self.namelabel.textColor = [UIColor blackColor];
        self.namelabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.namelabel];
        [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(12);
            make.trailing.mas_equalTo(self).offset(-12);
            make.top.mas_equalTo(self.headImgView.mas_top).offset(5);
            make.height.mas_equalTo(22);
        }];
        
        
        UIImageView *uImgview = [[UIImageView alloc] init];
        uImgview.image = [UIImage imageNamed:@"yonghu.png"];
        [self.contentView addSubview:uImgview];
        [uImgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(12);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.bottom.mas_equalTo(self.headImgView.mas_bottom);
        }];
        
        self.statelabel = [[UILabel alloc]init];
        self.statelabel.font = [UIFont systemFontOfSize:12];
        self.statelabel.textColor = [UIColor grayColor];
        self.statelabel.textAlignment = NSTextAlignmentCenter;
        self.statelabel.layer.cornerRadius = 4.0;
        self.statelabel.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1].CGColor;
        self.statelabel.layer.borderWidth = 1.0f;//设置边框粗细
        self.statelabel.layer.masksToBounds = YES;
        self.statelabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.statelabel];
        [self.statelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 22));
            make.trailing.mas_equalTo(self).offset(-12);
            make.bottom.mas_equalTo(self.headImgView.mas_bottom);
        }];
        
        self.authorlabel = [[UILabel alloc]init];
        self.authorlabel.font = [UIFont systemFontOfSize:14];
        self.authorlabel.numberOfLines = 2;
        self.authorlabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.authorlabel];
        [self.authorlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(uImgview.mas_trailing).offset(5);
            make.trailing.mas_equalTo(self.statelabel.mas_leading).offset(-12);
            make.bottom.mas_equalTo(self.headImgView.mas_bottom);
            make.height.mas_equalTo(22);
        }];
        
        self.profilesLabel = [[UILabel alloc]init];
        self.profilesLabel.font = [UIFont systemFontOfSize:14];
        self.profilesLabel.numberOfLines = 2;
        self.profilesLabel.textColor = [UIColor grayColor];
        self.profilesLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.profilesLabel];
        [self.profilesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.namelabel.mas_leading);
            make.trailing.mas_equalTo(self).offset(-12);
            make.top.mas_equalTo(self.namelabel.mas_bottom).offset(5);
        }];
    }
    return self;
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
