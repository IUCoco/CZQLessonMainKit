//
//  XMGInterestRowCell.h
//  码哥课堂
//
//  Created by yz on 2016/11/17.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGInterestRowItem;
@interface XMGInterestRowCell : UITableViewCell
@property (nonatomic, strong) XMGInterestRowItem *rowItem;
@property (weak, nonatomic, readonly) IBOutlet UICollectionView *collectionView;
@end
