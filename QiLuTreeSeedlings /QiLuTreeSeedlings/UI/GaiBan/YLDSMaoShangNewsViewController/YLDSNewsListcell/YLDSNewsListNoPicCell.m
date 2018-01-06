//
//  YLDSNewsListNoPicCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/25.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSNewsListNoPicCell.h"
#import "UIDefines.h"
@implementation YLDSNewsListNoPicCell
+(YLDSNewsListNoPicCell *)yldSNewsListNoPicCell
{
    YLDSNewsListNoPicCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDSNewsListNoPicCell" owner:self options:nil] lastObject];
    
    return cell;
}
-(void)setModel:(YLDZXLmodel *)model
{
    _model=model;
    self.titleLab.text = model.title;
    if (model.viewTimes>9999) {
        NSInteger qq=model.viewTimes/1000;
        CGFloat ff=qq/10;
      self.readNumLab.text=[NSString stringWithFormat:@"阅读%lf.1万",ff];
    }else{
        self.readNumLab.text=[NSString stringWithFormat:@"阅读%ld",model.viewTimes];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        if ([self.model.articleCategoryShortName isEqualToString:@"招标"]) {
          }else{
            self.model.readed=YES;
            self.model.viewTimes+=1;
            if (self.model.viewTimes>9999) {
                NSInteger qq=self.model.viewTimes/1000;
                CGFloat ff=qq/10;
                self.readNumLab.text=[NSString stringWithFormat:@"阅读%lf.1万",ff];
            }else{
                self.readNumLab.text=[NSString stringWithFormat:@"阅读%ld",self.model.viewTimes];
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
