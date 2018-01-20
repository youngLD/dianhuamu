//
//  YLDFBuyFBViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/25.
//  Copyright © 2017年 中亿科技. All rights reserved.
//
#import "ZIKRightBtnSringViewController.h"
#import "BWTextView.h"
#import "YLDFBuyModel.h"
@protocol buyFabuDelegate
-(void)fabuSuccessWithbuyId:(NSDictionary *)buydic;
@end
@interface YLDFBuyFBViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet UIScrollView *backSV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet BWTextView *guigeTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UIButton *shangchejiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *daohuojiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *maimiaojiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *addAddressBtn;
@property (weak, nonatomic) IBOutlet UIImageView *addAddressBGImageV;
@property (weak, nonatomic) IBOutlet UIView *addBGV;
@property (weak, nonatomic) IBOutlet UIImageView *addLineV;
@property (weak, nonatomic) IBOutlet UILabel *addressPersonLab;
@property (weak, nonatomic) IBOutlet UILabel *addressPhoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *selectAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *fabuBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GGH;
@property (weak, nonatomic) IBOutlet UIView *YYBGView;
@property (weak, nonatomic) IBOutlet UIButton *YYPlayBtn;
@property (weak, nonatomic) IBOutlet UILabel *YYtimeLab;
@property (weak, nonatomic) IBOutlet UIImageView *YYPlayImageV;
@property (nonatomic,weak)id <buyFabuDelegate> delegate;
@property (nonatomic,copy) NSString *buyIdstr;
@property (nonatomic,strong)YLDFBuyModel *model;
@end
