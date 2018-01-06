//
//  YLDTYXMQHomeView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/9/12.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLDTYXMQHomeViewDelegate // 必须实现的方法
@required
-(void)actionWithTag:(NSInteger)tag;
@optional
@end
@interface YLDTYXMQHomeView : UIView
@property (nonatomic,weak) id <YLDTYXMQHomeViewDelegate> delegate;
@end
