//
//  YLDSAutherBigMessageCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/4/10.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDSAuthorModel.h"
@interface YLDSAutherBigMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageV;
@property (weak, nonatomic) IBOutlet UILabel *ylName;
@property (weak, nonatomic) IBOutlet UILabel *gsNumLab;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (strong, nonatomic)YLDSAuthorModel *model;
+(YLDSAutherBigMessageCell *)YLDSAutherBigMessageCell;
@end
