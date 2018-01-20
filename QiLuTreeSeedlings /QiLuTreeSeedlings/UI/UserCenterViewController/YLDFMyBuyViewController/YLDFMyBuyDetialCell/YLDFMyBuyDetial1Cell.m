//
//  YLDFMyBuyDetial1Cell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/3.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFMyBuyDetial1Cell.h"
#import "UIDefines.h"
@implementation YLDFMyBuyDetial1Cell
+(YLDFMyBuyDetial1Cell *)yldFMyBuyDetial1Cell
{
    YLDFMyBuyDetial1Cell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDFMyBuyDetial1Cell" owner:self options:nil] firstObject];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setModel:(YLDFBuyModel *)model
{
    _model=model;
    self.shuzhongNameLab.text=model.productName;
    self.timeLab.text=model.updateDate;
    if (model.area) {
      self.addressLab.text=model.area;
    }
    
    self.personLab.text=model.linkman;
    self.viewsLab.text=[NSString stringWithFormat:@"%ld",model.views];
    self.numLab.text=[NSString stringWithFormat:@"%@",model.quantity];
    NSString *baojiaStr;

    if ([model.quoteTypeId isEqualToString:@"car_price"]) {
        baojiaStr=@"上车价";
    }else if([model.quoteTypeId isEqualToString:@"arrival_price"])
    {
        baojiaStr=@"到货价";
    }else if([model.quoteTypeId isEqualToString:@"buy_price"])
    {
        baojiaStr=@"买苗价";
    }
    self.piceTypeLab.text=baojiaStr;
    self.demaLab.text=model.demand;
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
