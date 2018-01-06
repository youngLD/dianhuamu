//
//  YLDSNewsListOnePicCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/25.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDZXLmodel.h"
@interface YLDSNewsListOnePicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *yueduLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic,strong) YLDZXLmodel *model;
+(YLDSNewsListOnePicCell *)yldSNewsListOnePicCell;
@end
