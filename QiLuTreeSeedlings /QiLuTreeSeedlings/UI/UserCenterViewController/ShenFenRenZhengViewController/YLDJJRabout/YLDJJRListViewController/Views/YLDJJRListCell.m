//
//  YLDJJRListCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/8.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRListCell.h"
#import "UIImageView+AFNetworking.h"
@implementation YLDJJRListCell
+(YLDJJRListCell *)yldJJRListCell
{
    YLDJJRListCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDJJRListCell" owner:self options:nil] firstObject];
    cell.imageV.layer.masksToBounds=YES;
    cell.imageV.layer.cornerRadius=cell.imageV.frame.size.width/2;
    cell.yuanLab.layer.masksToBounds=YES;
    cell.yuanLab.layer.cornerRadius=4;
    return cell;
}
-(void)setModel:(YLDJJrModel *)model
{
    _model=model;
    [self.imageV setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"jjrmorenTu.png"]];
    self.nameLab.text=model.name;
    if (model.productNames) {
        self.zhuyingLab.text=[NSString stringWithFormat:@"主营:%@",model.productNames];
    }else{
        self.zhuyingLab.text=@"主营:";
    }
    
    if (model.defaultAreaName) {
        self.yuanLab.text=[NSString stringWithFormat:@"%@经纪人",model.defaultAreaName];
    }else{
        NSArray *ary= [model.areaNames componentsSeparatedByString:@","];
        if (ary.count>0) {
            self.yuanLab.text=[NSString stringWithFormat:@"%@经纪人",ary[0]];
        }else
        {
            self.yuanLab.text=@"苗木经纪人";
        }
    }

    self.pinglunLab.text=[NSString stringWithFormat:@"%ld人评论",model.comments];
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
