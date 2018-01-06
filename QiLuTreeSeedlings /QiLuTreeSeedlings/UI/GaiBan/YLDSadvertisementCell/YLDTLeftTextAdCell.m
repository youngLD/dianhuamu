//
//  YLDTLeftTextAdCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/9/1.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDTLeftTextAdCell.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "UIImageView+AFNetworking.h"
@implementation YLDTLeftTextAdCell
+(YLDTLeftTextAdCell *)yldTLeftTextAdCell
{
    YLDTLeftTextAdCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDTLeftTextAdCell" owner:self options:nil] firstObject];
    cell.tuiguangLab.layer.masksToBounds=YES;
    cell.tuiguangLab.layer.borderWidth=0.5;
    cell.tuiguangLab.layer.borderColor=NavColor.CGColor;
    cell.tuiguangLab.layer.cornerRadius=3;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(YLDSadvertisementModel *)model
{
    _model=model;
    self.titleLab.text=model.name;
    [self.imageV setImageWithURL:[NSURL URLWithString:model.attachment] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    if (model.isRead) {
        [self.titleLab setTextColor:readColor];
    }else{
        [self.titleLab setTextColor:MoreDarkTitleColor];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [HTTPCLIENT adReadNumWithAdUid:self.model.uid Success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
        NSString *ttt;
        if ([APPDELEGATE isNeedLogin]) {
            ttt=@"0";
        }else{
            ttt=@"1";
        }
        
        [HTTPADCLIENT adClickAcitionWithADuid:self.model.uid WithMemberUid:APPDELEGATE.userModel.access_id WithBrowsePage:nil WithBrowseUserType:ttt withiosClientId:APPDELEGATE.IDFVSTR Success:^(id responseObject) {
            //                        [ToastView showTopToast:responseObject obgect]
        } failure:^(NSError *error) {
            
        }];
    }

    // Configure the view for the selected state
}

@end
