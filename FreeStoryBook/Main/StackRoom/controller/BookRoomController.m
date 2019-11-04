//
//  BookRoomController.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/19.
//  Copyright © 2019 GS. All rights reserved.
//

#import "BookRoomController.h"
#import "BaseRequest.h"
#import "BookRoomNavView.h"
#import "BookCategoryCell.h"
#import "BookRankCell.h"
#import "CategoryFrame.h"
#import "CategoryView.h"
#import "RankDetailController.h"
#import "BookDetailController.h"

@interface BookRoomController ()<BookRoomNavViewDelegate,UITableViewDelegate,UITableViewDataSource,CategoryLookBookDetailDelegate,RankLookBookDetailDelegate>
@property (nonatomic ,strong) BookRoomNavView *nav;

@property (nonatomic ,strong) UITableView *table;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,assign) int curSelectIndex;

@end

@implementation BookRoomController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.curSelectIndex = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //自定义导航
    [self setNavView];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(UI_FRAME_ZERO);
        make.bottom.mas_equalTo(self.view).offset(-49);
        make.leading.trailing.mas_equalTo(0);
    }];
    //此处写入让其不显示下划线的代码
    self.table.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    //获取分类列表
    [self getCategoryList];
    
}
#pragma mark -- delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.curSelectIndex == 2) {
        return 180;
    } else {
        CategoryFrame *mainframe = [[CategoryFrame alloc] init];
        mainframe.showFamilyData = self.dataArray[indexPath.section][@"list"];
        return mainframe.cellHeight;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UIView *iconV = [[UIView alloc] init];
    iconV.backgroundColor = [UIColor redColor];
    iconV.layer.cornerRadius = 1;
    [headView addSubview:iconV];
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(headView).offset(14);
        make.size.mas_equalTo(CGSizeMake(5, 16));
        make.centerY.mas_equalTo(headView.mas_centerY);
    }];
    
    if (self.curSelectIndex == 2) {
        
        headView.tag = 10+section;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookMore:)];
        [headView addGestureRecognizer:tap];
        
        UIImageView *rarrow = [[UIImageView alloc] init];
        rarrow.image = [UIImage imageNamed:@"gengduojiantou.png"];
        [headView addSubview:rarrow];
        [rarrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(headView).offset(-12);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.mas_equalTo(headView.mas_centerY);
        }];
        
        UILabel *morelabel = [[UILabel alloc] init];
        morelabel.textColor = [UIColor grayColor];
        morelabel.text = @"更多";
        morelabel.font = [UIFont systemFontOfSize:12];
        morelabel.textAlignment = NSTextAlignmentRight;
        [headView addSubview:morelabel];
        [morelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(rarrow.mas_leading).offset(-5);
            make.top.mas_equalTo(headView);
            make.bottom.mas_equalTo(headView);
        }];
    }
    
    UILabel *headlabel = [[UILabel alloc] init];
    headlabel.text = self.dataArray[section][@"title"];
    headlabel.font = [UIFont systemFontOfSize:14];
    [headView addSubview:headlabel];
    [headlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(iconV).offset(12);
        make.top.mas_equalTo(headView);
        make.bottom.mas_equalTo(headView);
    }];
    
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.curSelectIndex == 2) {
        static NSString *CellIdentifier = @"RankCell";
        BookRankCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[BookRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *arr = [NSArray arrayWithArray:self.dataArray[indexPath.section][@"list"]];
        NSMutableArray *cellData = [[NSMutableArray alloc] init];
        for (int i = 0; i < arr.count; i++) {
            CategoryModel *model = [[CategoryModel alloc] mj_setKeyValues:arr[i]];
            [cellData addObject:model];
        }
        //设置cell的数据
        cell.dataModel = cellData;
        cell.delegate = self;
        return cell;
    } else {
        static NSString *CellIdentifier = @"CategoryCell";
        BookCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[BookCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        CategoryFrame *mainFrame = [[CategoryFrame alloc] init];
        NSArray *arr = [NSArray arrayWithArray:self.dataArray[indexPath.section][@"list"]];
        NSMutableArray *cellData = [[NSMutableArray alloc] init];
        for (int i = 0; i < arr.count; i++) {
            CategoryModel *model = [[CategoryModel alloc] mj_setKeyValues:arr[i]];
            [cellData addObject:model];
        }
    
        mainFrame.showFamilyData = cellData;;
        // 设置数据
        cell.categroyFrame = mainFrame;
        cell.delagate = self;
        return cell;
    }
}

#pragma mark -- 查看更多
- (void)lookMore:(UITapGestureRecognizer *)tap {    
    RankDetailController *vc = [[RankDetailController alloc] init];
    vc.typeDic = self.dataArray[tap.view.tag - 10];
    vc.detailType = @"rankDetail";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 分类中每类书的点击
- (void)bookCategoryCell:(BookCategoryCell *)tableViewCell withModel:(CategoryModel *)model{
  
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:model.title forKey:@"title"];
    [dic setValue:model.pinyin forKey:@"more"];
    RankDetailController *vc = [[RankDetailController alloc] init];
    vc.typeDic = dic;
    vc.detailType = @"categoryDetail";
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark -- 排行中每本书的点击
- (void)bookRankCell:(BookRankCell *)tableViewCell clickBook:(CategoryModel *)model {

    //跳转到详细
    BookDetailController *vc = [[BookDetailController alloc] init];
    vc.bookModel = (BookModel *)model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- navDelegate
- (void)returnSelectedViewIndex:(int)index {
    NSLog(@"%@%d",@"点击的是第几个：",index);
    self.curSelectIndex = index;
    if (index == 2) {
        [self getRankList];
    } else {
        [self getCategoryList];
    }
}
#pragma mark -- 自定义导航
- (void)setNavView {
    
    self.nav= [[BookRoomNavView alloc] init];
    self.nav.delegate = self;
    [self.view addSubview:self.nav];
    [self.nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
}

- (void)getCategoryList {
    [BaseRequest getBookCategory:BookCategory withResult:^(NSString * _Nonnull errCode, id _Nonnull result) {
        
        if ([errCode isEqualToString:@"0"]) {
            self.dataArray = result[@"Data"];
            // 刷新表格
            [self.table reloadData];

        } else {
            NSLog(@"失败");
        }
    }];
}
- (void)getRankList {
    [BaseRequest getBookRank:BookRank withResult:^(NSString * _Nonnull errCode, id _Nonnull result) {
        if ([errCode isEqualToString:@"0"]) {
           
            self.dataArray = result[@"Data"];
            // 刷新表格
            [self.table reloadData];
           
        } else {
            NSLog(@"失败");
        }
    }];
}

@end
