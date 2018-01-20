//
//  YLDShopListTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/20.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDFShopModel.h"
@class YLDShopListTableViewCell;
@protocol YLDShopListTableViewCellDelegate
-(void)shopCellChackBtnAction:(UIButton *)sender withCell:(YLDShopListTableViewCell *)cell;
-(void)goShopDetialWithModel:(YLDFShopModel *)model;
@end
@interface YLDShopListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *goShopBtn;
@property (weak, nonatomic) IBOutlet UIImageView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *jianjieLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jianjieLabH;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jjBottL;
@property (nonatomic,strong)YLDFShopModel *model;
@property (nonatomic,weak) id <YLDShopListTableViewCellDelegate> delegate;
+(YLDShopListTableViewCell *)yldShopListTableViewCell;
@end
