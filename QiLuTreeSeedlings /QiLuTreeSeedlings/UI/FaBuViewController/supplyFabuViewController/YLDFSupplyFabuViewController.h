//
//  YLDFSupplyFabuViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/20.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKRightBtnSringViewController.h"
#import "BWTextView.h"
#import "YLDFSupplyModel.h"
@protocol supplyFabuDelegate
-(void)fabuSuccessWithSupplyId:(NSDictionary *)supplydic;
@end
@interface YLDFSupplyFabuViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteImage1Btn;
@property (weak, nonatomic) IBOutlet UIButton *deleteImage2Btn;
@property (weak, nonatomic) IBOutlet UIButton *deleteImage3Btn;
@property (weak, nonatomic) IBOutlet BWTextView *guigeTextView;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn1;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn2;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1H;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet BWTextView *keyWordTextView;
@property (weak, nonatomic) IBOutlet UIButton *selectAddressBtn;
@property (weak, nonatomic) IBOutlet UILabel *personNameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *addAddressBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn2W;
@property (weak, nonatomic) IBOutlet UIImageView *imageV1;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;
@property (weak, nonatomic) IBOutlet UIImageView *imageV3;
@property (weak, nonatomic) IBOutlet UIButton *fabuActionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *lineV;
@property (weak, nonatomic) IBOutlet UIImageView *addressBGV;
@property (weak, nonatomic) IBOutlet UIView *noAddresssBV;
@property (nonatomic,copy) NSString *supplyId;
@property (nonatomic,strong)YLDFSupplyModel *model;
@property (nonatomic,weak)id <supplyFabuDelegate> delegate;
@end
