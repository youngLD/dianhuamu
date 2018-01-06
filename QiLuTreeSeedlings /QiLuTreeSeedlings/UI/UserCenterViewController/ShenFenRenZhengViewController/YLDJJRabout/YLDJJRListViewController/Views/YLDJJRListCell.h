//
//  YLDJJRListCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/8.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDJJrModel.h"
@interface YLDJJRListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *zhuyingLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *pinglunLab;
@property (weak, nonatomic) IBOutlet UILabel *yuanLab;
@property (nonatomic,strong)YLDJJrModel *model;
+(YLDJJRListCell *)yldJJRListCell;
@end
