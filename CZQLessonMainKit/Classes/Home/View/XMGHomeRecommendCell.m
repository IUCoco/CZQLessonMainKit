//
//  XMGHomeRecommendCell.m
//  码哥课堂
//
//  Created by yz on 2016/11/16.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "XMGHomeRecommendCell.h"
#import "XMGHomeRecommendItem.h"
#import "UIImageView+WebCache.h"
@interface XMGHomeRecommendCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UIButton *numView;

@end

@implementation XMGHomeRecommendCell

- (void)setRecommend:(XMGHomeRecommendItem *)recommend
{
    _recommend = recommend;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:recommend.courseImage]];
    _nameView.text = recommend.courseName;
    [_numView setTitle:recommend.studentNum forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
