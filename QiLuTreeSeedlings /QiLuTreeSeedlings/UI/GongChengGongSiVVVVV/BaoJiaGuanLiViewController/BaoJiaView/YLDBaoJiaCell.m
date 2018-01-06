//
//  YLDBaoJiaCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDBaoJiaCell.h"
#import "UIDefines.h"
@implementation YLDBaoJiaCell
+(YLDBaoJiaCell *)yldBaoJiaCell
{
    YLDBaoJiaCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDBaoJiaCell" owner:self options:nil] lastObject];
    return cell;
}
-(void)setModel:(YLDBaoModel *)model
{
    _model=model;
    self.titleLabx.text=model.orderName;
    self.nameMiaoMuLab.text=model.name;
    self.areaLab.text=model.area;
        self.numLab.text=[NSString stringWithFormat:@"%@棵(株)",model.quantity];
    
    
    CGRect frame=self.frame;
    self.timeLab.text=model.endDate;
    NSString *stsada;
    if (model.descriptions.length>0) {
        stsada=[NSString stringWithFormat:@"苗木说明：%@",model.descriptions];
    }else{
        stsada=@"苗木说明：";
    }
    CGFloat hieghtss=[self getHeightWithContent:stsada width:kWidth-20 font:14];
    if (hieghtss>25) {
        frame.size.height = 150-10 +hieghtss;
    }else
    {
       frame.size.height =  150;
    }
    self.frame=frame;
    self.shuomingLab.text=stsada;
    if ([model.status integerValue]==1) {
        [self.statusV setImage:[UIImage imageNamed:@"Gyibaojia"]];
    }
    if ([model.status integerValue]==2) {
        [self.statusV setImage:[UIImage imageNamed:@"Gyihezuo"]];
    }
    if ([model.status integerValue]==3) {
        [self.statusV setImage:[UIImage imageNamed:@"Gyichakan"]];
    }
    if ([model.status integerValue]==4) {
        [self.statusV setImage:[UIImage imageNamed:@"Gyiguoqi"]];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
