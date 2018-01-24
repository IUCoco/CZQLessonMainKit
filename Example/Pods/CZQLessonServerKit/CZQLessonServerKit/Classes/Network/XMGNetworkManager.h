//
//  XMGNetworkManager.h
//  码哥课堂
//
//  Created by yz on 2016/11/16.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGNetworkManager : NSObject

/**
    获取兴趣参数
 */
+ (NSDictionary *)paramWithInteresting;


/**
    获取课程参数
 */
+ (NSDictionary *)paramWithScheduleWithNextMonthIndex:(NSInteger)nextMonthIndex;


/**
    获取首页参数
 */
+ (NSDictionary *)paramWithHome;


/**
    获取首页URL
 */
+ (NSString *)urlWithHome;

/**
 获取兴趣URL
 */
+ (NSString *)urlWithInteresting;

/**
 获取课程URL
 */
+ (NSString *)urlWithSchedule;

@end
