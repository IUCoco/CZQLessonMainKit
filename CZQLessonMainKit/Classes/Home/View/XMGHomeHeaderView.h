//
//  XMGHomeHeaderView.h
//  码哥课堂
//
//  Created by yz on 2016/11/15.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGHomeHeaderView : UIView
@property (nonatomic, strong) NSArray *ads;
@property (nonatomic, strong) NSArray *topTeachers;
@property (nonatomic, strong) void(^clickInterestingBlock)();
@property (nonatomic, strong) void(^clickMoreBlock)();
@end
