//
//  YLDFDeleteOrRefreshView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/2.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDFDeleteOrRefreshView : UIView
@property (weak, nonatomic) IBOutlet UIButton *colseBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerW;
+(YLDFDeleteOrRefreshView *)yldFDeleteOrRefreshView;
@end
