//
//  CategoryFrame.m
//  FreeStoryBook
//
//  Created by 耿双 on 2019/3/21.
//  Copyright © 2019 GS. All rights reserved.
//

#import "CategoryFrame.h"

@implementation CategoryFrame

- (void)setShowFamilyData:(NSArray <CategoryModel *>*)showFamilyData {
    _showFamilyData = showFamilyData;
    
    float newHeight = 0;
    if (_showFamilyData.count != 0) {
        NSInteger num = (_showFamilyData.count +1 ) / 2;
        newHeight = (120 + 10) * num + 10;
    }
    
    _listViewF = CGRectMake(0, 0, SCREEN_WIDTH, newHeight);
    
    // cell的高度
    _cellHeight = newHeight + 10;
}
@end
