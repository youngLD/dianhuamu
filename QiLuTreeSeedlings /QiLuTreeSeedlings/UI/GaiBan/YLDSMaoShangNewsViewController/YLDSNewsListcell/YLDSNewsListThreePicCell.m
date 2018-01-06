//
//  YLDSNewsListThreePicCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/25.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSNewsListThreePicCell.h"
#import "UIDefines.h"
#import "UIImageView+AFNetworking.h"
@implementation YLDSNewsListThreePicCell
+(YLDSNewsListThreePicCell *)yldSNewsListThreePicCell
{
    YLDSNewsListThreePicCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDSNewsListThreePicCell" owner:self options:nil] lastObject];
    return cell;
}
-(void)setModel:(YLDZXLmodel *)model
{
    _model=model;
    self.titleLab.text = model.title;
    if (model.viewTimes>9999) {
        CGFloat ff=model.viewTimes/10000;
        self.readLab.text=[NSString stringWithFormat:@"阅读%.1f万",ff];
    }else{
        self.readLab.text=[NSString stringWithFormat:@"阅读%ld",model.viewTimes];
    }
    if (model.picAry.count>=3) {
        [self.imageV1 setImageWithURL:[NSURL URLWithString:[model.picAry firstObject]] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
        [self.imageV2 setImageWithURL:[NSURL URLWithString:model.picAry [1]] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
        [self.imageV3 setImageWithURL:[NSURL URLWithString:model.picAry [2]] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    }
    if (self.model.readed) {
        [self.titleLab setTextColor:readColor];
    }else{
        [self.titleLab setTextColor:MoreDarkTitleColor];
    }
    self.timeLab.text=model.publishtimeStr;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.imag2W.constant=(kWidth-29)/3;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.model.readed=YES;
        if (self.model.readed) {
            [self.titleLab setTextColor:readColor];
        }else{
            [self.titleLab setTextColor:MoreDarkTitleColor];
        }
        if (![self.model.articleCategoryShortName isEqualToString:@"招标"]) {
            
            self.model.viewTimes+=1;
            if (self.model.viewTimes>9999) {
                NSInteger qq=self.model.viewTimes/1000;
                CGFloat ff=qq/10;
                self.readLab.text=[NSString stringWithFormat:@"阅读%lf.1万",ff];
            }else{
                self.readLab.text=[NSString stringWithFormat:@"阅读%ld",self.model.viewTimes];
            }
            
        }
    }

    // Configure the view for the selected state
}

@end
