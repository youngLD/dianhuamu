//
//  YLDTHYDWCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/9/16.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDTHYDWCell.h"

@implementation YLDTHYDWCell
+(YLDTHYDWCell *)yldTHYDWCell
{
    YLDTHYDWCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDTHYDWCell" owner:self options:nil] firstObject];
    
    
    return cell;
}
-(void)setModel:(YLDTHEDWModel *)model{
    _model=model;
    self.nameLab.text=model.name;
    self.dizhiLab.text=model.address;
    [self.nameLab sizeToFit];
    [self.dizhiLab sizeToFit];
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
