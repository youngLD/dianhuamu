//
//  YLDFEorderQuoteTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/10.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDFQuoteModel.h"
@interface YLDFEorderQuoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *personLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *shuomingLab;
@property (strong,nonatomic)YLDFQuoteModel *model;
+(YLDFEorderQuoteTableViewCell *)yldFEorderQuoteTableViewCell;
@end
