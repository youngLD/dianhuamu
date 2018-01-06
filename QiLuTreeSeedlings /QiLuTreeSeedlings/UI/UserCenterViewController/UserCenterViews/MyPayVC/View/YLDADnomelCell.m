//
//  YLDADnomelCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/26.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDADnomelCell.h"

@implementation YLDADnomelCell
+(YLDADnomelCell *)yldADnomelCell
{
    YLDADnomelCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDADnomelCell" owner:self options:nil] firstObject];
    
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
