//
//  YLDSJMCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/14.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKFunction.h"
@protocol YLDSJMCellDelegate
-(void)JMActionWithDic:(NSDictionary *)dic;
@end
@interface YLDSJMCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *fengeV;
@property (weak, nonatomic) id <YLDSJMCellDelegate> delegate;
+(YLDSJMCell *)yldSJMCell;
-(void)cellActionWithAry:(NSArray *)ary;
@end
