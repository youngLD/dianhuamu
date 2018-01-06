//
//  YLDHomeMoreView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/8/17.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDHomeMoreView : UIView
@property (weak, nonatomic)  UIImageView *ImagView;
@property (weak, nonatomic)  UILabel *titleLab;
@property (weak, nonatomic)  UIButton *btn;
+(YLDHomeMoreView *)yldHomeMoreView;
@end
