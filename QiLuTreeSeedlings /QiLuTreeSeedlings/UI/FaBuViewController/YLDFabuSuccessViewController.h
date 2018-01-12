//
//  YLDFabuSuccessViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/23.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKArrowViewController.h"
@protocol YLDFabuSuccessDelegate
-(void)YLfabuSuccessWithSupplyDic:(NSDictionary *)supplydic;
-(void)YLfabuSuccessWithBuyDic:(NSDictionary *)buyDic;
-(void)YLfabuSuccessWithContinueType:(NSInteger)type;
-(void)YLfabuSuccessWithAdministrationType:(NSInteger)type;
@end
@interface YLDFabuSuccessViewController : ZIKArrowViewController

@property (weak, nonatomic) IBOutlet UIButton *fabuBtn;
@property (weak, nonatomic) IBOutlet UIButton *yulanBtn;
@property (weak, nonatomic) IBOutlet UIButton *guanliBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn2W;
@property (nonatomic,copy)NSDictionary *supplyDic;
@property (nonatomic,copy)NSDictionary *buyDic;
@property (nonatomic,copy)NSDictionary *orderDic;
@property (nonatomic,weak)id <YLDFabuSuccessDelegate> delegate;
@end
