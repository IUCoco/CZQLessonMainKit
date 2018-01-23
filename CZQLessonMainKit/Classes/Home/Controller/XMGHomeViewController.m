//
//  XMGHomeViewController.m
//  码哥课堂
//
//  Created by yz on 2016/12/9.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "XMGHomeViewController.h"
#import "XMGNetworkManager.h"
#import "XMGHttpManager.h"
#import "XMGHomeADItem.h"
#import "XMGHomeRecommendItem.h"
#import "XMGHomeTopTeacherItem.h"
#import <MJExtension/MJExtension.h>
#import "XMGHomeHeaderView.h"
#import "UIView+XMGFrame.h"
#import "XMGHomeRecommendCell.h"
#import "SVProgressHUD.h"
#import "XMGInterestViewController.h"

static NSString * const ID = @"homeR";

@interface XMGHomeViewController ()
@property (nonatomic, strong) NSArray *recommends;
@property (nonatomic, strong) NSArray *topTeachers;
@property (nonatomic, strong) NSArray *ads;
@property (nonatomic, weak) XMGHomeHeaderView *headerView;
@end

@implementation XMGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    // 显示提示框
//    [SVProgressHUD showWithStatus:@"正在加载ing...."];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
//    [SVProgressHUD setBackgroundLayerColor:[UIColor whiteColor]];

    // 设置头部视图
    [self loadData];
    
    // 设置头部视图
    [self setupHeaderView];
    
    // 注册Cell
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    NSString *bundleName = bundle.infoDictionary[@"CFBundleName"];
    
    NSString *nibName = [NSString stringWithFormat:@"%@.bundle/%@",bundleName,@"XMGHomeRecommendCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:nibName bundle:bundle] forCellReuseIdentifier:ID];
    
    self.navigationItem.title = @"首页";
    
    self.tableView.tableFooterView = [UIView new];
    
}

// 添加到头部视图
- (void)setupHeaderView
{
    XMGHomeHeaderView *header = [XMGHomeHeaderView viewFromXib];
    header.frame = CGRectMake(0, 0, 0, 430);
    self.tableView.tableHeaderView = header;
    _headerView = header;
    _headerView.hidden = YES;
    
    // 监听
    // 点击兴趣
    header.clickInterestingBlock = ^{
        XMGInterestViewController *controller = [[XMGInterestViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    };
    
}


- (void)loadData
{
    // 获取参数
    NSString *url = [XMGNetworkManager urlWithHome];
    
    NSDictionary *param = [XMGNetworkManager paramWithHome];
    
    [XMGHttpManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask *task, NSDictionary * responseObject) {
        
        [SVProgressHUD dismiss];
        _headerView.hidden = NO;
        NSDictionary *result = responseObject[@"result"];
        
        // 获取广告数据
        _ads = [XMGHomeADItem mj_objectArrayWithKeyValuesArray:result[@"ad"]];
        
        // 获取推荐课程（栅栏广告）
        NSDictionary *recommendsDict = result[@"recommends"];
        _recommends =  [XMGHomeRecommendItem mj_objectArrayWithKeyValuesArray: recommendsDict[@"courses"]];
        
        // 获取热门老师
        NSDictionary *topTeacherDict = result[@"topTeacher"];
        _topTeachers = [XMGHomeTopTeacherItem mj_objectArrayWithKeyValuesArray:topTeacherDict[@"courses"]];
        
        // 设置广告数据
        _headerView.ads = _ads;
        
        // 设置热门老师数据
        _headerView.topTeachers = _topTeachers;
        
        // 刷新tableView
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError * error) {
        
        NSLog(@"%@",error);
        
    }];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recommends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMGHomeRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.recommend = _recommends[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_recommends.count == 0) {
        return nil;
    }
    
    return @"为您推荐";
}

@end
