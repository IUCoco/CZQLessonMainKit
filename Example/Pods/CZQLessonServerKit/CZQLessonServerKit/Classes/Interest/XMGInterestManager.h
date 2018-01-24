//
//  XMGInterestManager.h
//  码哥课堂
//
//  Created by yz on 2016/12/16.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGInterestManager : NSObject

//+ (void)storageInterestGroup:(NSArray *)group;

//+ (NSMutableArray *)interestGroup;
//
+ (void)storageAllInterest:(NSArray *)interests;

+ (NSArray *)interestes;

+ (NSMutableDictionary *)cellDict;

@end
