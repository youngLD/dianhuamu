//
//  YLDEngineeringOrderTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/9.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDEngineeringOrderTableViewCell.h"
#import "ZIKFunction.h"
#import "UIDefines.h"
@implementation YLDEngineeringOrderTableViewCell
+(YLDEngineeringOrderTableViewCell *)yldEngineeringOrderTableViewCell
{
    YLDEngineeringOrderTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDEngineeringOrderTableViewCell" owner:self options:nil] firstObject];
    cell.lineImageV.image=[ZIKFunction imageWithSize:cell.lineImageV.frame.size borderColor:kLineColor borderWidth:1];
    return cell;
}
-(void)setModel:(YLDFEOrderModel *)model
{
    _model=model;
    self.EOrderNameLab.text=model.engineeringProcurementName;
    self.addressLab.text=[NSString stringWithFormat:@"用苗地:%@",model.area];
    self.baojiaoTypeLab.text=model.quoteType;
    self.dingdanshuomingLab.text=[NSString stringWithFormat:@"订单说明:%@",model.Description];
    self.pinzhongLab.text=model.itemName;
    self.companyNameLab.text=[NSString stringWithFormat:@"公司名称:%@",model.enterpriseName];
    self.timeLab.text=[NSString stringWithFormat:@"截止日期:%@",model.thruDate];
    if ([model.status isEqualToString:@"已过期"]) {
        self.typeImageV.image=[UIImage imageNamed:@"MyEOYiGuoQi"];
    }
    if ([model.status isEqualToString:@"报价中"]) {
        self.typeImageV.image=[UIImage imageNamed:@"MyEOBaoJiaZhong"];
    }
    if ([model.status isEqualToString:@"已报价"]) {
        self.typeImageV.image=[UIImage imageNamed:@"MyEOYiBaoJia"];
    }
    if (model.itemNameH<=20) {
        self.zhankaiBtn.hidden=YES;
    }else{
        self.zhankaiBtn.hidden=NO;
    }
    if (model.isOpen) {
        if (!self.zhankaiBtn.selected) {
            self.zhankaiBtn.selected=YES;
        }
        if (self.pinzhongLab.numberOfLines!=0) {
            self.pinzhongLab.numberOfLines=0;
        }
    }else{
        if (self.zhankaiBtn.selected) {
            self.zhankaiBtn.selected=NO;
        }
        if (self.pinzhongLab.numberOfLines!=1) {
            self.pinzhongLab.numberOfLines=1;
        }
    }
}
- (IBAction)zhankaiBtnAction:(UIButton *)sender {
    
    sender.selected=!sender.selected;
    if (sender.selected) {
//        self.pinzhongLab.numberOfLines=0;
        self.model.isOpen=YES;
    }else{
//        self.pinzhongLab.numberOfLines=1;
        self.model.isOpen=NO;
    }
    if (self.delegate) {
        [self.delegate cellOpenBtnActionWithCell:self];
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
