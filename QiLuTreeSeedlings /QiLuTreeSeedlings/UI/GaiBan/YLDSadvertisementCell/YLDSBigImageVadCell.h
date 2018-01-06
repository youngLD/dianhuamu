//
//  YLDSBigImageVadCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/23.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDSadvertisementModel.h"
@interface YLDSBigImageVadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tuiguangLab;
@property (weak, nonatomic) IBOutlet UIImageView *adImaegV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fegH;
@property (weak, nonatomic) IBOutlet UIImageView *fgv;
@property (nonatomic,strong)YLDSadvertisementModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
+(YLDSBigImageVadCell *)yldSBigImageVadCell;
@end
