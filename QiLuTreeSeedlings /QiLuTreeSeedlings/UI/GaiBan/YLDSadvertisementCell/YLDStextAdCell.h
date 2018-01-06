//
//  YLDStextAdCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/23.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDSadvertisementModel.h"
@interface YLDStextAdCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tuiguangLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fgeH;
@property (weak, nonatomic) IBOutlet UIImageView *fgImageV;
@property (nonatomic,strong)YLDSadvertisementModel *model;
+(YLDStextAdCell *)yldStextAdCell;
@end
