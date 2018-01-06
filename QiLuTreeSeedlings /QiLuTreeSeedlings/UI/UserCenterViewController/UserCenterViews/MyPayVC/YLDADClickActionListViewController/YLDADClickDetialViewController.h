//
//  YLDADClickDetialViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/28.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"

@interface YLDADClickDetialViewController : ZIKArrowViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *imageUrl;
@end
