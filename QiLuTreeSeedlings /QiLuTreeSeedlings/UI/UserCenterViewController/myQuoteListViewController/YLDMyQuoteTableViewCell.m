//
//  YLDMyQuoteTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/15.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDMyQuoteTableViewCell.h"
#import "ZIKFunction.h"
#import "UIDefines.h"
@implementation YLDMyQuoteTableViewCell
+(YLDMyQuoteTableViewCell *)yldMyQuoteTableViewCell
{
    YLDMyQuoteTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDMyQuoteTableViewCell" owner:self options:nil] firstObject];
    [cell.lineV setImage:[ZIKFunction imageWithSize:cell.lineV.frame.size borderColor:kLineColor borderWidth:1]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)setModel:(YLDFMyQuoteModel *)model{
    _model=model;
    self.titleLab.text=model.title;
    self.guigeLab.text=[NSString stringWithFormat:@"规格要求:%@",model.demand];
    self.addressLab.text=model.area;
    self.timeLab.text=model.productDateStr;
    self.viewsLab.text=[NSString stringWithFormat:@"%ld",model.views];
    self.priceLab.text=[NSString stringWithFormat:@"%@元",model.quote];
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
