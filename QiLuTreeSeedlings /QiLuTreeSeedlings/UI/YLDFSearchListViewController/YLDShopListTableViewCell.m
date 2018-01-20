//
//  YLDShopListTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/20.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDShopListTableViewCell.h"
#import "ZIKFunction.h"
#import "UIDefines.h"
@implementation YLDShopListTableViewCell
+(YLDShopListTableViewCell *)yldShopListTableViewCell
{
    YLDShopListTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDShopListTableViewCell" owner:self options:nil] firstObject];
    [cell.lineView setImage:[ZIKFunction imageWithSize:cell.lineView.frame.size borderColor:kLineColor borderWidth:1]];
    return cell;
}
- (IBAction)cheCkBtnAction:(UIButton *)sender{
    if (self.delegate) {
        self.model.isOpen=!sender.selected;
        self.checkBtn.selected=!sender.selected;

        [self.delegate shopCellChackBtnAction:sender withCell:self];
    }
}
- (IBAction)goShopBtnAction:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate goShopDetialWithModel:self.model];
    }
}
-(void)setModel:(YLDFShopModel *)model
{
    _model=model;
    self.nameLab.text=model.name;
    if (model.descriptions) {
        self.jianjieLab.text=[NSString stringWithFormat:@"店铺简介：%@",model.descriptions];
    }else{
        self.jianjieLab.text=@"店铺简介：";
    }
    if (self.model.isOpen) {
        self.checkBtn.selected=YES;
        self.jianjieLabH.constant=self.model.JJTextH +2;
        self.jjBottL.constant=17.5+31;
    }else{
        self.checkBtn.selected=NO;
        self.jianjieLabH.constant=18;
        self.jjBottL.constant=17.5;
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
