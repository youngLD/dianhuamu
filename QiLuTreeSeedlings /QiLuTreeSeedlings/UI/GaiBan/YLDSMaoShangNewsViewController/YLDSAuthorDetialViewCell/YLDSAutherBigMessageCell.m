//
//  YLDSAutherBigMessageCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/4/10.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSAutherBigMessageCell.h"
#import "UIImageView+AFNetworking.h"
@implementation YLDSAutherBigMessageCell
+(YLDSAutherBigMessageCell *)YLDSAutherBigMessageCell
{
    YLDSAutherBigMessageCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDSAutherBigMessageCell" owner:self options:nil] lastObject];
    cell.userImageV.layer.masksToBounds=YES;
    cell.userImageV.layer.cornerRadius=40;
   
    return cell;
    
}
-(void)setModel:(YLDSAuthorModel *)model{
    _model=model;
    [self.userImageV setImageWithURL:[NSURL URLWithString:model.headPortrait] placeholderImage:[UIImage imageNamed:@"UserImageV"]];
    self.ylName.text=model.name;
    self.gsNumLab.text=[NSString stringWithFormat:@"%ld",model.followCount];
    if (model.follow) {
        self.followBtn.selected=YES;
    }else{
       self.followBtn.selected=NO;
    }
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
