//
//  GSNetwork.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/20.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SeletorShowType) {
    kShowLoadInScreen,//显示网络数据加载
    kNoShowLoadInScreen,//未加载
};

NS_ASSUME_NONNULL_BEGIN

@interface GSNetwork : NSObject

/**
 *  url         :请求的url
 *  type        : 请求类型（GET，POST）
 *  prameters   : 请求的参数
 *  showType    :
 */

+(void)request:(NSString *)url
      withType:(NSString *)type
withParameters:(id)prameters
       andLoad:(SeletorShowType )showType
    completion:( void (^)(NSString *errCode,id))result;

@end

NS_ASSUME_NONNULL_END
