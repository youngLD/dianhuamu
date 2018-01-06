//
//  YLDFUCSUpplyOrBuyInfoTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/9.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDFUCSUpplyOrBuyInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *mySupplyBtn;
@property (weak, nonatomic) IBOutlet UIButton *fabuSupplyBtn;
@property (weak, nonatomic) IBOutlet UIButton *myBuyBtn;
@property (weak, nonatomic) IBOutlet UIButton *fabuBuyBtn;
@property (weak, nonatomic) IBOutlet UIButton *myBaojiaBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *View2W;
+(YLDFUCSUpplyOrBuyInfoTableViewCell *)yldFUCSUpplyOrBuyInfoTableViewCell;
@end
