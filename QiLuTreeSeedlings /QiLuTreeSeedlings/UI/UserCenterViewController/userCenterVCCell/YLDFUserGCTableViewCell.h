//
//  YLDFUserGCTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/23.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDFUserGCTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2W;
@property (weak, nonatomic) IBOutlet UIButton *wodedingdanBtn;
@property (weak, nonatomic) IBOutlet UIButton *fabuDingdanBtn;
@property (weak, nonatomic) IBOutlet UIButton *jingrenZLBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jjrRightL;
@property (weak, nonatomic) IBOutlet UIView *GCGSFBView;
@property (weak, nonatomic) IBOutlet UIView *GCGSDDView;
@property (weak, nonatomic) IBOutlet UIView *JJRView;
@property (weak, nonatomic) IBOutlet UIView *lineV;
+(YLDFUserGCTableViewCell *)yldFUserGCTableViewCell;
-(void)cellReoldAction;
@end
