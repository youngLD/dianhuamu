//
//  YLDADCDetialCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/28.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDADCDetialCell.h"

@implementation YLDADCDetialCell
+(YLDADCDetialCell *)yldADCDetialCell
{
    YLDADCDetialCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDADCDetialCell" owner:self options:nil] firstObject];
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
