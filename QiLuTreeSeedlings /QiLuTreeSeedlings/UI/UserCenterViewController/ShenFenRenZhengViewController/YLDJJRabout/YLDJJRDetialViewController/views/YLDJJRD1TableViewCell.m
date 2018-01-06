//
//  YLDJJRD1TableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/9.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRD1TableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ZIKFunction.h"
#import "UIDefines.h"
@implementation YLDJJRD1TableViewCell
+(YLDJJRD1TableViewCell *)yldJJRD1TableViewCell
{
    YLDJJRD1TableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDJJRD1TableViewCell" owner:self options:nil] firstObject];
    cell.txImageV.layer.masksToBounds=YES;
    cell.txImageV.layer.cornerRadius=cell.txImageV.frame.size.width/2;
    cell.llLab.layer.masksToBounds=YES;
    cell.llLab.layer.cornerRadius=4;
    cell.moreBtn.hidden=YES;
    return cell;
}
-(void)setModel:(YLDJJrModel *)model{
    _model=model;
    self.nameLab.text=model.name;
    [self.nameLab sizeToFit];
    [self.txImageV setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"jjrmorenTu.png"]];
    if (model.defaultAreaName) {
        self.llLab.text=[NSString stringWithFormat:@"%@经纪人",model.defaultAreaName];
    }else{
        NSArray *ary= [model.areaNames componentsSeparatedByString:@","];
        if (ary.count>0) {
            self.llLab.text=[NSString stringWithFormat:@"%@经纪人",ary[0]];
        }
    }
    
    if (model.areaNames) {
        self.areaLab.text=[NSString stringWithFormat:@"经营区域:%@",model.areaNames];
    }
    [self.areaLab sizeToFit];
    if (model.explain) {
        self.ziwoJSV.text=[NSString stringWithFormat:@"自我介绍:%@",model.explain];
       CGFloat hieght = [ZIKFunction getHeightWithContent:self.ziwoJSV.text width:kWidth-30 font:13];
        if (hieght<48) {
            self.moreBtn.hidden=YES;
            self.JSH.constant=hieght+4;
        }else if (hieght>=48){
            self.moreBtn.hidden=NO;
            if (model.selected==YES) {
                self.moreBtn.selected=YES;
                self.JSH.constant=hieght+10;
                self.jsBH.constant=30;
            }else{
                self.moreBtn.selected=NO;
                self.JSH.constant=70;
                self.jsBH.constant=11.5;
            }
        }
    }
    if (model.productNames) {
        self.zhuyingLab.text=[NSString stringWithFormat:@"主营品种:%@",model.productNames];
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
