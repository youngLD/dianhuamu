//
//  YLFMySupplyTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/27.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDFSupplyModel.h"
@protocol yldFMySupplyTableViewCellDelegate
-(void)mySupplyColseOrOpenWithModel:(YLDFSupplyModel *)model;
-(void)mySupplyRefreshWithModel:(YLDFSupplyModel *)model;
-(void)mySupplyEditWithModel:(YLDFSupplyModel *)model;
-(void)mySupplyDeleteWithModel:(YLDFSupplyModel *)model;
@end
@interface YLFMySupplyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *bsV1;
@property (weak, nonatomic) IBOutlet UIImageView *bsV2;
@property (weak, nonatomic) IBOutlet UIImageView *bsV3;
@property (weak, nonatomic) IBOutlet UIImageView *bsV4;
@property (weak, nonatomic) IBOutlet UIImageView *bsV5;
@property (weak, nonatomic) IBOutlet UIImageView *bsV6;
@property (weak, nonatomic) IBOutlet UIImageView *bsV7;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleW;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;
@property (weak, nonatomic) IBOutlet UIImageView *imageV1;
@property (weak, nonatomic) IBOutlet UIImageView *imageV3;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageV2W;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refreshBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refreshToEditL;
@property (weak, nonatomic)id <yldFMySupplyTableViewCellDelegate> deletgate;
@property (strong,nonatomic)YLDFSupplyModel *model;
@property (weak, nonatomic) IBOutlet UIButton *lineTotimeLabC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineW;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;
@property (nonatomic,strong)NSArray *imageAry;
+(YLFMySupplyTableViewCell *)yldFMySupplyTableViewCell;
+(YLFMySupplyTableViewCell *)yldFListSupplyTableViewCell;
@end
