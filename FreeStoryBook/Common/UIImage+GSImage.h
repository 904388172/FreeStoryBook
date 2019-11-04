//
//  UIImage+GSImage.h
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/19.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GSImage)

/**
 *  根据颜色生成一张图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (instancetype)originalImageNamed:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
