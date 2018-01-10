//
//  YLDFMyEOrderItemsTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/10.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDFMyOrderItemsModel.h"
@protocol YLDFMyEOrderItemsTableViewCellDelegate
@optional
-(void)itemCloseActionWithModel:(YLDFMyOrderItemsModel *)model;
-(void)itemLookUpActionWithModel:(YLDFMyOrderItemsModel *)model;
@end
@interface YLDFMyEOrderItemsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mmNameLab;
@property (weak, nonatomic) IBOutlet UILabel *mmNumLab;
@property (weak, nonatomic) IBOutlet UILabel *guigeyaoqiuLab;
@property (weak, nonatomic) IBOutlet UILabel *personNumLab;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeBtnW;
@property (nonatomic,strong)YLDFMyOrderItemsModel *model;
@property (weak, nonatomic) IBOutlet UIView *BGV;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (nonatomic,weak)id <YLDFMyEOrderItemsTableViewCellDelegate> delegate;
+(YLDFMyEOrderItemsTableViewCell *)yldFMyEOrderItemsTableViewCell;
@end
