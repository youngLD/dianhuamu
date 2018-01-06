//
//  YLDShopListTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/10/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShopListTableViewCell.h"

@implementation YLDShopListTableViewCell
+(YLDShopListTableViewCell *)yldShopListTableViewCell
{
    YLDShopListTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDShopListTableViewCell" owner:self options:nil] lastObject];
    return cell;
}
-(void)setModel:(YLDShopListModel *)model
{
    _model=model;
    self.shopNameLab.text= model.shopName;
    self.addressLab.text=model.areaAddress;
    self.presonLab.text=model.phone;
    [self.phoneBtn addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)callAction
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

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
