//
//  YLDFMyBuyBaoJiaCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/3.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDFMyBuyBaoJiaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *pirceLab;
@property (weak, nonatomic) IBOutlet UILabel *guigeLab;
+(YLDFMyBuyBaoJiaCell *)yldFMyBuyBaoJiaCell;
@end
