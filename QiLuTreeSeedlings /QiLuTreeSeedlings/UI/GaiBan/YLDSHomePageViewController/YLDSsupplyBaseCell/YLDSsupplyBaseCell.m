//
//  YLDSsupplyBaseCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/7.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSsupplyBaseCell.h"
#import "UIDefines.h"
#import "UIImageView+AFNetworking.h"
#import "ZIKFunction.h"
@implementation YLDSsupplyBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(YLDSsupplyBaseCell *)yldSsupplyBaseCell
{
    YLDSsupplyBaseCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDSsupplyBaseCell" owner:self options:nil] firstObject];
    
    return cell;
}
- (void)setModel:(HotSellModel *)model{
    _model=model;
    self.titleLab.text=model.title;
    [self.imagV1 setImageWithURL:[NSURL URLWithString:model.iamge] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    [self.iamgV2 setImageWithURL:[NSURL URLWithString:model.iamge2] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    [self.imagV3 setImageWithURL:[NSURL URLWithString:model.iamge3] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    self.cityLab.text=model.area;
    self.timeLab.text=model.timeAger;
    if ([model.price isEqualToString:@"面议"]) {
        self.priceLab.text=model.price;
    }else{
        self.priceLab.text=[NSString stringWithFormat:@"¥%@",model.price];
    }
    
    if (model.goldsupplier == 0 || model.goldsupplier == 10) {
        self.shenfenW.constant=0.1;
        self.shenfenV.image = [UIImage imageNamed:@""];
    } else if (model.goldsupplier == 1) {
        self.shenfenW.constant=20;
        self.shenfenV.image = [UIImage imageNamed:@"列表-金牌供应商2"];
    } else if (model.goldsupplier == 2) {
        self.shenfenW.constant=20;
        self.shenfenV.image = [UIImage imageNamed:@"列表-银牌供应商2"];
    } else if (model.goldsupplier == 3) {
        self.shenfenW.constant=20;
        self.shenfenV.image = [UIImage imageNamed:@"列表-铜牌供应商2"];
    } else if (model.goldsupplier == 4) {
        self.shenfenW.constant=20;
        self.shenfenV.image = [UIImage imageNamed:@"列表-认证供应商"];
    } else if (model.goldsupplier == 5) {
        self.shenfenW.constant=20;
        self.shenfenV.image = [UIImage imageNamed:@"列表-总站"];
    } else if (model.goldsupplier == 6) {
        self.shenfenW.constant=20;
        self.shenfenV.image = [UIImage imageNamed:@"列表-分站"];
    } else if (model.goldsupplier == 7) {
        self.shenfenW.constant=20;
        self.shenfenV.image = [UIImage imageNamed:@"列表-工程公司"];
    }else if (model.goldsupplier == 8) {
        self.shenfenW.constant=20;
        self.shenfenV.image = [UIImage imageNamed:@"合作苗企43x43"];
    }else if(model.goldsupplier == 9)
    {
        self.shenfenW.constant=20;
        self.shenfenV.image = [UIImage imageNamed:@"列表-苗小二"];
    }else if (model.goldsupplier == 11) {
        self.shenfenW.constant=20;
        self.shenfenV.image = [UIImage imageNamed:@"jingjiren"];
    }

    if (self.model.isRead) {
        [self.titleLab setTextColor:readColor];
    }else{
        [self.titleLab setTextColor:MoreDarkTitleColor];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.iamgV2W.constant=(kWidth-29)/3;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.model.isRead=YES;
        [self.titleLab setTextColor:readColor];
    }
    // Configure the view for the selected state
}

@end
