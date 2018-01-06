//
//  YLDADCDetialCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/28.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDADCDetialCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageVV;
@property (weak, nonatomic) IBOutlet UILabel *allClickNumLab;
@property (weak, nonatomic) IBOutlet UILabel *tadayClickNumLab;
+(YLDADCDetialCell *)yldADCDetialCell;
@end
