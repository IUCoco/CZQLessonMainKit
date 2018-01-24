//
//  XMGInterestManager.m
//  码哥课堂
//
//  Created by yz on 2016/12/16.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "XMGInterestManager.h"
#define XMGInterestFilePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"interest.data"]

#define XMGInterestesFilePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"interestes.data"]

static NSMutableDictionary *_interestDicts = nil;
@implementation XMGInterestManager

+ (NSMutableDictionary *)cellDict
{
    if (_interestDicts == nil) {
        _interestDicts = [NSMutableDictionary dictionary];
    }
    
    return _interestDicts;
}

+ (void)storageInterestGroup:(NSArray *)group
{
    [NSKeyedArchiver archiveRootObject:group toFile:XMGInterestFilePath];
}

+ (NSMutableArray *)interestGroup
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:XMGInterestFilePath];
}

+ (void)storageAllInterest:(NSArray *)interests
{
    [NSKeyedArchiver archiveRootObject:interests toFile:XMGInterestesFilePath];
}

+ (NSArray *)interestes
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:XMGInterestesFilePath];
}

@end
