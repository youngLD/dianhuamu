//
//  yYLDSPingLunSrView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/21.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWTextView.h"
#import "YLDSPingLunModel.h"
@protocol fabiaoDelgate<NSObject>
-(void)fabiaoActionWithStr:(NSString *)comment;
@end
@interface YLDSPingLunSrView : UIView
@property (nonatomic,strong) UIView *suruBackView;
@property (nonatomic,strong) BWTextView *textView;
@property (nonatomic,strong) UILabel *strLengthLab;
@property (nonatomic,strong) YLDSPingLunModel *huifumodel;
@property (nonatomic,weak) id <fabiaoDelgate> delegate;
-(void)showAction;
-(void)clearAvtion;
@end
