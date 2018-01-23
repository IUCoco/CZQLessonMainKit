//
//  XMGInterestRowCell.m
//  码哥课堂
//
//  Created by yz on 2016/11/17.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "XMGInterestRowCell.h"
#import "XMGInterestRowItem.h"
#import "XMGInterestCell.h"
#import "XMGInterestItem.h"
#import "XMGInterestManager.h"
CGFloat const itemH = 30;
static NSString * const tagCell = @"tagCell";
@interface XMGInterestRowCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameView;

@end

@implementation XMGInterestRowCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat margin = 10;
    CGFloat cols = 4;
    CGFloat itemW = ([UIScreen mainScreen].bounds.size.width - (cols + 1) * margin) / cols;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    
    // 设置collectionView
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XMGInterestCell" bundle:nil] forCellWithReuseIdentifier:tagCell];
    
}
- (void)setRowItem:(XMGInterestRowItem *)rowItem
{
    _rowItem = rowItem;
    
    _nameView.text = rowItem.name;
    
    [_collectionView reloadData];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _rowItem.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMGInterestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tagCell forIndexPath:indexPath];
    
    XMGInterestItem *item = _rowItem.data[indexPath.row];
    [XMGInterestManager cellDict][item.name] = cell;
    
    // 获取之前保存的兴趣
    NSArray *tags = [XMGInterestManager interestes];
    
    for (NSString *tag in tags) {
        if ([tag isEqualToString:item.name]) {
            item.isSelect = YES;
        }
    }
    
    cell.item = item;
    
    
    return cell;
}


@end
