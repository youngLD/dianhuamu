//
//  YLDRangeTextView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/26.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "BWTextView.h"
@protocol YLDRangeTextViewDelegate
@optional
-(void)textChangeNowLength:(NSInteger)length;
@end
@interface YLDRangeTextView : BWTextView
@property (nonatomic,assign)NSInteger rangeNumber;
@property (nonatomic,weak) id <YLDRangeTextViewDelegate> Rdelegate;
@end
