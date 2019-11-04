//
//  SystemSettingController.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/22.
//  Copyright © 2019 GS. All rights reserved.
//

#import "SystemSettingController.h"
#import "UIColor+GSColor.h"

@interface SystemSettingController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;

@end

@implementation SystemSettingController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.scrollEnabled = NO;
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(UI_FRAME_ZERO);
        make.height.mas_equalTo (96);
    }];
    //此处写入让其不显示下划线的代码
    self.table.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    //切换账号
    [self creatExchangeAccount];
}
#pragma mark -- 切换账号
- (void)creatExchangeAccount {
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.backgroundColor = [UIColor colorWithHexString:@"#21C9CB"];
    [changeBtn setTitle:@"切换账号" forState:UIControlStateNormal];
    changeBtn.layer.cornerRadius = 5.0;
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [changeBtn addTarget:self action:@selector(changeAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.table.mas_bottom).offset(40);
        make.left.mas_equalTo(self.view).offset(24);
        make.right.mas_equalTo(self.view).offset(-24);
        make.height.mas_equalTo(48);
    }];
}
- (void)changeAccount:(UIButton *)sender {
    NSLog(@"切换账号");
}
#pragma mark -- delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-   (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"修改密码";
    } else {
        cell.textLabel.text = @"关于小说";
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSLog(@"修改密码");
    } else {
        NSLog(@"关于。。。");
    }
}

@end
