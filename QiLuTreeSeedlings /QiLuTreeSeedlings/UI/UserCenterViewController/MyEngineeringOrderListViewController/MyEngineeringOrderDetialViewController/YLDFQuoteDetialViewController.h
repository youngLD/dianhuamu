//
//  YLDFQuoteDetialViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/15.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"ZIKRightBtnSringViewController.h"
#import "YLDFQuoteModel.h"
@interface YLDFQuoteDetialViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet UIImageView *headerImageV;
@property (weak, nonatomic) IBOutlet UIButton *goShopBtn;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageV;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *guigeLab;
@property (weak, nonatomic) IBOutlet UIButton *goShopBtn2;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgeV;
@property (weak, nonatomic) IBOutlet UILabel *imageLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomL;
@property (nonatomic,strong) YLDFQuoteModel *model;
@end
