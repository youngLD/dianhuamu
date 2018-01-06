//
//  YLDFLoginView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/5.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDFLoginView : UIView
@property (weak, nonatomic) IBOutlet UITextField *userNameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *changePassTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fagertPassBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginActionBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxLoginActionBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
+(YLDFLoginView *)yldFLoginView;
@end
