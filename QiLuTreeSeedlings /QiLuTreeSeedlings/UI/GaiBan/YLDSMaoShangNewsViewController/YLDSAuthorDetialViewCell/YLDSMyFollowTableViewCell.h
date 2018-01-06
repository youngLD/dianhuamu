//
//  YLDSMyFollowTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/4/11.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDSAuthorModel.h"
@interface YLDSMyFollowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *remakeLab;
@property (weak, nonatomic) IBOutlet UIImageView *sfImageV;
@property (nonatomic,strong)YLDSAuthorModel *model;
+(YLDSMyFollowTableViewCell *)yldSMyFollowTableViewCell;
@end
