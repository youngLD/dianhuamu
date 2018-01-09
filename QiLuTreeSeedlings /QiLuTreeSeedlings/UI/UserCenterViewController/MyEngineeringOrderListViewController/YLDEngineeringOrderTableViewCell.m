//
//  YLDEngineeringOrderTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/9.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDEngineeringOrderTableViewCell.h"
#import "ZIKFunction.h"
#import "UIDefines.h"
@implementation YLDEngineeringOrderTableViewCell
+(YLDEngineeringOrderTableViewCell *)yldEngineeringOrderTableViewCell
{
    YLDEngineeringOrderTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDEngineeringOrderTableViewCell" owner:self options:nil] firstObject];
    cell.lineImageV.image=[ZIKFunction imageWithSize:cell.lineImageV.frame.size borderColor:kLineColor borderWidth:1];
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
