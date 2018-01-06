//
//  YLDSbuyBaseView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/1/12.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDSbuyBaseView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *shenfenImagV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UIImageView *sfpic;
@property (weak, nonatomic) IBOutlet UIImageView *fengeI;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLW;
@property (weak, nonatomic) IBOutlet UILabel *danweiLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shenfenVW;
+(YLDSbuyBaseView *)yldSbuyBaseView;
+(UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;
@end
