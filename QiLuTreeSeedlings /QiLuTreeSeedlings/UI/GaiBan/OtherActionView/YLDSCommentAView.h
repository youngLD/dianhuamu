//
//  YLDSCommentAView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/21.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDSCommentAView : UIView
@property (nonatomic,strong)UIButton *shareBtn;
@property (nonatomic,strong)UIButton *collectBtn;
@property (nonatomic,strong)UIButton *commentBtn;
@property (nonatomic,strong)UIButton *fabiaoBtn;
@property (nonatomic,strong)UILabel *commentNumLab;
@property (nonatomic,strong)UILabel *commentLab;
@property (nonatomic,assign)NSInteger commentNum;
@end
