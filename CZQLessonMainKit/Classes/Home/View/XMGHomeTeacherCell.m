//
//  XMGHomeTeacherCell.m
//  码哥课堂
//
//  Created by yz on 2016/11/16.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "XMGHomeTeacherCell.h"
#import "UIImageView+WebCache.h"
#import "XMGHomeTopTeacherItem.h"
@interface XMGHomeTeacherCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *numView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *subjectView;

@end

@implementation XMGHomeTeacherCell

- (void)setTeacher:(XMGHomeTopTeacherItem *)teacher
{
    _teacher = teacher;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:teacher.teacherImage]];
    _numView.text = [NSString stringWithFormat:@"%ld 学生",teacher.studentNum];
    
    _nameView.text = teacher.teacherName;
    _subjectView.text = teacher.subjects;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
