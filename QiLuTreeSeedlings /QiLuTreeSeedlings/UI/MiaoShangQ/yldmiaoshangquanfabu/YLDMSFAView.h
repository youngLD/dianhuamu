//
//  YLDMSFAView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/5/22.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLDMSFAViewDelegate <NSObject>

- (void)deleteimagewithindex:(NSInteger)index;

@end
@interface YLDMSFAView : UIView
@property (nonatomic,strong)UIImageView *imageV;
@property (nonatomic,weak)id <YLDMSFAViewDelegate> delegate;
@end
