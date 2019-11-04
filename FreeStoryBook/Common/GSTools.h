//
//  GSTools.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/21.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSTools : NSObject

/**
 *  将数据转换成万字单位
 *
 */
+ (NSString *)exchangeNumberToString:(NSString *)figures;

///**
// *  通过url获取图片
// */
//+(UIImage *) getImageFromURL:(NSString *)fileURL;
@end

NS_ASSUME_NONNULL_END
