//
//  YLDMYAccountCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/26.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDMYAccountCell : UITableViewCell
+(YLDMYAccountCell *)yldMYAccountCell;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detialLab;
@end
