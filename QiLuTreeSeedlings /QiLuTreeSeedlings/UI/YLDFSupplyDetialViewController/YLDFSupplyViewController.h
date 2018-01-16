//
//  YLDFSupplyViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/15.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKRightBtnSringViewController.h"
#import "YLDFSupplyModel.h"
@interface YLDFSupplyViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong)YLDFSupplyModel *model;
@end
