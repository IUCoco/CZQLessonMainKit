//
//  XMGInterestGroupItem.m
//  码哥课堂
//
//  Created by yz on 2016/11/17.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "XMGInterestGroupItem.h"
#import "MJExtension.h"
@implementation XMGInterestGroupItem
MJExtensionCodingImplementation
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"XMGInterestRowItem"};
}
@end
