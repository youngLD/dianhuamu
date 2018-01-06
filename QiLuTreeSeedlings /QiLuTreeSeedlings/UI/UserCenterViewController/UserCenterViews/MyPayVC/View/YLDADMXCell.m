//
//  YLDADMXCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/27.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDADMXCell.h"

@implementation YLDADMXCell
+(YLDADMXCell *)yldADMXCell
{
    YLDADMXCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDADMXCell" owner:self options:nil] firstObject];
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
