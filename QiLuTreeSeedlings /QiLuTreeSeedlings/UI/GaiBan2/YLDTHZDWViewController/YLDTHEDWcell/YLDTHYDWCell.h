//
//  YLDTHYDWCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/9/16.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDTHEDWModel.h"
@interface YLDTHYDWCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dizhiLab;
@property (strong, nonatomic)YLDTHEDWModel *model;
+(YLDTHYDWCell *)yldTHYDWCell;
@end
