//
//  YLDADACYuECell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/26.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDADACYuECell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *yuELab;
@property (weak, nonatomic) IBOutlet UIButton *chongzhiBtn;
@property (weak, nonatomic) IBOutlet UILabel *zensongLab;
+(YLDADACYuECell *)yldADACYuECell;
@end
