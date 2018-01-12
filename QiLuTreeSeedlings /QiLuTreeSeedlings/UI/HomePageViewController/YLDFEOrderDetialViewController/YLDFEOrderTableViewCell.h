//
//  YLDFEOrderTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/12.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDFMyOrderItemsModel.h"
@protocol YLDFEOrderTableViewCellDelegate
@optional
-(void)itemBaojiaActionWithModel:(YLDFMyOrderItemsModel *)model;

@end
@interface YLDFEOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *mmNumLab;
@property (weak, nonatomic) IBOutlet UILabel *guigeLab;
@property (weak, nonatomic) IBOutlet UIView *BGV;
@property (weak, nonatomic) IBOutlet UIButton *baojiaBtn;
@property (nonatomic,strong)YLDFMyOrderItemsModel *model;
@property (nonatomic,weak)id <YLDFEOrderTableViewCellDelegate> delegate;
+(YLDFEOrderTableViewCell *)yldFEOrderTableViewCell;
@end
