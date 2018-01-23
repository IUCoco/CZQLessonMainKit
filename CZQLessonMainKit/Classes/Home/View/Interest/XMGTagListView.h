//
//  XMGTagListView.h
//  码哥课堂
//
//  Created by yz on 2016/12/14.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGTagListView : UIView


- (void)addTag:(NSString *)tag;

- (void)deleteTag:(NSString *)tag;

@property (nonatomic, strong) NSMutableArray *tags;

@property (nonatomic, strong) void (^clickTag)(NSString *tag);

@property (nonatomic, assign) CGFloat cellH;

@end
