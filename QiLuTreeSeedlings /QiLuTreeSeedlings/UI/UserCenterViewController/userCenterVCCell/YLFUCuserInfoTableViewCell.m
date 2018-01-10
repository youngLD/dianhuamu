//
//  YLFUCuserInfoTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/9.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLFUCuserInfoTableViewCell.h"
#import "UIDefines.h"
#import "UIImageView+AFNetworking.h"
@implementation YLFUCuserInfoTableViewCell
+(YLFUCuserInfoTableViewCell *)yldFUCuserInfoTableViewCell
{
    YLFUCuserInfoTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLFUCuserInfoTableViewCell" owner:self options:nil] firstObject];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (kWidth<=320) {
         cell.centerLine.constant=40;
    }
    cell.userImageV.layer.masksToBounds=YES;
    cell.userImageV.layer.cornerRadius=72/2;
    cell.userImageV.layer.borderColor=[UIColor colorWithWhite:1 alpha:0.3].CGColor;
    cell.userImageV.layer.borderWidth=3;
    return cell;
}
-(void)reloadselfInfo
{
    if (![APPDELEGATE isNeedLogin]) {
        self.nameLab.text=@"登录";
        self.phoneLab.text=nil;
        [self.userImageV setImage:[UIImage imageNamed:@"userImageMR.png"]];
        return;
    }
    if (APPDELEGATE.userModel.nickname.length>0) {
        self.nameLab.text=APPDELEGATE.userModel.nickname;
    }else{
       self.nameLab.text=APPDELEGATE.userModel.partyId;
    }
    
    self.phoneLab.text=APPDELEGATE.userModel.partyId;
    if (APPDELEGATE.userModel.headPortrait.length>0) {
        [self.userImageV setImageWithURL:[NSURL URLWithString:APPDELEGATE.userModel.headPortrait]];
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
