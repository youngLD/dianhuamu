//
//  YLDFHomeScrollTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/16.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDFHomeScrollTableViewCell : UITableViewCell
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong,nonatomic) NSMutableArray *tableViewAry;
@property (assign,nonatomic)NSInteger lastType;
@end
