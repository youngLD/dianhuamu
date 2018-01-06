//
//  YLDSNewsListThreePicCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/25.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDZXLmodel.h"
@interface YLDSNewsListThreePicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imag2W;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageV1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;
@property (weak, nonatomic) IBOutlet UIImageView *imageV3;
@property (weak, nonatomic) IBOutlet UILabel *readLab;
@property (nonatomic,strong)YLDZXLmodel *model;
+(YLDSNewsListThreePicCell *)yldSNewsListThreePicCell;
@end
