//
//  BookshelfController.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/19.
//  Copyright © 2019 GS. All rights reserved.
//

#import "BookshelfController.h"
#import "BaseRequest.h"
#import "BookCaseCell.h"
#import "BookModel.h"
#import "GSTools.h"
#import "SearchBookController.h"
#import "SystemSettingController.h"
#import "BookDetailController.h"
#import "BookSQLManager.h"

@interface BookshelfController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *table;

@property (nonatomic ,strong) NSMutableArray *dataArray;

@end

@implementation BookshelfController
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    //直接获取数据库中的book
    self.dataArray = [[BookSQLManager shareDatabase] getAllBookInCase];
    if (self.dataArray.count == 0) {
        
        //随机获取book
         [self TestRequest];
    }
    [self.table reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航左右按钮
    [self setNavBarButtonItem];
    
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


#pragma mark -- 点击左右按钮
- (void)searchBook:(UIButton *)sender {
   
    SearchBookController *vc = [[SearchBookController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setSystem:(UIButton *)sender {
    SystemSettingController *vc = [[SystemSettingController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 设置导航左右按钮
- (void)setNavBarButtonItem {
    //修改导航栏
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 44, 44);
    [searchBtn addTarget:self action:@selector(searchBook:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setImage:[UIImage imageNamed:@"sousuo.png"]forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    
//    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    setBtn.frame = CGRectMake(0, 0, 44, 44);
//    [setBtn addTarget:self action:@selector(setSystem:) forControlEvents:UIControlEventTouchUpInside];
//    [setBtn setImage:[UIImage imageNamed:@"shezhi.png"] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:setBtn];
    
    //修改push过去的页面返回处不带文字
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"";
    self.navigationItem.backBarButtonItem = backBtn;
}







- (void)TestRequest {

    [BaseRequest getBookCase:BookCase withResult:^(NSString * _Nonnull errCode, id _Nonnull result) {
        
        if ([errCode isEqualToString:@"0"]) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            arr = result[@"Data"][@"list"];
            
            for (int i = 0; i < arr.count; i++) {
                BookModel *model = [[BookModel alloc] mj_setKeyValues:arr[i]];
                [self.dataArray addObject:model];
            }
            [self.table reloadData];
        } else {
            NSLog(@"失败");
        }
        
    }];
}

@end
