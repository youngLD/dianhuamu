//
//  YLDFAddressListTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/12.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFAddressListTableViewCell.h"

@implementation YLDFAddressListTableViewCell
+(YLDFAddressListTableViewCell *)yldFAddressListTableViewCell
{
    YLDFAddressListTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDFAddressListTableViewCell" owner:self options:nil] firstObject];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setModel:(YLDFAddressModel *)model{
    _model=model;
    self.nameLab.text=model.linkman;
    self.phoneLab.text=model.phone;
    self.addressLab.text=[NSString stringWithFormat:@"%@%@%@",model.province,model.city,model.county];
    if (model.defaultAddress) {
        self.selectBtn.selected=YES;
    }else{
        self.selectBtn.selected=NO;
    }
}
- (IBAction)EditBtnAction:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate addressEditWithModel:self.model];
    }
}
- (IBAction)DeleteBtnAction:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate addressDeleteWithModel:self.model];
    }
}
- (IBAction)selectBtnAction:(UIButton *)sender {
    if (sender.selected==YES) {
        return;
    }
    if (self.delegate) {
        [self.delegate addressSelectWithModel:self.model];
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
