//
//  YLDSNewsListNoPicCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/25.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDZXLmodel.h"
@interface YLDSNewsListNoPicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *readNumLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic,strong) YLDZXLmodel *model;
+(YLDSNewsListNoPicCell *)yldSNewsListNoPicCell;
@end
