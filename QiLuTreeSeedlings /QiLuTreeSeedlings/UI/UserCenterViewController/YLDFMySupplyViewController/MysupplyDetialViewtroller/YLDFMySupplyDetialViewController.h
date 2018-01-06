//
//  YLDFMySupplyDetialViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/3.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"
#import "YLDFSupplyModel.h"
@protocol YLDFmySupplyDetialViewControllerDelegate
-(void)mySupplyDetialColseOrOpenWithModel:(YLDFSupplyModel *)model;

@end
@interface YLDFMySupplyDetialViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet UIButton *shareBntAction;
@property (weak, nonatomic) IBOutlet UIButton *openOrCloseBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerW;
@property (nonatomic,copy) NSString *baseUrl;
@property (nonatomic,weak) YLDFSupplyModel *model;
@property (weak, nonatomic) id <YLDFmySupplyDetialViewControllerDelegate> delegate;
@end
