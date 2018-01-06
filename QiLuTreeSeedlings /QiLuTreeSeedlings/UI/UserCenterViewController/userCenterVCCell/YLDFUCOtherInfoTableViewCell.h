//
//  YLDFUCOtherInfoTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/9.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDFUCOtherInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerWidth;
@property (weak, nonatomic) IBOutlet UIButton *myCollectBtn;
@property (weak, nonatomic) IBOutlet UIButton *myPayListBtn;
@property (weak, nonatomic) IBOutlet UIButton *myPingLunBtn;
@property (weak, nonatomic) IBOutlet UIButton *shenfenRZBtn;
@property (weak, nonatomic) IBOutlet UIButton *biaoshiRZBtn;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *center2Width;
+(YLDFUCOtherInfoTableViewCell *)yldFUCOtherInfoTableViewCell;
@end
