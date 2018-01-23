//
//  XMGGroupHeaderView.h
//  码哥课堂
//
//  Created by yz on 2016/11/17.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGInterestGroupItem;
@interface XMGGroupHeaderView : UIView
@property (nonatomic, strong) XMGInterestGroupItem *group;
+ (instancetype)groupHeaderView;
@end
