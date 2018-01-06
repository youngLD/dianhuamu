//
//  YLDSPingLunCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/24.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDSPingLunModel.h"
@protocol YLDSPingLunCellDelgate<NSObject>
-(void)zanActionWith:(UIButton *)sender Uid:(YLDSPingLunModel *)model;
-(void)deleteActionWithModel:(YLDSPingLunModel *)model;
@end
@interface YLDSPingLunCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *commentLab;
@property (nonatomic,strong) YLDSPingLunModel *model;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic,weak) id<YLDSPingLunCellDelgate> delgate;
+(YLDSPingLunCell *)yldSPingLunCell;
@end
