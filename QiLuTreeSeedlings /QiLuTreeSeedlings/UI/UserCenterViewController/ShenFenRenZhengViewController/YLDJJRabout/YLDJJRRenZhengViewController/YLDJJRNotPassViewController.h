//
//  YLDJJRNotPassViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/22.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"
@protocol YLDJJRNotPassViewControllerDelegate
@optional
-(void)shenheweitongguoChongxintijiaoDic:(NSDictionary *)dic WithwareStr:(NSString *)wareStr;
@end
@interface YLDJJRNotPassViewController : ZIKArrowViewController
@property (weak, nonatomic) IBOutlet UILabel *notPassLab;
@property (nonatomic,copy) NSString *wareStr;
@property (weak, nonatomic) IBOutlet UILabel *nicaiLab;
@property (copy,nonatomic)NSDictionary *dic;
@property (nonatomic,weak) id<YLDJJRNotPassViewControllerDelegate> delegate;
@end
