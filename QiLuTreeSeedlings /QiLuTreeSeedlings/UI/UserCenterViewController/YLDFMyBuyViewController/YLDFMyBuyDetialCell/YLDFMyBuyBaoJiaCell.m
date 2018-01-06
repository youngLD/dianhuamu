//
//  YLDFMyBuyBaoJiaCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/3.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFMyBuyBaoJiaCell.h"

@implementation YLDFMyBuyBaoJiaCell
+(YLDFMyBuyBaoJiaCell *)yldFMyBuyBaoJiaCell
{
    YLDFMyBuyBaoJiaCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDFMyBuyBaoJiaCell" owner:self options:nil] firstObject];
    cell.numLab.layer.masksToBounds=YES;
    cell.numLab.layer.cornerRadius=3;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
