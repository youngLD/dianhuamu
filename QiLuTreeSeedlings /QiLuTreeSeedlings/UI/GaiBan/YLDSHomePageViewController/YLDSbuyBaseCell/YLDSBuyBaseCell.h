//
//  YLDSBuyBaseCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/1/12.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDSbuyBaseView.h"
#import "YLDSBuyADView.h"
#import "HotBuyModel.h"
#import "YLDSadvertisementModel.h"
@protocol YLDSBuyBaseDelegate // 必须实现的方法
@required
-(void)actionWithbuyModel:(HotBuyModel *)model;
-(void)actionWithadModel:(YLDSadvertisementModel *)model;
@optional

@end
@interface YLDSBuyBaseCell : UITableViewCell
@property (nonatomic,strong)YLDSbuyBaseView *view1;
@property (nonatomic,strong)YLDSbuyBaseView *view2;
@property (nonatomic,strong)YLDSBuyADView *adview1;
@property (nonatomic,strong)YLDSBuyADView *adview2;
@property (nonatomic,strong) HotBuyModel *model1;
@property (nonatomic,strong) HotBuyModel *model2;
@property (nonatomic,strong) YLDSadvertisementModel *admodel1;
@property (nonatomic,strong) YLDSadvertisementModel *admodel2;
@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) UIButton *btn2;
@property (nonatomic)        BOOL isRead;
@property (nonatomic,weak) id<YLDSBuyBaseDelegate> delegate;
+(YLDSBuyBaseCell *)yldSBuyBaseCell;
@end
