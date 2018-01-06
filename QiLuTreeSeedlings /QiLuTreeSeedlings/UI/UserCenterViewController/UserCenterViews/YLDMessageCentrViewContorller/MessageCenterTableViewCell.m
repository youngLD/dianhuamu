//
//  MessageCenterTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/12/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "MessageCenterTableViewCell.h"

@implementation MessageCenterTableViewCell
+messageCenterTableViewCell
{
    MessageCenterTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"MessageCenterTableViewCell" owner:self options:nil] lastObject];
    cell.numbLab.layer.masksToBounds=YES;
    cell.numbLab.layer.cornerRadius=8.5;
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
