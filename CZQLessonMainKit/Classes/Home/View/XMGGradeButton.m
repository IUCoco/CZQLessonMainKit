//
//  XMGGradeButton.m
//  码哥课堂
//
//  Created by yz on 2016/11/15.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "XMGGradeButton.h"
#import "UIView+XMGFrame.h"
@implementation XMGGradeButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
    self.titleLabel.y = self.height - self.titleLabel.height;
    self.titleLabel.centerX = self.width * 0.5;
}

@end
