//
//  YLDSearchActionViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/3/8.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLDSearchActionVCDelegate <NSObject>
-(void)searchActionWithType:(NSInteger)searchType searchString:(NSString *)searchStr;
@end
@interface YLDSearchActionViewController : UIViewController
@property (nonatomic)NSInteger searchType;
@property (nonatomic,strong)UITextField *searchTextField;
@property (nonatomic,copy)NSString *searchStr;
@property (nonatomic,weak) id <YLDSearchActionVCDelegate> delegate;
@end
