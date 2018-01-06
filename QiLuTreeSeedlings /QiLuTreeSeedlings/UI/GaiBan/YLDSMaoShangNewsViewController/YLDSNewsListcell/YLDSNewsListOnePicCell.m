//
//  YLDSNewsListOnePicCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/25.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSNewsListOnePicCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIDefines.h"
@implementation YLDSNewsListOnePicCell
+(YLDSNewsListOnePicCell *)yldSNewsListOnePicCell
{
    YLDSNewsListOnePicCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDSNewsListOnePicCell" owner:self options:nil] lastObject];
    
    return cell;
}
-(void)setModel:(YLDZXLmodel *)model{
    _model = model;
    self.titleLab.text = model.title;
    if (model.viewTimes>9999) {
        NSInteger qq=model.viewTimes/1000;
        CGFloat ff=qq/10;
        self.yueduLab.text=[NSString stringWithFormat:@"阅读%.1f万",ff];
    }else{
        self.yueduLab.text=[NSString stringWithFormat:@"阅读%ld",model.viewTimes];
    }
    if (self.model.readed) {
        [self.titleLab setTextColor:readColor];
    }else{
        [self.titleLab setTextColor:MoreDarkTitleColor];
    }

    [self.imageV setImageWithURL:[NSURL URLWithString:[model.picAry firstObject]] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    self.timeLab.text=model.publishtimeStr;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        if (![self.model.articleCategoryShortName isEqualToString:@"招标"]) {
            self.model.readed=YES;
            self.model.viewTimes+=1;
            if (self.model.viewTimes>9999) {
                NSInteger qq=self.model.viewTimes/1000;
                CGFloat ff=qq/10;
                self.yueduLab.text=[NSString stringWithFormat:@"阅读%lf.1万",ff];
            }else{
                self.yueduLab.text=[NSString stringWithFormat:@"阅读%ld",self.model.viewTimes];
            }
            if (self.model.readed) {
                [self.titleLab setTextColor:readColor];
            }else{
                [self.titleLab setTextColor:MoreDarkTitleColor];
            }

        }

    }
    // Configure the view for the selected state
}

@end
