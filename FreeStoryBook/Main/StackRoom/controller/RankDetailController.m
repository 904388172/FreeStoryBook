//
//  RankDetailController.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/22.
//  Copyright © 2019 GS. All rights reserved.
//

#import "RankDetailController.h"
#import "BaseRequest.h"
#import "BookCaseCell.h"
#import "BookModel.h"
#import "GSTools.h"
#import "BookDetailController.h"

@interface RankDetailController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *table;

@property (nonatomic ,strong) NSMutableArray *dataArray;

//页数
@property (nonatomic ,assign) int pageIndex;

@end

@implementation RankDetailController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.typeDic[@"title"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageIndex = 1;
    
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(UI_FRAME_ZERO);
        make.bottom.mas_equalTo(self.view);
        make.leading.trailing.mas_equalTo(0);
    }];
    //此处写入让其不显示下划线的代码
    self.table.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    //集成下拉刷新控件
    [self setupDownRefresh];
    
    //集成上拉刷新控件
    [self setupUpRefresh];
}

/**
 *  集成上拉刷新控件
 */
- (void)setupUpRefresh
{
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreBills)];
}

/**
 *  集成下拉刷新控件
 */
- (void)setupDownRefresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewBills)];
    
    // 马上进入刷新状态
    [self.table.mj_header beginRefreshing];
}

/**
 *  加载下拉刷新数据
 */
- (void)loadNewBills
{
    _pageIndex=1;//默认加载第一页
    [self.dataArray removeAllObjects];//移除所有的数据
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@/",@"book/",self.detailType,self.typeDic[@"more"]];
    [BaseRequest getBookRankDetail:url withPage:_pageIndex withResult:^(NSString * _Nonnull errCode, id _Nonnull result) {
        
        if ([errCode isEqualToString:@"0"]) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            arr = result[@"Data"][@"list"];
            
            for (int i = 0; i < arr.count; i++) {
                BookModel *model = [[BookModel alloc] mj_setKeyValues:arr[i]];
                [self.dataArray addObject:model];
            }
            // 刷新表格
            [self.table reloadData];
            
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.table.mj_header endRefreshing];
        } else {
            [self.table.mj_header endRefreshing];
        }
        
    }];
}
/**
 *  加载上拉刷新数据
 */
-(void)loadMoreBills
{
    //1.设置页数
    _pageIndex++;//默认加载第一页
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@/",@"book/",self.detailType,self.typeDic[@"more"]];
    [BaseRequest getBookRankDetail:url withPage:_pageIndex withResult:^(NSString * _Nonnull errCode, id _Nonnull result) {
        
        if ([errCode isEqualToString:@"0"]) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            if ([result[@"Data"] isKindOfClass:[NSDictionary class]]) {
                arr = result[@"Data"][@"list"];
                
                for (int i = 0; i < arr.count; i++) {
                    BookModel *model = [[BookModel alloc] mj_setKeyValues:arr[i]];
                    [self.dataArray addObject:model];
                }
                
                // 刷新表格
                [self.table reloadData];
                
                // 拿到当前的下拉刷新控件，结束刷新状态
                [self.table.mj_footer endRefreshing];
                
            } else {
                self.pageIndex --;
                // 拿到当前的下拉刷新控件，结束刷新状态
                [self.table.mj_footer endRefreshing];
            }
        } else {
            NSLog(@"失败");
            [self.table.mj_footer endRefreshing];
        }
        
    }];
}

#pragma mark -- delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellId";
    BookCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BookCaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BookModel *model = self.dataArray[indexPath.section];
    
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgUrl,model.image_link]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    cell.namelabel.text = model.book_name;
    cell.profilesLabel.text = model.profiles;
    cell.authorlabel.text = [NSString stringWithFormat:@"%@  %@",model.author,[GSTools exchangeNumberToString:model.word]];
    if ([model.is_over isEqualToString:@"0"]) {
        //连载中
        cell.statelabel.text = @"连载中";
    } else {
        //完结
        cell.statelabel.text = @"完结";
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookModel *model = self.dataArray[indexPath.section];
    
    BookDetailController *vc = [[BookDetailController alloc] init];
    vc.bookModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
