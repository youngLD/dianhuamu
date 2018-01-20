//
//  YLDFSearchListViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/19.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YLDFSearchListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeViewH;
@property (weak, nonatomic) IBOutlet UIView *searchV;
@property (weak, nonatomic) IBOutlet UIButton *supplyBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *companyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *moveView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger searchType;
@property (nonatomic,copy)NSString *searchStr;
@property (nonatomic,strong)UIButton *nowtypeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *supplyBW;
@property (weak, nonatomic) IBOutlet UIView *areaView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaVH;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@end
