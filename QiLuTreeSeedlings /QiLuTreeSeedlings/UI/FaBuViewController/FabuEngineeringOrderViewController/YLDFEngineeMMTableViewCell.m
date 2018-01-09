//
//  YLDFEngineeMMTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/9.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFEngineeMMTableViewCell.h"
#import "UIDefines.h"
#import "ZIKFunction.h"
@implementation YLDFEngineeMMTableViewCell
+(YLDFEngineeMMTableViewCell *)yldFEngineeMMTableViewCell
{
    YLDFEngineeMMTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDFEngineeMMTableViewCell" owner:self options:nil] firstObject];
    [cell.lineImageV setImage:[ZIKFunction imageWithSize:cell.lineImageV.frame.size borderColor:kLineColor borderWidth:1]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setDic:(NSMutableDictionary *)dic
{
    _dic=dic;
    self.mmNameLab.text=dic[@"itemName"];
    self.mmNumLab.text=dic[@"quantity"];
    self.demadLab.text=[NSString stringWithFormat:@"规格要求：%@",dic[@"demand"]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteBtnAction:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate mmCellDeleteWithDic:self.dic];
    }
}
- (IBAction)editBtnAction:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate mmCellEditWithDic:self.dic];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
