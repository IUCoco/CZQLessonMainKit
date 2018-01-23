//
//  XMGInterestCell.m
//  码哥课堂
//
//  Created by yz on 2016/11/17.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "XMGInterestCell.h"
#import "XMGInterestItem.h"
#import "XMGInterestManager.h"
@interface XMGInterestCell ()

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end

@implementation XMGInterestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1].CGColor;
    self.layer.borderWidth = 1;
}

- (void)setItem:(XMGInterestItem *)item
{
    _item = item;
    
    _tagLabel.text = item.name;
    
    
    
   
    
    
    _tagLabel.textColor =  item.isSelect?[UIColor colorWithRed:39 / 255.0 green:132 / 255.0 blue:235 / 255.0 alpha:1] : [UIColor colorWithRed:136 / 255.0 green:136 / 255.0 blue:136 / 255.0 alpha:1];
    
   
    
    
}

@end
