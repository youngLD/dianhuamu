//
//  YLDTabBar.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/8/7.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLDTabBar;

//自定义按钮点击事件代理
@protocol YLDTabBarViewDelegate <NSObject>

- (void) mainTabBarViewDidClick : (YLDTabBar *)hBTabBarView;


@end

@interface YLDTabBar : UITabBar
@property(nonatomic,weak) id<YLDTabBarViewDelegate> tabbarDelegate;
@end
