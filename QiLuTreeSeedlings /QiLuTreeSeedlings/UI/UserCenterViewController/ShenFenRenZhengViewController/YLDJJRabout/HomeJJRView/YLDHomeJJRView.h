//
//  YLDHomeJJRView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/5/26.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDHomeJJRView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *hicImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *llLab;
@property (weak, nonatomic) IBOutlet UILabel *zhuyingLab;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
+(YLDHomeJJRView *)yldHomeJJRView;
@end
