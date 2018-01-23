//
//  XMGHomeHeaderView.m
//  码哥课堂
//
//  Created by yz on 2016/11/15.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "XMGHomeHeaderView.h"
#import "SDCycleScrollView.h"
#import "XMGHomeADItem.h"
#import "XMGHomeTopTeacherItem.h"
#import "XMGHomeTeacherCell.h"
static NSString * const ID = @"teacherCell";
@interface XMGHomeHeaderView ()<UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UICollectionView *techersView;
@property (nonatomic, weak) SDCycleScrollView *cycleView;
@end

@implementation XMGHomeHeaderView

- (IBAction)clickInteresting:(id)sender {
    if (_clickInterestingBlock) {
        _clickInterestingBlock();
    }
}

- (IBAction)clickMore:(id)sender {
    if (_clickMoreBlock) {
        _clickMoreBlock();
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _topTeachers.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMGHomeTeacherCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.teacher = _topTeachers[indexPath.row];
    
    return cell;
}

- (SDCycleScrollView *)cycleView
{
    if (_cycleView == nil) {
        
        SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:_bannerView.bounds imageURLStringsGroup:nil];
        
        // 不显示分页控件
//        cycleView.showPageControl = NO;
//        cycleView.clickItemOperationBlock = ^(NSInteger currentIndex){
//            NSString *urlStr =  [_ads[currentIndex] url];
//            NSURL *url = [NSURL URLWithString:urlStr];
//            [[UIApplication sharedApplication] openURL:url];
//        };
        
        cycleView.placeholderImage = [UIImage imageNamed:@"homePlaceholder"];
        [_bannerView addSubview:cycleView];
        _cycleView = cycleView;
    }
    return _cycleView;
}

- (void)setTechersView:(UICollectionView *)techersView
{
    _techersView = techersView;
    
    techersView.showsHorizontalScrollIndicator = NO;
    
    UICollectionViewFlowLayout *layout = _techersView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    NSString *bundleName = bundle.infoDictionary[@"CFBundleName"];
    
    NSString *nibName = [NSString stringWithFormat:@"%@.bundle/%@",bundleName,@"XMGHomeTeacherCell"];
    
    [_techersView registerNib:[UINib nibWithNibName:nibName bundle:bundle] forCellWithReuseIdentifier:ID];
    
    _techersView.dataSource = self;
    
}
- (void)setAds:(NSArray *)ads
{
    _ads = ads;
    NSMutableArray *images = [NSMutableArray array];
    for (XMGHomeADItem *item in ads) {
        [images addObject:item.image];
    }
    
    self.cycleView.imageURLStringsGroup = images;

}

- (void)setTopTeachers:(NSArray *)topTeachers
{
    _topTeachers = topTeachers;
    
    [_techersView reloadData];
    
}

@end
