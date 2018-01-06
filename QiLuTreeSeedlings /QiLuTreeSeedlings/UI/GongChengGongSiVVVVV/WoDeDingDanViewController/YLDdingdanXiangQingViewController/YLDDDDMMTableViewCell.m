//
//  YLDDDDMMTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/10/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDDDDMMTableViewCell.h"
#import "UIDefines.h"
@implementation YLDDDDMMTableViewCell
+(YLDDDDMMTableViewCell *)yldDDDMMTableViewCell
{
    YLDDDDMMTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDDDDMMTableViewCell" owner:self options:nil]lastObject];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backImgV.image=[YLDDDDMMTableViewCell  imageWithSize:cell.backImgV.frame.size borderColor:NavColor borderWidth:1];
    cell.bianhaoLab.layer.masksToBounds=YES;
    cell.bianhaoLab.layer.cornerRadius=2;
    cell.backImgV.layer.masksToBounds=YES;
    cell.backImgV.layer.cornerRadius=3;
    return cell;
}
-(void)setMessageDic:(NSDictionary *)messageDic
{
    _messageDic=messageDic;
    self.nameLab.text=messageDic[@"name"];
    
    NSString *unit=messageDic[@"unit"];
    if (unit.length>0) {
        self.numLab.text=[NSString stringWithFormat:@"%@%@",messageDic[@"quantity"],unit];
    }else{
        self.numLab.text=[NSString stringWithFormat:@"%@",messageDic[@"quantity"]];
    }
    NSString *shuomingStr=messageDic[@"description"];
    if (shuomingStr.length!=0) {
        self.shuomingLab.text=[NSString stringWithFormat:@"规格要求：%@",messageDic[@"description"]];
    }else{
        self.shuomingLab.text=@"规格要求：";
    }
    [self.shuomingLab sizeToFit];
    NSString *stauts=[messageDic objectForKey:@"stauts"];
    if (self.chakanBtn) {
        if ([stauts integerValue]==1||[stauts integerValue]==2) {
            
            self.chakanBtn.tag=1;
            [self.chakanBtn addTarget:self action:@selector(chakanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            if ([stauts integerValue]==1) {
                [self.chakanBtn setBackgroundColor:NavYellowColor];
                [self.chakanBtn setTitle:@"查看报价" forState:UIControlStateNormal];
            }else
            {
                [self.chakanBtn setBackgroundColor:NavColor];
                [self.chakanBtn setTitle:@"部分合作" forState:UIControlStateNormal];
            }
            
        }
        if ([stauts integerValue]==3) {
            [self.chakanBtn setBackgroundColor:NavColor];
            [self.chakanBtn setTitle:@"已合作" forState:UIControlStateNormal];
            self.chakanBtn.tag=3;
            [self.chakanBtn addTarget:self action:@selector(chakanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([stauts integerValue]==4) {
            [self.chakanBtn setBackgroundColor:[UIColor colorWithRed:64/255.f green:204/255.f blue:246/255.f alpha:1]];
            self.chakanBtn.tag=4;
            [self.chakanBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [self.chakanBtn addTarget:self action:@selector(chakanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    self.baojiaNumLab.text=[NSString stringWithFormat:@"%@条",messageDic[@"quotecount"]];
    self.deleteBtn.tag=5;
    [self.deleteBtn addTarget:self action:@selector(chakanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)chakanBtnAction:(UIButton *)sender
{
    if (self.delegate) {
        [self.delegate chakanActionWithTag:sender.tag andDic:self.messageDic];
    }
}
+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = {1.5, 0.3};
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 1.0);
    CGContextAddLineToPoint(context, size.width, 1.0);
    CGContextAddLineToPoint(context, size.width, size.height-2);
    CGContextAddLineToPoint(context, 0, size.height-2);
    CGContextAddLineToPoint(context, 0.0, 1.0);
    CGContextStrokePath(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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
