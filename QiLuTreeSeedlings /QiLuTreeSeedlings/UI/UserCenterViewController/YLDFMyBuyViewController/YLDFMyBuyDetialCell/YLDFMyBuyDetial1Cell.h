//
//  YLDFMyBuyDetial1Cell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/3.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDFBuyModel.h"
@interface YLDFMyBuyDetial1Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shuzhongNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *viewsLab;
@property (weak, nonatomic) IBOutlet UILabel *personLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *piceTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *demaLab;
@property (nonatomic,strong) YLDFBuyModel *model;
+(YLDFMyBuyDetial1Cell *)yldFMyBuyDetial1Cell;
@end
