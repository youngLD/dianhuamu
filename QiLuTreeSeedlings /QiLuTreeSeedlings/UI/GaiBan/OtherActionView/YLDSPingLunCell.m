//
//  YLDSPingLunCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/24.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSPingLunCell.h"
#import "UIDefines.h"
#import "UIImageView+AFNetworking.h"
#import "HttpClient.h"
@implementation YLDSPingLunCell
+(YLDSPingLunCell *)yldSPingLunCell
{
    YLDSPingLunCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDSPingLunCell" owner:self options:nil] lastObject];
    [cell.zanBtn setTitleColor:titleLabColor forState:UIControlStateNormal];
    [cell.zanBtn setImage:[[UIImage imageNamed:@"unzan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [cell.zanBtn setTitleColor:NavColor forState:UIControlStateSelected];
    [cell.zanBtn setImage:[[UIImage imageNamed:@"zan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
//    [cell.nameLab setTextColor:titleLabColor];
//    [cell.timeLab setTextColor:titleLabColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    [cell.commentLab setTextColor:MoreDarkTitleColor];
    cell.imagV.layer.masksToBounds=YES;
    cell.imagV.layer.cornerRadius=45/2.f;
//    [cell.deleteBtn setTitleColor:titleLabColor forState:UIControlStateNormal];
    return cell;
}
-(void)setModel:(YLDSPingLunModel *)model{
    _model=model;
    [self.imagV setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"UserImageV"]];
    self.nameLab.text=model.memberName;
    if (model.reply_str.length>0) {
        self.commentLab.text=[NSString stringWithFormat:@"%@%@",model.comment,model.reply_str];
    }else{
      self.commentLab.text=model.comment;
    }
    
    if (model.appreciateCount==0) {
        [self.zanBtn setTitle:@"赞" forState:UIControlStateNormal];
    }else{
        [self.zanBtn setTitle:[NSString stringWithFormat:@"%ld",model.appreciateCount] forState:UIControlStateNormal];
        [self.zanBtn setTitle:[NSString stringWithFormat:@"%ld",model.appreciateCount] forState:UIControlStateSelected];
    }
    if (model.isAppreciate==0) {
        self.zanBtn.selected=NO;
    }else{
        self.zanBtn.selected=YES;
    }
    if (model.reply_count>0) {
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"%ld回复",model.reply_count] forState:UIControlStateNormal];
    }else{
        [self.deleteBtn setTitle:@"回复" forState:UIControlStateNormal];
    }
    self.timeLab.text=model.timec;
    [self.timeLab sizeToFit];
    [self.zanBtn addTarget:self action:@selector(zanActoion:) forControlEvents:UIControlEventTouchUpInside];
//    if (model.memberUid ==APPDELEGATE.userModel.chanyanUser_id) {
//        self.deleteBtn.hidden=NO;
//    }else{
//        self.deleteBtn.hidden=YES;
//    }
    [self.deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)zanActoion:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }else
    {
        if(self.delgate)
        {
            [self.delgate zanActionWith:sender Uid:self.model];
        }
    }
    
}
-(void)deleteBtnAction
{
    if ([self.delgate respondsToSelector:@selector(deleteActionWithModel:)]) {
        [self.delgate deleteActionWithModel:self.model];
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
