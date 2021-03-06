//
//  YLDFMyBuyTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/2.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFMyBuyTableViewCell.h"
#import "UIDefines.h"
@implementation YLDFMyBuyTableViewCell
+(YLDFMyBuyTableViewCell *)yldFMyBuyTableViewCell
{
    YLDFMyBuyTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDFMyBuyTableViewCell" owner:self options:nil] firstObject];
    cell.titleLabW.constant=kWidth-30;
    cell.qiyeV.hidden=YES;
    cell.jjrV.hidden=YES;
    cell.ShiMingV.hidden=YES;
    cell.GCV.hidden=YES;
    cell.YLHV.hidden=YES;
    cell.BSV7.hidden=YES;
    cell.BSV6.hidden=YES;
    [cell.lineImageV setImage:[ZIKFunction imageWithSize:cell.lineImageV.frame.size borderColor:kLineColor borderWidth:1]];
//    cell.imageVAry=@[cell.ShiMingV,cell.qiyeV,cell.jjrV,cell.GCV,cell.YLHV];
    cell.titleLabW.constant=kWidth-30;
    
    return cell;
}
+(YLDFMyBuyTableViewCell *)yldFListBuyTableViewCell
{
    YLDFMyBuyTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDFMyBuyTableViewCell" owner:self options:nil] firstObject];
    cell.LineToTimeLabC.constant=5;
    cell.lineH.constant=1;
    [cell.bottmLineV setBackgroundColor:kLineColor];
    [cell.btnView  removeFromSuperview];
    cell.qiyeV.hidden=YES;
    cell.jjrV.hidden=YES;
    cell.ShiMingV.hidden=YES;
    cell.GCV.hidden=YES;
    cell.YLHV.hidden=YES;
    [cell.lineImageV setImage:[ZIKFunction imageWithSize:cell.lineImageV.frame.size borderColor:kLineColor borderWidth:1]];
    cell.titleLabW.constant=kWidth-30; cell.imageVAry=@[cell.ShiMingV,cell.qiyeV,cell.jjrV,cell.GCV,cell.YLHV,cell.BSV6,cell.BSV7];
    return cell;
}
-(void)setModel:(YLDFBuyModel *)model
{
    _model=model;
    if (model.isSelect) {
        self.selected = YES;
    }else{
        self.selected = NO;
    }
    if (model.roles>0) {
        CGFloat wwww=[self getTitleLabWidthWithText:[NSString stringWithFormat:@"求购%@%@",model.productName,model.demand] WithFont:19 withJx:2 WithBiaoSNum:model.roles.count-1];
        self.titleLabW.constant=wwww;
        for (UIImageView *view in self.imageVAry) {
            view.hidden=YES;
        }
        
        NSInteger bsVIndex=0;
        for (int i=0; i<model.roles.count; i++) {
            NSDictionary *dic=self.model.roles[i];
            NSString *roleTypeId=dic[@"roleTypeId"];
            if (![roleTypeId isEqualToString:@"normal"]) {
                UIImageView *imageV=self.imageVAry[bsVIndex];
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
        [self.openOrCloseBtn setTitle:@" 下架" forState:UIControlStateNormal];
        [self.openOrCloseBtn setImage:[UIImage imageNamed:@"mysupplyXJ.png"] forState:UIControlStateNormal];
    }else{
        self.refreshBtnW.constant=0.01;
        self.refreshToEditL.constant=0.01;
        
        [self.openOrCloseBtn setTitle:@" 上架" forState:UIControlStateNormal];
        [self.openOrCloseBtn setImage:[UIImage imageNamed:@"mysupplySJ.png"] forState:UIControlStateNormal];
    }
    self.titleLab.text=[NSString stringWithFormat:@"求购%@%@",model.productName,model.demand];

    self.timeLab.text=[NSString stringWithFormat:@"%@",model.updateDate];
    self.numLab.text=[NSString stringWithFormat:@"%ld次",model.views];
    self.cityLab.text=model.area;
}
- (IBAction)deleteBtnAction:(id)sender {
    if (self.deletgate) {
        [self.deletgate myBuyDeleteWithModel:self.model];
    }
}
- (IBAction)editBtnAction:(id)sender {
    if (self.deletgate) {
        [self.deletgate myBuyEditWithModel:self.model];
    }
}
- (IBAction)refreshBtnAction:(id)sender {
    if (self.deletgate) {
        [self.deletgate myBuyRefreshWithModel:self.model];
    }
}
- (IBAction)closeBtnAction:(id)sender {
    if (self.deletgate) {
        [self.deletgate myBuyColseOrOpenWithModel:self.model];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(CGFloat)getTitleLabWidthWithText:(NSString *)text WithFont:(NSInteger)font withJx:(CGFloat)jx WithBiaoSNum:(NSInteger)bsNum
{
    CGFloat width=kWidth-30;
    if (bsNum!=0) {
        CGRect textR = [ZIKFunction getCGRectWithContent:text height:self.titleLab.frame.size.height font:19];
        CGFloat textBSW=textR.size.width+bsNum*21.f;
        if (textBSW<width) {
            width=textR.size.width+5;
        }else
        {
            width=width-bsNum*21.f;
        }
    }
    return width;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
