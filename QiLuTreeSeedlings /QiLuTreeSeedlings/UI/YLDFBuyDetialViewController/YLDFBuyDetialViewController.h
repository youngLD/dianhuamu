//
//  YLDFBuyDetialViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/15.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKArrowViewController.h"
#import "YLDFBuyModel.h"
@interface YLDFBuyDetialViewController : ZIKArrowViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong)YLDFBuyModel *model;
@end
