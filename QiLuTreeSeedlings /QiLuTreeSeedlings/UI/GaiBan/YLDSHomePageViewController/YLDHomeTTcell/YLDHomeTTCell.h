//
//  YLDHomeTTCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/3.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLDZBLmodel;
@class YLDZXLmodel;
@protocol YLDHomeTTCellDelegate
-(void)zbActionWithzbModel:(YLDZBLmodel *)model;
-(void)zxActionWithzxModel:(YLDZXLmodel *)model;
@end
@interface YLDHomeTTCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *TTimageV;
@property (weak, nonatomic) IBOutlet UIView *zhaobiaoV;
@property (weak, nonatomic) IBOutlet UIView *newsV;
@property (weak, nonatomic) IBOutlet UIImageView *fgImagV1;
@property (weak, nonatomic) IBOutlet UIImageView *fgImageV2;
@property (nonatomic,strong) UIButton *msnewsBtn;
@property (strong,nonatomic)NSTimer *timer;
@property (strong,nonatomic)NSTimer *timer2;
@property (nonatomic,weak) id<YLDHomeTTCellDelegate> delegate;
+(YLDHomeTTCell *)yldHomeTTCell;
-(void)celllll;
-(void)cellActionWithZBAry:(NSArray *)zbary withZXAry:(NSArray *)zxary;
@end
