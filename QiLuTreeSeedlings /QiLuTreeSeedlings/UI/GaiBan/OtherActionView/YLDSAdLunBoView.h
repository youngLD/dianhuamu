//
//  YLDSAdLunBoView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/24.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLDSAdLunBoViewDelegate <NSObject>

- (void)advertPush:(NSInteger)index andobject:(id)object;

@end
@interface YLDSAdLunBoView : UIView
@property (nonatomic) id<YLDSAdLunBoViewDelegate> delegate;


- (void)setAdInfoWithAry:(NSArray *)imageAry;

- (void)adStart;
- (void)adStop;

@end
