//
//  GSTools.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/21.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSTools.h"

@implementation GSTools

#pragma mark -- 处理数字转成万字
+ (NSString *)exchangeNumberToString:(NSString *)figures {
    
    int word = [figures intValue] /10000;
    
    NSString *numStr = [NSString stringWithFormat:@"%d%@",word,@"万字"];
    return numStr;
}

//#pragma mark -- 通过url获取图片
//+(UIImage *) getImageFromURL:(NSString *)fileURL {
//    NSString *newUrl = [NSString stringWithFormat:@"%@%@",ImgUrl,fileURL];
//    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:newUrl]];
//    UIImage * result = [UIImage imageWithData:data];
//    return result;
//}

@end
