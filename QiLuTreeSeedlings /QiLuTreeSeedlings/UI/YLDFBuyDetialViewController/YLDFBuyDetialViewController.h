//
//  YLDFBuyDetialViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/15.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKRightBtnSringViewController.h"
#import "YLDFBuyModel.h"
@interface YLDFBuyDetialViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *baojiaBtn;
@property (nonatomic,strong)YLDFBuyModel *model;
@end
