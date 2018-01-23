//
//  XMGTagListView.m
//  码哥课堂
//
//  Created by yz on 2016/12/14.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "XMGTagListView.h"
#import "UIView+XMGFrame.h"

@interface XMGTagListView ()
{
    NSMutableArray *_tags;
}
@property (nonatomic, strong) NSMutableDictionary *tagsDict;

@end

@implementation XMGTagListView

- (NSMutableArray *)tags
{
    if (_tags == nil) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

- (NSMutableDictionary *)tagsDict
{
    if (_tagsDict == nil) {
        _tagsDict = [NSMutableDictionary dictionary];
    }
    return _tagsDict;
}
- (void)setTags:(NSMutableArray *)tags
{
    for (NSString *tag in tags) {
        
        [self addTag:tag];
    }
}
- (void)deleteTag:(NSString *)tag
{
    // 根据标签，获取之前的标签View
    UIButton *btn = self.tagsDict[tag];
    
    // 移除View
    [btn removeFromSuperview];
    
     [self.tags removeObject:tag];
    
    // 更新高度
    UIButton *lastBtn = self.subviews.lastObject;
    
    _cellH = CGRectGetMaxY(lastBtn.frame) + 10;
    
    self.height = _cellH;
    
    // 移除字典
    [self.tagsDict removeObjectForKey:tag];
    
    // 设置其他标签的位置，删除标签会影响其他标签
    
    // 获取当前标签的位置
    NSInteger i = [self.subviews indexOfObject:btn];
    
    // 如果是最后一个标签不需要设置,但是也是需要移除标签
    if (i == self.tags.count - 1) {
        
        // 删除标签View

        
        return;
    }
    // 0 1 2
    
    // 从当前角标遍历标签View，更新frame
    [UIView animateWithDuration:0.25 animations:^{
        
        for (NSInteger index = i; index < self.tags.count; index++) {
            
            UIButton *btn = self.tags[index];
            
            [self setupBtnFrame:btn i:index];
        }
    }];

   
}

- (void)delete:(UIButton *)button
{
    
    if (_clickTag) {
        _clickTag(button.currentTitle);
    }
       
}

- (void)addTag:(NSString *)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor =  [UIColor colorWithRed:20 / 255.0 green:145 / 255.0 blue:255 / 255.0 alpha:1];
    btn.layer.cornerRadius = 7;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:tag forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupBtnFrame:btn i:self.tags.count];
    
    // 记录到字典
    self.tagsDict[tag] = btn;
    
    // 添加按钮
    [self addSubview:btn];
    
    [self.tags addObject:tag];
    
    // 更新tagList高度
    _cellH = CGRectGetMaxY(btn.frame) + 10;
    self.height = _cellH;
}

// 设置一个按钮位置
- (void)setupBtnFrame:(UIButton *)button i:(NSInteger)i
{
    CGFloat margin = 10;
    
    CGFloat btnX = margin;
    
    CGFloat btnY = margin;
    
    CGFloat btnW = button.width + 7;
    
    CGFloat btnH = 30;
    
    // 获取上一个按钮
    if (i == 0) {
         btnX =  margin;
        
    } else {
        
        UIButton *lastBtn = self.subviews[i - 1];
        
         btnX = CGRectGetMaxX(lastBtn.frame) + margin;
        // 判断是否需要换行显示，当前按钮最大的X值是否超过标签宽度
        // 最大x = 按钮x + 按钮宽度 + 间距
        CGFloat maxW = btnX + btnW + margin;
        
        if (maxW > self.width) {
            //换行
            btnX = margin;
            btnY = CGRectGetMaxY(lastBtn.frame) + margin;
        }
    }
    
    button.frame = CGRectMake(btnX, btnY, btnW, btnH);
}


@end
