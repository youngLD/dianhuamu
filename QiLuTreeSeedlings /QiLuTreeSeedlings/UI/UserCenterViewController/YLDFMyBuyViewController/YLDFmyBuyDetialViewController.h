//
//  YLDFmyBuyDetialViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/3.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"
#import "YLDFBuyModel.h"
@protocol YLDFmyBuyDetialViewControllerDelegate
-(void)myBuyDetialColseOrOpenWithModel:(YLDFBuyModel *)model;

@end
@interface YLDFmyBuyDetialViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) YLDFBuyModel *model;
@property (nonatomic,strong) YLDFBuyModel *deltalModel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerW;
@property (weak, nonatomic) IBOutlet UIButton *openOrCloseBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (nonatomic,copy) NSString *baseUrl;
@property (weak, nonatomic) id <YLDFmyBuyDetialViewControllerDelegate> delegate;
@end
