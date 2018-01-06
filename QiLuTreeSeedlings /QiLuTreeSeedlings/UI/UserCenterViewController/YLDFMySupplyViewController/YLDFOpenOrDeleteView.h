//
//  YLDFOpenOrDeleteView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/2.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDFOpenOrDeleteView : UIView
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
+(YLDFOpenOrDeleteView *)yldFOpenOrDeleteView;
@end
