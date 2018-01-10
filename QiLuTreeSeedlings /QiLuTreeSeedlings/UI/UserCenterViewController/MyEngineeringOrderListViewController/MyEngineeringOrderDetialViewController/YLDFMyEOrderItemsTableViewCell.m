//
//  YLDFMyEOrderItemsTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/10.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFMyEOrderItemsTableViewCell.h"
#import "UIDefines.h"
@implementation YLDFMyEOrderItemsTableViewCell
+(YLDFMyEOrderItemsTableViewCell *)yldFMyEOrderItemsTableViewCell
{
    YLDFMyEOrderItemsTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDFMyEOrderItemsTableViewCell" owner:self options:nil] firstObject];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.BGV.layer.masksToBounds=YES;
    cell.BGV.layer.cornerRadius=6;
    cell.BGV.layer.borderColor=kLineColor.CGColor;
    cell.BGV.layer.borderWidth=1;
    cell.numLab.layer.masksToBounds=YES;
    cell.numLab.layer.cornerRadius=4;
    return cell;
    
}
-(void)setModel:(YLDFMyOrderItemsModel *)model
{
    _model=model;
    self.mmNameLab.text=model.itemName;
    self.mmNumLab.text=model.quantity;
    self.guigeyaoqiuLab.text=[NSString stringWithFormat:@"规格要求:%@",model.demand];
    self.personNumLab.text=[NSString stringWithFormat:@"%ld",model.quoteCount];
    if (model.closed) {
        self.closeBtn.hidden=YES;
        self.closeBtnW.constant=0.01;
    }else{
        self.closeBtn.hidden=NO;
        self.closeBtnW.constant=82;
        
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)lookUpBtnAction:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate itemLookUpActionWithModel:self.model];
    }
}
- (IBAction)closeBtnAction:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate itemCloseActionWithModel:self.model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
