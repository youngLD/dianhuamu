//
//  YLDSBuyBrifTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/3/1.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDSBuyBrifTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV1;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;
@property (weak, nonatomic) IBOutlet UIImageView *imageV3;
@property (weak, nonatomic) IBOutlet UILabel *birfLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageVW1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageVW2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageVW3;
+(YLDSBuyBrifTableViewCell *)yldSBuyBrifTableViewCell;
@end
