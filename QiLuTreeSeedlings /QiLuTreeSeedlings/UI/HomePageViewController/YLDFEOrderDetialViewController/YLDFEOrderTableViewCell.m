//
//  YLDFEOrderTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/12.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFEOrderTableViewCell.h"
#import "UIDefines.h"
@implementation YLDFEOrderTableViewCell
+(YLDFEOrderTableViewCell *)yldFEOrderTableViewCell
{
    YLDFEOrderTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDFEOrderTableViewCell" owner:self options:nil] firstObject];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.BGV.layer.masksToBounds=YES;
    cell.BGV.layer.cornerRadius=6;
    cell.BGV.layer.borderColor=kLineColor.CGColor;
    cell.BGV.layer.borderWidth=1;
    cell.numLab.layer.masksToBounds=YES;
    cell.numLab.layer.cornerRadius=4;
    cell.baojiaBtn.layer.masksToBounds=YES;
    cell.baojiaBtn.layer.cornerRadius=4;
    return cell;
}
- (IBAction)baojiaBtnAction:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate itemBaojiaActionWithModel:self.model];
    }
}
-(void)setModel:(YLDFMyOrderItemsModel *)model
{
    _model=model;
    self.nameLab.text=model.itemName;
    self.mmNumLab.text=model.quantity;
    self.guigeLab.text=[NSString stringWithFormat:@"规格要求:%@",model.demand];
    if ([model.status isEqualToString:@"已报价"]) {
        self.baojiaBtn.enabled=NO;
        [self.baojiaBtn setBackgroundColor:kRGB(214, 214, 214,1)];
        
    }else{
        self.baojiaBtn.enabled=YES;
        [self.baojiaBtn setBackgroundColor:kRGB(255, 152,31,1)];
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
