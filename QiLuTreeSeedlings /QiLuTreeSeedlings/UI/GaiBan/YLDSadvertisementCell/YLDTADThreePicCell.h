//
//  YLDTADThreePicCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/8/30.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDSadvertisementModel.h"
@interface YLDTADThreePicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageV1;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;
@property (weak, nonatomic) IBOutlet UIImageView *imageV3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IMG2W;
@property (weak, nonatomic) IBOutlet UILabel *tuiguangLab;
@property (nonatomic,strong)YLDSadvertisementModel *model;
+(YLDTADThreePicCell *)yldTADThreePicCell;
@end
