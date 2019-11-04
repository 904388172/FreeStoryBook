//
//  MakeMoneyController.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/19.
//  Copyright © 2019 GS. All rights reserved.
//

#import "MakeMoneyController.h"
#import "BaseRequest.h"
#import "BookSQLManager.h"

@interface MakeMoneyController ()

@end

@implementation MakeMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    [BaseRequest getBook:@"gold/triggerRule2" withResult:^(NSString * _Nonnull errCode, id _Nonnull result) {
//
//        NSString *str = [self decodeString:result[@"Data"]];
//        NSString *str1 = [self encodeString:result[@"Data"]];
//
//
//        NSLog(@"sss");
//    }];
    
//    [[BookSQLManager shareDatabase] clearBookCase];
}


@end
