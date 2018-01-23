//
//  XMGInterestItem.h
//  码哥课堂
//
//  Created by yz on 2016/11/17.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGInterestItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;

@end
