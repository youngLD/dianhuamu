//
//  YLDFMyBuyTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/2.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDFBuyModel.h"
@protocol YLDFMyBuyTableViewCellDelegate
-(void)myBuyColseOrOpenWithModel:(YLDFBuyModel *)model;
-(void)myBuyRefreshWithModel:(YLDFBuyModel *)model;
-(void)myBuyEditWithModel:(YLDFBuyModel *)model;
-(void)myBuyDeleteWithModel:(YLDFBuyModel *)model;
@end
@interface YLDFMyBuyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refreshBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refreshToEditL;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *guigeLab;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageV;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *openOrCloseBtn;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic,strong)YLDFBuyModel *model;
@property (weak, nonatomic)id <YLDFMyBuyTableViewCellDelegate> deletgate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LineToTimeLabC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIImageView *ShiMingV;
@property (weak, nonatomic) IBOutlet UIImageView *qiyeV;
@property (weak, nonatomic) IBOutlet UIImageView *jjrV;
@property (weak, nonatomic) IBOutlet UIImageView *YLHV;
@property (weak, nonatomic) IBOutlet UIImageView *GCV;
@property (weak, nonatomic) IBOutlet UIImageView *BSV6;
@property (weak, nonatomic) IBOutlet UIImageView *BSV7;
@property (nonatomic,strong) NSArray *imageVAry;
@property (weak, nonatomic) IBOutlet UIView *bottmLineV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabW;
+(YLDFMyBuyTableViewCell *)yldFMyBuyTableViewCell;
+(YLDFMyBuyTableViewCell *)yldFListBuyTableViewCell;
@end
