//
//  YLDFEorderQuoteTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/10.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFEorderQuoteTableViewCell.h"
#import "UIDefines.h"
@implementation YLDFEorderQuoteTableViewCell
+(YLDFEorderQuoteTableViewCell *)yldFEorderQuoteTableViewCell
{
    YLDFEorderQuoteTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDFEorderQuoteTableViewCell" owner:self options:nil] firstObject];
    cell.numLab.layer.masksToBounds=YES;
    cell.numLab.layer.cornerRadius=4;
    return cell;
}
-(void)setModel:(YLDFQuoteModel *)model
{
    _model=model;
    self.personLab.text=model.name;
    self.priceLab.text=[NSString stringWithFormat:@"%@元",model.quote];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"规格说明:%@",model.demand]];
    [str addAttribute:NSForegroundColorAttributeName value:titleLabColor range:NSMakeRange(0,5)];
    self.shuomingLab.attributedText=str;
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
