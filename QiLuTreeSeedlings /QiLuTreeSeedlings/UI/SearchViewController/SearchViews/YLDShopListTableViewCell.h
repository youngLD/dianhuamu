//
//  YLDShopListTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/10/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDShopListModel.h"
@interface YLDShopListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopNameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *presonLab;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (nonatomic,strong) YLDShopListModel *model;
+(YLDShopListTableViewCell *)yldShopListTableViewCell;
@end
