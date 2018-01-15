//
//  YLDFUserGCTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/23.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFUserGCTableViewCell.h"
#import "UIDefines.h"
@implementation YLDFUserGCTableViewCell
+(YLDFUserGCTableViewCell *)yldFUserGCTableViewCell
{
    YLDFUserGCTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDFUserGCTableViewCell" owner:self options:nil] firstObject];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)cellReoldAction
{
    if ([APPDELEGATE.userModel.roles containsObject:@"engineering_company"]&&[APPDELEGATE.userModel.roles containsObject:@"broker"]) {
        self.JJRView.hidden=NO;
        self.GCGSDDView.hidden=NO;
        self.GCGSFBView.hidden=NO;
        self.jjrRightL.constant=kWidth/3*2;
        self.JJRW.constant=kWidth/3;
        self.lineV.hidden=NO;
        self.ffVVV.hidden=NO;
        [self.lineV setBackgroundColor:kLineColor];
    }else if ([APPDELEGATE.userModel.roles containsObject:@"engineering_company"])
    {
        self.JJRView.hidden=YES;
        self.GCGSDDView.hidden=NO;
        self.GCGSFBView.hidden=NO;
        self.jjrRightL.constant=kWidth/3*2;
        [self.lineV setBackgroundColor:[UIColor whiteColor]];
        self.ffVVV.hidden=NO;
    }else if ([APPDELEGATE.userModel.roles containsObject:@"broker"])
    {
        self.JJRView.hidden=NO;
        self.GCGSDDView.hidden=YES;
        self.GCGSFBView.hidden=YES;
        self.jjrRightL.constant=0;
        self.JJRW.constant=kWidth/3;
        self.ffVVV.hidden=YES;
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.view2W.constant=kWidth/3;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
