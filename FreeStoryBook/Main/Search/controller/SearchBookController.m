//
//  SearchBookController.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/22.
//  Copyright © 2019 GS. All rights reserved.
//

#import "SearchBookController.h"
#import "BaseRequest.h"
#import "BookCaseCell.h"
#import "BookModel.h"
#import "GSTools.h"
#import "UIColor+GSColor.h"
#import "BookSQLManager.h"
#import "BookDetailController.h"

@interface SearchBookController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;

//搜索到的书籍列表的table
@property (nonatomic, strong) UITableView *bookTable;
//历史记录的table
@property (nonatomic, strong) UITableView *recordTable;

//搜索到的数据
@property (nonatomic, strong) NSMutableArray *bookArray;
//搜索的记录
@property (nonatomic, strong) NSMutableArray *recordArray;
//搜索的页数
@property (nonatomic, assign) int pageIndex;
//小编推荐的页数
@property (nonatomic, assign) int recIndex;

//搜索到书籍展示的页面
@property (nonatomic, strong) UIView *bookView;
//搜索页面没有搜索到书籍显示推荐提示
@property (nonatomic, strong) UIView *topView;
//未找到搜索的book时提示文字
@property (nonatomic, strong) UILabel *tipLabel;
//显示搜索历史的页面
@property (nonatomic, strong) UIView *recordView;



//是否搜索了，默认为false
@property (nonatomic, assign) BOOL searched;

@property (nonatomic, strong) BookSQLManager *sqlManager;

@end

@implementation SearchBookController
- (NSMutableArray *)bookArray {
    if (!_bookArray) {
        _bookArray = [[NSMutableArray alloc] init];
    }
    return _bookArray;
}
- (NSMutableArray *)recordArray {
    if (!_recordArray) {
        _recordArray = [[NSMutableArray alloc] init];
    }
    return _recordArray;
}
- (BookSQLManager *)sqlManager {
    if (!_sqlManager) {
        _sqlManager = [BookSQLManager shareDatabase];
    }
    return _sqlManager;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = @"";
    
    self.searched = false;
    self.pageIndex = 1;
    
    //创建导航搜索
    [self createSearchTextfield];
    
    [self showView];
    
    //查数据库里面的历史搜索的记录
    self.recordArray = [self.sqlManager querySearchHistoryBookName];
    if (self.recordArray.count * 44 > 400) {
        [self.recordTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(400);
        }];
        
    } else {
        [self.recordTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.recordArray.count * 44);
        }];
    }
    
    
}
//操作数据库
- (void)operateSqlL
{
    if ([self.sqlManager isExistBookName:_searchBar.text]) {
        if ([self.sqlManager deleteSearchName:_searchBar.text]) {
            [self.sqlManager insertSearchKey:_searchBar.text];
        }
    } else {
        
        [self.sqlManager insertSearchKey:_searchBar.text];
    }
}
#pragma mark --默认显示的是l历史记录还是搜索到的列表
- (void)showView {
    self.recordView = [[UIView alloc] init];
    self.recordView.backgroundColor = [UIColor whiteColor];
    self.recordView.hidden = NO;
    [self.view addSubview:self.recordView];
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(UI_FRAME_ZERO);
        make.bottom.mas_equalTo(self.view);
    }];
    
    self.bookView = [[UIView alloc] init];
    self.bookView.backgroundColor = [UIColor whiteColor];
    self.bookView.hidden = YES;
    [self.view addSubview:self.bookView];
    [self.bookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(UI_FRAME_ZERO);
        make.bottom.mas_equalTo(self.view);
    }];
    
    [self searchRecord];
}
#pragma mark -- 搜索记录
- (void)searchRecord {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"搜索历史";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.recordView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.recordView).offset(12);
        make.trailing.mas_equalTo(self.recordView).offset(-12);
        make.top.mas_equalTo(self.recordView);
        make.height.mas_equalTo(40);
    }];
    
    self.recordTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.recordTable.dataSource = self;
    self.recordTable.delegate = self;
    self.recordTable.hidden = NO;
    [self.recordView addSubview:self.recordTable];
    [self.recordTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.recordView);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.height.mas_equalTo(300);
    }];
    //此处写入让其不显示下划线的代码
    self.recordTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeBtn setTitle:@"清空所有" forState:UIControlStateNormal];
    [removeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    removeBtn.layer.cornerRadius = 5.0f;
    removeBtn.layer.borderWidth = 1.0f;
    removeBtn.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
    [removeBtn addTarget:self action:@selector(clearSearchRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordView addSubview:removeBtn];
    [removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.recordView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 44));
        make.top.mas_equalTo(self.recordTable.mas_bottom).offset(12);
    }];
    
    
    
    //默认搜索到的书籍列表隐藏的
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    self.topView.hidden = YES;
    [self.bookView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bookView);
        make.leading.trailing.mas_equalTo(self.bookView);
        make.height.mas_equalTo(88);
    }];
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.font = [UIFont systemFontOfSize:14];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.topView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView);
        make.left.trailing.mas_equalTo(self.topView);
        make.height.mas_equalTo(44);
    }];
    
    UILabel *proposalLabel = [[UILabel alloc] init];
    proposalLabel.backgroundColor = [UIColor whiteColor];
    proposalLabel.text = @"  小编推荐";
    proposalLabel.font = [UIFont systemFontOfSize:14];
    proposalLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.topView addSubview:proposalLabel];
    [proposalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel.mas_bottom);
        make.leading.mas_equalTo(self.bookView);
        make.trailing.mas_equalTo(self.bookView);
        make.height.mas_equalTo(44);
    }];
    
    
    self.bookTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.bookTable.delegate = self;
    self.bookTable.dataSource = self;
    [self.bookView addSubview:self.bookTable];
    [self.bookTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).offset(0);
        make.bottom.mas_equalTo(self.bookView);
        make.leading.trailing.mas_equalTo(0);
    }];
    //此处写入让其不显示下划线的代码
    self.bookTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    
    //集成上拉刷新控件
    [self setupUpRefresh];
    
}
/**
 *  集成上拉刷新控件
 */
- (void)setupUpRefresh
{
    self.bookTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreBills)];
}
/**
 *  加载上拉加载数据
 */
-(void)loadMoreBills
{
    if (self.topView.hidden) {
        //1.设置页数
        _pageIndex++;//默认加载第一页
        [self queryBookList:_searchBar.text];
    } else {
        _recIndex++;
        [self searchRecommendBook];
    }
}
#pragma mark -- delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.bookTable) {
        return _bookArray.count;
    } else {
        return _recordArray.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.bookTable) {
        return 120;
    } else {
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.bookTable) {
        static NSString *CellIdentifier = @"CellId";
        BookCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[BookCaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        BookModel *model = self.bookArray[indexPath.row];
        
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
    } else {
        static NSString *cellId = @"CELLID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.recordArray[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.bookTable) {
        
        BookModel *model = self.bookArray[indexPath.section];
        
        BookDetailController *vc = [[BookDetailController alloc] init];
        vc.bookModel = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        [self queryBookList:self.recordArray[indexPath.row]];
        
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.recordTable) {
        return YES;
    } else {
        return NO;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView == self.recordTable) {
        if (editingStyle ==UITableViewCellEditingStyleDelete) {
            [_sqlManager deleteSearchName:self.recordArray[indexPath.row]];
            [self.recordArray removeObjectAtIndex:indexPath.row];//删除数据源当前行数据
            
            [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
#pragma mark -- 清空所有
- (void)clearSearchRecord:(UIButton *)sender {
    [_searchBar resignFirstResponder];
    [self.recordArray removeAllObjects];
    [self.recordTable reloadData];
    //删除数据库
    [_sqlManager clearData];
    
    [self.recordTable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
}
#pragma mark -- 创建导航搜索
- (void)createSearchTextfield {
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 3, SCREEN_WIDTH-160, 38)];
    _searchBar.placeholder = @"请输入书名";
    _searchBar.tintColor = [UIColor colorWithHexString:@"#333333"];
    _searchBar.layer.borderWidth = 1.0f;
    _searchBar.layer.cornerRadius = 5.0f;
    _searchBar.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
    _searchBar.backgroundColor = [UIColor whiteColor];
    #pragma mark -- 给clearButton重新绑定触发方法
    // 获取输入框
    UITextField * searchField = [self.searchBar valueForKey:@"searchField"];
    // 获取清除按钮
    UIButton * clearBtn = [searchField valueForKey:@"_clearButton"];
    // 重新绑定触发方法
    [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
   

    UIView *searchView = [[UIView alloc] init];
    searchView.backgroundColor = [UIColor clearColor];
    _searchBar.clipsToBounds = YES;
    [searchView addSubview:_searchBar];
    self.navigationItem.titleView = searchView;
    self.navigationItem.titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH-160, 44);

    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 44, 44);
    [searchBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
}

#pragma mark - 键盘回收
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_searchBar resignFirstResponder];
}

#pragma mark -- 搜索
- (void)search:(UIButton *)sender {
    [_searchBar resignFirstResponder];
    if ([_searchBar.text isEqualToString:@""]) {
        self.searched = false;
        self.bookView.hidden = YES;
        self.recordView.hidden = NO;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入书名" preferredStyle:UIAlertControllerStyleAlert];
        //创建提示按钮
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        //添加提示按钮
        [alertController addAction:sure];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self operateSqlL];
        self.searched = true;
        self.bookView.hidden = NO;
        self.recordView.hidden = YES;
        [self.bookArray removeAllObjects];
        [self.bookTable reloadData];
        [self queryBookList:_searchBar.text];
    }
    
}
- (void)clearBtnClick {
    [_searchBar resignFirstResponder];
    self.searched = false;
    self.bookView.hidden = YES;
    self.recordView.hidden = NO;
    [self.recordArray removeAllObjects];
    [self.bookArray removeAllObjects];
    
    self.recordArray = [self.sqlManager querySearchHistoryBookName];
    if (self.recordArray.count * 44 > 400) {
        [self.recordTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(400);
        }];
        
    } else {
        [self.recordTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.recordArray.count * 44);
        }];
    }
    [self.recordTable reloadData];
    
}
#pragma mark -- 设置label上面文字
- (void)setLabelTitle:(NSString *)name {
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"抱歉，未找到%@相关书籍",name]];
    [aString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#21C9CB"]range:NSMakeRange(6, name.length)];
    self.tipLabel.attributedText = aString;
}
#pragma mark -- 搜索请求
- (void)queryBookList:(NSString *)searchkey {
    [BaseRequest searchBook:BookSearch withkey:searchkey withPage:self.pageIndex withResult:^(NSString * _Nonnull errCode, id _Nonnull result) {
        
        if ([errCode isEqualToString:@"0"]) {
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            if (self.pageIndex == 1) {
                if ([result[@"Data"] isKindOfClass:[NSDictionary class]]) {
                    self.recordView.hidden = YES;
                    self.bookView.hidden = NO;
                    self.topView.hidden = YES;
                    arr = result[@"Data"][@"list"];
                    
                    for (int i = 0; i < arr.count; i++) {
                        BookModel *model = [[BookModel alloc] mj_setKeyValues:arr[i]];
                        [self.bookArray addObject:model];
                    }
                    
                    [self.bookTable mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.bookView);
                    }];
                    // 刷新表格
                    [self.bookTable reloadData];
                    
                    // 拿到当前的下拉刷新控件，结束刷新状态
                    [self.bookTable.mj_footer endRefreshing];
                    
                } else {
                    self.recordView.hidden = YES;
                    self.bookView.hidden = NO;
                    self.topView.hidden = NO;
                    
                    [self setLabelTitle:searchkey];
                    
                    [self.bookTable mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.bookView.mas_top).offset(88);
                    }];
                    self.recIndex =  (int)arc4random_uniform(10) + 1;
                    [self searchRecommendBook];
                }
            } else {
            
                if ([result[@"Data"] isKindOfClass:[NSDictionary class]]) {
                    arr = result[@"Data"][@"list"];
                    
                    for (int i = 0; i < arr.count; i++) {
                        BookModel *model = [[BookModel alloc] mj_setKeyValues:arr[i]];
                        [self.bookArray addObject:model];
                    }
                    
                    // 刷新表格
                    [self.bookTable reloadData];
                    
                    // 拿到当前的下拉刷新控件，结束刷新状态
                    [self.bookTable.mj_footer endRefreshing];
                    
                } else {
                    self.pageIndex --;
                    // 拿到当前的下拉刷新控件，结束刷新状态
                    [self.bookTable.mj_footer endRefreshing];
                }
            }
        } else {
            NSLog(@"失败");
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.bookTable.mj_footer endRefreshing];
        }
    }];
}

- (void)searchRecommendBook {
    [BaseRequest searchRecommendBook:@"book/booklist/" withPage:self.recIndex withResult:^(NSString * _Nonnull errCode, id _Nonnull result) {
        if ([errCode isEqualToString:@"0"]) {
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            if ([result[@"Data"] isKindOfClass:[NSDictionary class]]) {
                arr = result[@"Data"][@"list"];
                
                for (int i = 0; i < arr.count; i++) {
                    BookModel *model = [[BookModel alloc] mj_setKeyValues:arr[i]];
                    [self.bookArray addObject:model];
                }
                
                // 刷新表格
                [self.bookTable reloadData];
                
                // 拿到当前的下拉刷新控件，结束刷新状态
                [self.bookTable.mj_footer endRefreshing];
                
            } else {
                self.recIndex --;
                // 拿到当前的下拉刷新控件，结束刷新状态
                [self.bookTable.mj_footer endRefreshing];
            }
        } else {
            NSLog(@"失败");
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.bookTable.mj_footer endRefreshing];
        }
    }];
}
@end
