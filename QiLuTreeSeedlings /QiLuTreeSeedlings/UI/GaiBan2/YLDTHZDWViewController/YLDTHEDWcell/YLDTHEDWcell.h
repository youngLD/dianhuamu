//
//  YLDTHEDWcell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/9/15.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDTHEDWModel.h"
@interface YLDTHEDWcell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dizhiLab;
@property (weak, nonatomic) IBOutlet UIImageView *iamgeV1;
@property (weak, nonatomic) IBOutlet UIImageView *iamgeV2;
@property (strong, nonatomic)YLDTHEDWModel *model;
+(YLDTHEDWcell *)yldTHEDWcell;
@end
