//
//  YLDSBuyBrifTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/3/1.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSBuyBrifTableViewCell.h"

@implementation YLDSBuyBrifTableViewCell
+(YLDSBuyBrifTableViewCell *)yldSBuyBrifTableViewCell
{
    YLDSBuyBrifTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDSBuyBrifTableViewCell" owner:self options:nil] firstObject];
    
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
