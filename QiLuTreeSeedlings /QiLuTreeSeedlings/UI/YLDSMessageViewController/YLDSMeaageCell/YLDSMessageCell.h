//
//  YLDSMessageCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/16.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDSMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *detialLab;
@property (weak, nonatomic) IBOutlet UILabel *unReadLab;
+(YLDSMessageCell *)yldSMessageCell;
-(void)setimage:(NSString *)image title:(NSString *)title detial:(NSString *)detial time:(NSString *)time unRead:(NSInteger)num;
@end
