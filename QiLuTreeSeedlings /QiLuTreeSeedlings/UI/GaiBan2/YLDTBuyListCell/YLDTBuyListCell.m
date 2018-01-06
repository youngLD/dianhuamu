//
//  YLDTBuyListCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/8/8.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDTBuyListCell.h"

@implementation YLDTBuyListCell
+(YLDTBuyListCell *)yldTBuyListCell
{
    YLDTBuyListCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDTBuyListCell" owner:self options:nil] firstObject];
    return cell;
}
-(void)setModel:(HotBuyModel *)model{
    _model=model;
    self.titleLab.text=[NSString stringWithFormat:@"求购%@ %ld%@",model.name,model.count,model.unit];
    self.areaLab.text=model.area;
    self.detialLab.text=[NSString stringWithFormat:@"规格要求:%@",model.title];
    self.timeLab.text=model.timeAger;
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
