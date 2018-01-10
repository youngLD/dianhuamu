//
//  YLDFMyEorderDetialInfoTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/10.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFMyEorderDetialInfoTableViewCell.h"
#import "ZIKFunction.h"
#import "UIDefines.h"
@implementation YLDFMyEorderDetialInfoTableViewCell
+(YLDFMyEorderDetialInfoTableViewCell *)yldFMyEorderDetialInfoTableViewCell
{
    YLDFMyEorderDetialInfoTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDFMyEorderDetialInfoTableViewCell" owner:self options:nil] firstObject];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.lineImageV setImage:[ZIKFunction imageWithSize:cell.lineImageV.frame.size borderColor:kLineColor borderWidth:1]];
    cell.showView.layer.shadowOpacity = 0.5;// 阴影透明度
    
    cell.showView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    
    cell.showView.layer.shadowRadius = 2;// 阴影扩散的范围控制
    
    cell.showView.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
    
    return cell;
}
-(void)setModel:(YLDFEOrderModel *)model{
    _model=model;
    self.eOrderNameLab.text=model.engineeringProcurementName;
    self.addressLab.text=[NSString stringWithFormat:@"用苗地:%@",model.area];
    self.baojiaTypeLab.text=model.quoteType;
    self.shuomingLab.text=[NSString stringWithFormat:@"订单说明:%@",model.Description];
    self.personLab.text=[NSString stringWithFormat:@"用苗人:%@",model.linkman];
    self.companyNameLab.text=[NSString stringWithFormat:@"公司名称:%@",model.enterpriseName];
    self.timeLab.text=[NSString stringWithFormat:@"截止日期:%@",model.thruDate];
    if ([model.status isEqualToString:@"已过期"]) {
        self.stateImageV.image=[UIImage imageNamed:@"MyEOYiGuoQi"];
    }
    if ([model.status isEqualToString:@"报价中"]) {
        self.stateImageV.image=[UIImage imageNamed:@"MyEOBaoJiaZhong"];
    }
    if ([model.status isEqualToString:@"已报价"]) {
        self.stateImageV.image=[UIImage imageNamed:@"MyEOYiBaoJia"];
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
