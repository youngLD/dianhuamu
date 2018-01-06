//
//  YLDGroupTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/12/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGroupTableViewCell.h"

@implementation YLDGroupTableViewCell
+(YLDGroupTableViewCell *)yldGroupTableViewCell
{
    YLDGroupTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDGroupTableViewCell" owner:self options:nil] firstObject];
    cell.groupImage.layer.masksToBounds=YES;
    cell.groupImage.layer.cornerRadius=20;
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
