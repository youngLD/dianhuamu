//
//  UserBigInfoTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/11.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
@protocol UserBigInfoTableViewCellDelegate <NSObject>
- (void)clickedHeadImage;
@end
@interface UserBigInfoTableViewCell : UITableViewCell
@property (nonatomic,strong) UserInfoModel *model;
@property (nonatomic,strong) UIButton *collectBtn;
@property (nonatomic,strong) UIButton *interBtn;
@property (nonatomic,strong) UIButton *messageBtn;
@property (nonatomic,strong) UIButton *shengJiBtn;
@property (nonatomic, weak) id<UserBigInfoTableViewCellDelegate>userDelegate;

+(NSString *)IDstr;
@end
