//
//  XMGInterestRowItem.m
//  码哥课堂
//
//  Created by yz on 2016/11/17.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "XMGInterestRowItem.h"
#import "MJExtension.h"
@implementation XMGInterestRowItem
MJExtensionCodingImplementation
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"XMGInterestItem"};
}

- (void)setData:(NSArray *)data
{
    _data = data;
    
    CGFloat originY = 27;
    CGFloat margin = 10;
    CGFloat itemH = 30;
    NSInteger cols = 4;
    NSInteger rows = (self.data.count - 1) / cols + 1;
    
    _cellH = rows * (itemH + margin) + originY;
    
}
@end
