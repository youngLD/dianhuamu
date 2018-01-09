//
//  YLDEngineeringOrderTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/9.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDEngineeringOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *EOrderNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageV;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *baojiaoTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *dingdanshuomingLab;
@property (weak, nonatomic) IBOutlet UILabel *pinzhongLab;
@property (weak, nonatomic) IBOutlet UIButton *zhankaiBtn;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageV;
+(YLDEngineeringOrderTableViewCell *)yldEngineeringOrderTableViewCell;
@end
