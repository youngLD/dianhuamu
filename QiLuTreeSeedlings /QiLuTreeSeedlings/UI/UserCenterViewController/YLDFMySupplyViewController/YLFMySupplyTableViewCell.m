 //
//  YLFMySupplyTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/27.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLFMySupplyTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIDefines.h"
@implementation YLFMySupplyTableViewCell
+(YLFMySupplyTableViewCell *)yldFMySupplyTableViewCell
{
    YLFMySupplyTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLFMySupplyTableViewCell" owner:self options:nil] firstObject];
    return cell;
}
+(YLFMySupplyTableViewCell *)yldFListSupplyTableViewCell
{
    YLFMySupplyTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLFMySupplyTableViewCell" owner:self options:nil] firstObject];
    cell.lineW.constant=1;
    cell.lineTotimeLabC=0;
    [cell.btnView removeFromSuperview];
    [cell.bottomLineV setBackgroundColor:kLineColor];
    return cell;
}
- (IBAction)deleteBtnAction:(id)sender {
    if (self.deletgate) {
        [self.deletgate mySupplyDeleteWithModel:self.model];
    }
}
- (IBAction)editBtnAction:(id)sender {
    if (self.deletgate) {
        [self.deletgate mySupplyEditWithModel:self.model];
    }
}
- (IBAction)refreshBtnAction:(id)sender {
    if (self.deletgate) {
        [self.deletgate mySupplyRefreshWithModel:self.model];
    }
}
- (IBAction)closeBtnAction:(id)sender {
    if (self.deletgate) {
        [self.deletgate mySupplyColseOrOpenWithModel:self.model];
    }
}
-(void)setModel:(YLDFSupplyModel *)model{
    _model=model;
    if (model.isSelect) {
        self.selected = YES;
    }else{
        self.selected = NO;
    }
    if ([model.status isEqualToString:@"open"]) {
        self.refreshBtnW.constant=51;
        self.refreshToEditL.constant=15;
        [self.closeBtn setTitle:@" 下架" forState:UIControlStateNormal];
        [self.closeBtn setImage:[UIImage imageNamed:@"mysupplyXJ.png"] forState:UIControlStateNormal];
    }else{
        self.refreshBtnW.constant=0.01;
        self.refreshToEditL.constant=0.01;
        
        [self.closeBtn setTitle:@" 上架" forState:UIControlStateNormal];
        [self.closeBtn setImage:[UIImage imageNamed:@"mysupplySJ.png"] forState:UIControlStateNormal];
    }
    self.titleLab.text=[NSString stringWithFormat:@"供应%@%@",model.productName,model.demand];
    self.timeLab.text=[NSString stringWithFormat:@"%@",model.updateDate];
    self.numLab.text=[NSString stringWithFormat:@"%ld次",model.views];
    self.addressLab.text=model.area;
    for (int i=0; i<model.attacs.count; i++) {
        NSDictionary *dic=model.attacs[i];
        NSString *attaTypeId=dic[@"attaTypeId"];
        NSString *path=dic[@"path"];
        if (i==0) {
            if ([attaTypeId isEqualToString:@"picture"]) {
               [self.imageV1 setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"MoRentu.png"]];
            }
         }
        if (i==1) {
            if ([attaTypeId isEqualToString:@"picture"]) {
                [self.imageV2 setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"MoRentu.png"]];
            }
        }
        if (i==2) {
            if ([attaTypeId isEqualToString:@"picture"]) {
                [self.imageV3 setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"MoRentu.png"]];
            }
        }
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageV2W.constant=(kWidth-30)/3;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
