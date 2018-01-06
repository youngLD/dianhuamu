//
//  YLDFUserGCTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/23.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFUserGCTableViewCell.h"
#import "UIDefines.h"
@implementation YLDFUserGCTableViewCell
+(YLDFUserGCTableViewCell *)yldFUserGCTableViewCell
{
    YLDFUserGCTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDFUserGCTableViewCell" owner:self options:nil] firstObject];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.view2W.constant=kWidth/3;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
