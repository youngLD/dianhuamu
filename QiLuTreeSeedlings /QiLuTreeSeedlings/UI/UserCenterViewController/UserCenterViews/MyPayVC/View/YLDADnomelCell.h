//
//  YLDADnomelCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/26.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDADnomelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
+(YLDADnomelCell *)yldADnomelCell;
@end
