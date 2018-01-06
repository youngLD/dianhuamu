//
//  YLDADCDetialNCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/28.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDADCDetialNCell.h"

@implementation YLDADCDetialNCell
+(YLDADCDetialNCell *)yldADCDetialNCell
{
    YLDADCDetialNCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDADCDetialNCell" owner:self options:nil] firstObject];
    cell.imageVV.layer.masksToBounds=YES;
    cell.imageVV.layer.cornerRadius=20;
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
