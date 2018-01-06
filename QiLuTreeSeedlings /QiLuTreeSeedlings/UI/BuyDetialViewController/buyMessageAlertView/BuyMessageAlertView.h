//
//  BuyMessageAlertView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/3.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDefines.h"
typedef void(^ActionClickIndexBlock)(NSInteger index);
@interface BuyMessageAlertView : UIView
@property (nonatomic,weak)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
+(BuyMessageAlertView *)addActionVieWithPrice:(NSString *)price AndMone:(NSString *)yue;
+(BuyMessageAlertView *)addActionVieWithReturnReason:(NSString *)reason;
+(BuyMessageAlertView *)addActionViewshuxin;
+(BuyMessageAlertView *)addActionViewMiaoPuWanShan;
+(BuyMessageAlertView *)addActionViewWithTitle:(NSString *)title andDetail:(NSString *)detail;
+(BuyMessageAlertView *)addActionVieWithMoney:(NSString *)money;
+(BuyMessageAlertView *)addActionVieWithMoney:(NSString *)money withPrice:(NSString *)price;
+(void)removeActionView;
@end
