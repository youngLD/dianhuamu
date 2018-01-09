//
//  YLDJJRenShenQing1ViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/1.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"
#import "YLDJJrModel.h"
@protocol YLDJJRenShenQing1ViewControllerDelegate
@optional
-(void)jjrTiJiaoSuccessWithDic:(NSDictionary *)dic;
@end
@interface YLDJJRenShenQing1ViewController : ZIKArrowViewController
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,copy)NSDictionary *dic;
@property (nonatomic,weak)id<YLDJJRenShenQing1ViewControllerDelegate> deleagte;
@end
