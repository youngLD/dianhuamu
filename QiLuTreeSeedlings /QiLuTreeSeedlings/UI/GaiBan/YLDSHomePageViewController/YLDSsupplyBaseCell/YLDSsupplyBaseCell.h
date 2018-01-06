//
//  YLDSsupplyBaseCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/7.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotSellModel.h"
#import "ZIKSupplyModel.h"
@interface YLDSsupplyBaseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imagV1;
@property (weak, nonatomic) IBOutlet UIImageView *iamgV2;
@property (weak, nonatomic) IBOutlet UIImageView *imagV3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iamgV2W;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shenfenW;
@property (weak, nonatomic) IBOutlet UIImageView *shenfenV;
@property (nonatomic,strong) HotSellModel *model;
+(YLDSsupplyBaseCell *)yldSsupplyBaseCell;
@end
