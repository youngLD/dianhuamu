//
//  YLDGongZuoZhanJianJieCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDGongZuoZhanJianJieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jianjieLab;
@property (nonatomic,copy)NSString *jianjieStr;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
+(YLDGongZuoZhanJianJieCell *)yldGongZuoZhanJianJieCell;
@end
