//
//  BaseTabbarController.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/19.
//  Copyright © 2019 GS. All rights reserved.
//

#import "BaseTabbarController.h"
#import "UIImage+GSImage.h"
#import "UIColor+GSColor.h"
#import "GSTabbar.h"

//五个页面
#import "BookshelfController.h"
#import "HotBookController.h"
#import "BookRoomController.h"
#import "MakeMoneyController.h"
#import "MineController.h"



@interface BaseTabbarController () <UITabBarControllerDelegate>

@end

@implementation BaseTabbarController

#pragma mark -- 系统方法
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    //设置底部菜单背景颜色
    //self.tabBar.backgroundImage = [UIImage imageNamed:@"tabBar_bg"];
    
    // 设置子控制器
    [self addChildViewControllers];
    
    [self setupNavigationView];
    
}

- (void)setupNavigationView {
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    // self.navigationController.navigationBar.translucent = NO;
    itemBack.title = @"";
    self.navigationItem.backBarButtonItem = itemBack;
}

#pragma mark - 添加多个子控制器
- (void)addChildViewControllers {
    
    // 书架
    BookshelfController *homeVC = [[BookshelfController alloc]init];
    [self addOneChildViewController:homeVC title:@"书架" normalImage:[UIImage originalImageNamed:@"icon_home_"] pressedImage:[UIImage originalImageNamed:@"icon_home_sign"] navigationBarTitle:@"书架"];
    
    // 精选
    HotBookController *categoryVC = [[HotBookController alloc] init];
    [self addOneChildViewController:categoryVC title:@"精选" normalImage:[UIImage originalImageNamed:@"icon_classification_"] pressedImage:[UIImage originalImageNamed:@"icon_classification_sign"] navigationBarTitle:@"分类"];
    
    // 书库
    BookRoomController *projectVC = [[BookRoomController alloc] init];
    [self addOneChildViewController:projectVC title:@"书库" normalImage:[UIImage originalImageNamed:@"icon_special"] pressedImage:[UIImage originalImageNamed:@"icon_special_sign"] navigationBarTitle:@""];
    
    // 赚钱
    MakeMoneyController *cartVC = [[MakeMoneyController alloc] init];
    [self addOneChildViewController:cartVC title:@"签到" normalImage:[UIImage originalImageNamed:@"icon_cart"] pressedImage:[UIImage originalImageNamed:@"icon_car_sign"] navigationBarTitle:@""];

    // 我的
    MineController *MyVC = [[MineController alloc] init];
    [self addOneChildViewController:MyVC title:@"我的" normalImage:[UIImage originalImageNamed:@"icon_presonal"] pressedImage:[UIImage originalImageNamed:@"icon_presonal_sign"] navigationBarTitle:@"我的"];
}


#pragma mark - 添加1个子控制器
- (void)addOneChildViewController:(UIViewController *)viewController
                            title:(NSString *)menutitle
                      normalImage:(UIImage *)normalImage
                     pressedImage:(UIImage *)pressedImage
               navigationBarTitle:(NSString *)title{
    
    // 设置子控制器导航条标题
    viewController.navigationItem.title = title;
    
    
    viewController.tabBarItem.title = menutitle;
    // 设置标签图片
    viewController.tabBarItem.image = normalImage;
    viewController.tabBarItem.selectedImage = pressedImage;
    
    //设置默认文字样式颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#00b0f0"];
    [viewController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    //设置默认文字大小
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    [viewController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [viewController.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    //设置选中文字大小
    selectedTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [viewController.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 添加子控制器至导航控制器
    UINavigationController *navigationVC
    = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    // 添加导航控制器
    [self addChildViewController:navigationVC];
    
    // 添加tabBarItem至数组
    //    [self.tabBarItems addObject:viewController.tabBarItem];
    
//    GSTabbar *tabBar = [[GSTabbar alloc] init];
//    tabBar.delegate = self;
//    [self setValue:tabBar forKey:@"tabBar"];
}


@end
