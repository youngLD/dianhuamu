//
//  YLDTADThreePicCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/8/30.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDTADThreePicCell.h"
#import "UIDefines.h"
#import "UIImageView+AFNetworking.h"
#import "HttpClient.h"
@implementation YLDTADThreePicCell
+(YLDTADThreePicCell *)yldTADThreePicCell
{
    YLDTADThreePicCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDTADThreePicCell" owner:self options:nil] lastObject];
    cell.tuiguangLab.layer.masksToBounds=YES;
    cell.tuiguangLab.layer.borderWidth=0.5;
    cell.tuiguangLab.layer.borderColor=NavColor.CGColor;
    cell.tuiguangLab.layer.cornerRadius=3;
    return cell;
}
-(void)setModel:(YLDSadvertisementModel *)model{
    _model=model;
    self.titleLab.text=model.name;
    if (model.imageAry.count>=1) {
        [self.imageV1 setImageWithURL:[NSURL URLWithString:model.imageAry[0]] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    }
    if (model.imageAry.count>=2) {
        [self.imageV2 setImageWithURL:[NSURL URLWithString:model.imageAry[1]] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    }
    if (model.imageAry.count>=3) {
        [self.imageV3 setImageWithURL:[NSURL URLWithString:model.imageAry[2]] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.IMG2W.constant=(kWidth-29)/3;
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
