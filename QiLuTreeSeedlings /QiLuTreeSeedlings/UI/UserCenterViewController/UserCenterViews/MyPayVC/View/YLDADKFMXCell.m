//
//  YLDADKFMXCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/27.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDADKFMXCell.h"

@implementation YLDADKFMXCell
+(YLDADKFMXCell *)yldADKFMXCell
{
    YLDADKFMXCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDADKFMXCell" owner:self options:nil] firstObject];
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
