//
//  YLDFMyEorderDetialInfoTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/10.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDFEOrderModel.h"
@interface YLDFMyEorderDetialInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eOrderNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageV;
@property (weak, nonatomic) IBOutlet UILabel *personLab;
@property (weak, nonatomic) IBOutlet UILabel *baojiaTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLab;
@property (weak, nonatomic) IBOutlet UILabel *shuomingLab;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageV;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (nonatomic,strong)YLDFEOrderModel *model;
+(YLDFMyEorderDetialInfoTableViewCell *)yldFMyEorderDetialInfoTableViewCell;
@end
