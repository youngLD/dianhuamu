//
//  YLDTBuyListCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/8/8.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotBuyModel.h"
@interface YLDTBuyListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detialLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic,strong) HotBuyModel *model;
+(YLDTBuyListCell *)yldTBuyListCell;
@end
