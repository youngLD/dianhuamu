//
//  YLDFSystemMessageTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/5.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFSystemMessageTableViewCell.h"

@implementation YLDFSystemMessageTableViewCell
+(YLDFSystemMessageTableViewCell *)yldFSystemMessageTableViewCell
{
    YLDFSystemMessageTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDFSystemMessageTableViewCell" owner:self options:nil] firstObject];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
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