//
//  YLDSMessageCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/16.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSMessageCell.h"

@implementation YLDSMessageCell
+(YLDSMessageCell *)yldSMessageCell
{
    YLDSMessageCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDSMessageCell" owner:self options:nil] lastObject];
    cell.unReadLab.layer.masksToBounds=YES;
    cell.unReadLab.layer.cornerRadius=cell.unReadLab.frame.size.width/2;
    return cell;
}
-(void)setimage:(NSString *)image title:(NSString *)title detial:(NSString *)detial time:(NSString *)time unRead:(NSInteger)num
{
    [self.imageV setImage:[UIImage imageNamed:image]];
    self.titleLab.text=title;
    self.detialLab.text=detial;
    self.timeLab.text=time;
    if (num>0) {
        self.unReadLab.hidden=NO;
        if (num>99) {
           self.unReadLab.text=@"99";
        }else
        {
            self.unReadLab.text=[NSString stringWithFormat:@"%ld",num];
        }
    }else{
        self.unReadLab.hidden=YES;
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
