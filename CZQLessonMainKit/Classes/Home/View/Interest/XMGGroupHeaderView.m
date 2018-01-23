//
//  XMGGroupHeaderView.m
//  码哥课堂
//
//  Created by yz on 2016/11/17.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "XMGGroupHeaderView.h"
#import "XMGInterestGroupItem.h"
@interface XMGGroupHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *nameView;

@end

@implementation XMGGroupHeaderView

- (void)setGroup:(XMGInterestGroupItem *)group
{
    _group = group;
    
    _nameView.text = group.name;
}

+ (instancetype)groupHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end
