//
//  XMGInterestViewController.m
//  码哥课堂
//
//  Created by yz on 2016/12/13.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "XMGInterestViewController.h"
#import "XMGHttpManager.h"
#import "XMGNetworkManager.h"
#import "XMGInterestGroupItem.h"
#import <MJExtension/MJExtension.h>
#import "XMGInterestRowCell.h"
#import "XMGInterestRowItem.h"
#import "XMGGroupHeaderView.h"
#import "XMGInterestCell.h"
#import "XMGInterestItem.h"
#import "XMGTagListView.h"
#import "XMGInterestManager.h"

#define XMGScreenW [UIScreen mainScreen].bounds.size.width
#define XMGScreenH [UIScreen mainScreen].bounds.size.height

static NSString * const ID = @"interest";
static NSString * const SelID = @"Selinterest";
@interface XMGInterestViewController ()<UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) XMGTagListView *tagListView;
@end

@implementation XMGInterestViewController

- (XMGTagListView *)tagListView
{
    
    if (_tagListView == nil) {
        _tagListView = [[XMGTagListView alloc] initWithFrame:CGRectMake(0, 0,XMGScreenW , 0)];
        
        __weak typeof(self) weakSelf = self;
        
        _tagListView.clickTag = ^(NSString *tag){
            [weakSelf clickTag:tag];
        };
        
        NSArray *tags = [XMGInterestManager interestes];
        
        _tagListView.tags = tags;
        
    }
    return _tagListView;
}

- (NSMutableArray *)groups
{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
        
        // 添加已选兴趣组
        XMGInterestGroupItem *group0 = [[XMGInterestGroupItem alloc] init];
        group0.name = @"以选兴趣:";
        [_groups insertObject:group0 atIndex:0];
        
    }
    return _groups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 请求数据
    [self loadInterestData];
    
    NSBundle *bundle = [NSBundle bundleForClass:self];
    
    NSString *bundleName = bundle.infoDictionary[@"CFBundleName"];
    
    NSString *nibName = [NSString stringWithFormat:@"%@.bundle/%@",bundleName,@"XMGInterestRowCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:nibName bundle:bundle] forCellReuseIdentifier:ID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SelID];
    
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)clickTag:(NSString *)tag
{
    [self.tagListView deleteTag:tag];
    
    // 获取兴趣模型
    XMGInterestCell *cell = [XMGInterestManager cellDict][tag];
    
    // 取消兴趣选中
    XMGInterestItem *item = cell.item;
    item.isSelect = NO;
    cell.item = item;
    
    // 刷新第0组
    NSIndexSet *indexSex = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:indexSex withRowAnimation:UITableViewRowAnimationNone];
    
    // 保存所有已选兴趣
    [XMGInterestManager storageAllInterest:_tagListView.tags];
    
}

- (void)loadInterestData
{
    NSString *url = [XMGNetworkManager urlWithInteresting];
    
    NSDictionary *param = [XMGNetworkManager paramWithInteresting];
    
    [XMGHttpManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
      
        [self.groups addObjectsFromArray:[XMGInterestGroupItem mj_objectArrayWithKeyValuesArray:responseObject[@"result"]]];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    XMGInterestGroupItem *group = _groups[section];
    return group.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        // 已选兴趣组
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelID];
        // 添加标签列表，只需要创建一个标签列表，懒加载
        [cell addSubview:self.tagListView];
        
        return cell;
    }
        
    XMGInterestRowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.collectionView.delegate = self;
    XMGInterestGroupItem *group = _groups[indexPath.section];
    XMGInterestRowItem *rowItem = group.data[indexPath.row];
    
    cell.rowItem = rowItem;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _tagListView.cellH;
    }
    
    XMGInterestGroupItem *group = _groups[indexPath.section];
    XMGInterestRowItem *rowItem = group.data[indexPath.row];
    return rowItem.cellH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    XMGGroupHeaderView *headerView = [XMGGroupHeaderView groupHeaderView];
    
    XMGInterestGroupItem *group = _groups[section];
    headerView.group = group;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取对应的cell
    XMGInterestCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    // 获取模型
    XMGInterestItem *item = cell.item;
    item.isSelect = !item.isSelect;
    cell.item = item;

    if (item.isSelect) {
        // 添加标签
        [self.tagListView addTag:item.name];
        
    } else {
        // 删除标签
        [self.tagListView deleteTag:item.name];
    }
    
    // 更新高度，刷新第0组
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
    // 保存所有已选兴趣
    
    [XMGInterestManager storageAllInterest:_tagListView.tags];
}


@end
