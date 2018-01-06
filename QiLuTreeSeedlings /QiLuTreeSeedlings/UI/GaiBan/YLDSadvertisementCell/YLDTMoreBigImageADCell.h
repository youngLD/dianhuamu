//
//  YLDTMoreBigImageADCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/9/1.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDSadvertisementModel.h"
@interface YLDTMoreBigImageADCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bigIamgeV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *tuiguangLab;
@property (nonatomic,strong)YLDSadvertisementModel *model;
+(YLDTMoreBigImageADCell *)yldTMoreBigImageADCell;
@end
