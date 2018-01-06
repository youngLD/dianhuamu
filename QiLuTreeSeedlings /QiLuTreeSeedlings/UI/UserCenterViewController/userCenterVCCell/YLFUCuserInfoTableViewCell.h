//
//  YLFUCuserInfoTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/9.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLFUCuserInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *userHeardBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIButton *userInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *companyInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *shopBtn;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLine;
@property (weak, nonatomic) IBOutlet UIImageView *userImageV;
@property (weak, nonatomic) IBOutlet UIButton *loginAndUserInfoBtn;

+(YLFUCuserInfoTableViewCell *)yldFUCuserInfoTableViewCell;
-(void)reloadselfInfo;
@end
