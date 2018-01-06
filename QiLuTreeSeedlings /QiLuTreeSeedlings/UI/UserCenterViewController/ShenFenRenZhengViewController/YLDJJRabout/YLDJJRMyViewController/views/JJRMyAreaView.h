//
//  JJRMyAreaView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/26.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJRMyAreaView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
@property (weak, nonatomic) IBOutlet UILabel *wareLab;
@property (weak, nonatomic) IBOutlet UILabel *moLab;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
+(JJRMyAreaView *)jjrMyAreaView;
@end
