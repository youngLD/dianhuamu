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
    cell.titleW.constant=kWidth-30;
    return cell;
}
+(YLFMySupplyTableViewCell *)yldFListSupplyTableViewCell
{
    YLFMySupplyTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLFMySupplyTableViewCell" owner:self options:nil] firstObject];
    cell.lineW.constant=1;
    cell.lineTotimeLabC=0;
    [cell.btnView removeFromSuperview];
    [cell.bottomLineV setBackgroundColor:kLineColor];
   cell.titleW.constant=kWidth-30; cell.imageAry=@[cell.bsV1,cell.bsV2,cell.bsV3,cell.bsV4,cell.bsV5,cell.bsV6,cell.bsV7];
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
//    self.titleW.constant=kWidth/3;
    if (model.roles>0) {
        CGFloat wwww=[self getTitleLabWidthWithText:[NSString stringWithFormat:@"供应%@%@",model.productName,model.demand] WithFont:19 withJx:2 WithBiaoSNum:model.roles.count-1];
        self.titleW.constant=wwww;
        for (UIImageView *view in self.imageAry) {
            view.hidden=YES;
        }
        
        NSInteger bsVIndex=0;
        for (int i=0; i<model.roles.count; i++) {
            NSDictionary *dic=self.model.roles[i];
            NSString *roleTypeId=dic[@"roleTypeId"];
            if (![roleTypeId isEqualToString:@"normal"]) {
                UIImageView *imageV=self.imageAry[bsVIndex];
                [imageV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@BS",roleTypeId]]];
                imageV.hidden=NO;
                bsVIndex ++;
                if (bsVIndex>=7) {
                    break;
                }
            }
        }
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
-(CGFloat)getTitleLabWidthWithText:(NSString *)text WithFont:(NSInteger)font withJx:(CGFloat)jx WithBiaoSNum:(NSInteger)bsNum
{
    CGFloat width=kWidth-30;
    if (bsNum!=0) {
        CGRect textR = [ZIKFunction getCGRectWithContent:text height:self.titleLab.frame.size.height font:19];
        CGFloat textBSW=textR.size.width+bsNum*22.f;
        if (textBSW<width) {
            width=textR.size.width;
        }else
        {
            width=width-bsNum*22.f;
        }
    }
    return width;
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
