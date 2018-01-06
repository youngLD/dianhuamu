//
//  YLDSMyFollowTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/4/11.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSMyFollowTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@implementation YLDSMyFollowTableViewCell
+(YLDSMyFollowTableViewCell *)yldSMyFollowTableViewCell
{
    YLDSMyFollowTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDSMyFollowTableViewCell" owner:self options:nil] lastObject];
    cell.imageV.layer.masksToBounds=YES;
    cell.imageV.layer.cornerRadius=20;
    
    return cell;
}
-(void)setModel:(YLDSAuthorModel *)model
{
    _model=model;
    [self.imageV setImageWithURL:[NSURL URLWithString:model.headPortrait] placeholderImage:[UIImage imageNamed:@"UserImage"]];
    self.nameLab.text=model.name;
    self.remakeLab.text=model.remark;
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
