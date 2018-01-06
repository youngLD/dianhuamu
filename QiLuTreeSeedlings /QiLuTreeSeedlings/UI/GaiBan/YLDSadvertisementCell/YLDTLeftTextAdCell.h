//
//  YLDTLeftTextAdCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/9/1.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDSadvertisementModel.h"
@interface YLDTLeftTextAdCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fgeH;
@property (weak, nonatomic) IBOutlet UIImageView *fgImageV;
@property (weak, nonatomic) IBOutlet UILabel *tuiguangLab;

@property (nonatomic,strong)YLDSadvertisementModel *model;
+(YLDTLeftTextAdCell *)yldTLeftTextAdCell;
@end
