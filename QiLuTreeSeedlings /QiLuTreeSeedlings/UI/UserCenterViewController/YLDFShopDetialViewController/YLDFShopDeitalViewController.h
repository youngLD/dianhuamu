//
//  YLDFShopDeitalViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/17.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDFShopModel.h"
@interface YLDFShopDeitalViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareW;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIButton *back2Btn;
@property (nonatomic,strong)YLDFShopModel *model;
@end
