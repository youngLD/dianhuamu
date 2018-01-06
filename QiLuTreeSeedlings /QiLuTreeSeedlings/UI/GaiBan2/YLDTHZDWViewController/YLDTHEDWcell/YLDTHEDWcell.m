//
//  YLDTHEDWcell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/9/15.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDTHEDWcell.h"
#import "UIDefines.h"
#import "ZIKFunction.h"
@implementation YLDTHEDWcell
+(YLDTHEDWcell *)yldTHEDWcell
{
    YLDTHEDWcell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDTHEDWcell" owner:self options:nil] firstObject];
    
    
    return cell;
}
-(void)setModel:(YLDTHEDWModel *)model{
    _model=model;
    self.nameLab.text=model.name;
    self.dizhiLab.text=model.address;

    CGSize titleSize = [model.name sizeWithFont:[UIFont systemFontOfSize:21] constrainedToSize:CGSizeMake(MAXFLOAT, 26)];
    CGRect nameFrame=self.nameLab.frame;
    CGRect imageV1Frame=self.iamgeV1.frame;
    CGRect imageV2Frame=self.iamgeV2.frame;
    NSRange range1 = [model.recommendType rangeOfString:@"0"];
    NSRange range2 = [model.recommendType rangeOfString:@"1"];
    CGFloat ww=kWidth;
    if (!model.recommendType) {
        range1.location=NSNotFound;
        range1.location=NSNotFound;
    }
    if (range1.location!=NSNotFound&&range2.location!=NSNotFound) {
        if (titleSize.width>ww-110-20) {
            nameFrame.size.width=ww-130;
            
        }else{
            nameFrame.size.width=titleSize.width;
        }
        [self.nameLab setFrame:nameFrame];
        imageV1Frame.origin.x=CGRectGetMaxX(nameFrame);
        imageV2Frame.origin.x=CGRectGetMaxX(imageV1Frame)+5;
        self.iamgeV1.frame=imageV1Frame;
        self.iamgeV2.frame=imageV2Frame;
        [self.iamgeV1 setImage:[UIImage imageNamed:@"PTTJ"]];
        [self.iamgeV2 setImage:[UIImage imageNamed:@"XHTJ"]];
    }else if (range1.location!=NSNotFound) {
        if (titleSize.width>ww-55-20) {
            nameFrame.size.width=ww-75;
            [self.nameLab setFrame:nameFrame];
        }else{
            nameFrame.size.width=titleSize.width;
        }
        self.nameLab.frame=nameFrame;
        imageV1Frame.origin.x=CGRectGetMaxX(nameFrame)+5;
        self.iamgeV1.frame=imageV1Frame;

        [self.iamgeV1 setImage:[UIImage imageNamed:@"PTTJ"]];
        [self.iamgeV2 setImage:nil];
    }else if (range2.location!=NSNotFound) {
        if (titleSize.width>ww-55-20) {
            nameFrame.size.width=ww-75;
            [self.nameLab setFrame:nameFrame];
        }else{
            nameFrame.size.width=titleSize.width;
        }
        [self.nameLab setFrame:nameFrame];
        imageV1Frame.origin.x=CGRectGetMaxX(nameFrame)+5;
        self.iamgeV1.frame=imageV1Frame;
        
        [self.iamgeV1 setImage:[UIImage imageNamed:@"XHTJ"]];
        [self.iamgeV2 setImage:nil];
    }else
    {
        if (titleSize.width>ww-10) {
            nameFrame.size.width=ww-10;
            [self.nameLab setFrame:nameFrame];
        }else{
            nameFrame.size.width=titleSize.width;
        }
        [self.nameLab setFrame:nameFrame];
        [self.iamgeV1 setImage:nil];
        [self.iamgeV2 setImage:nil];
        
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
