//
//  YLDHomeJJRCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/5/31.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDJJrModel.h"
#import "YLDTYXMQHomeView.h"
@protocol YLDHomeJJRCellDelegate // 必须实现的方法
@required
-(void)jjrActionWithModel:(YLDJJrModel *)model;
-(void)jjrListMoreAction;
-(void)yxmqActionWithTag:(NSInteger)tag;
@optional
@end
@interface YLDHomeJJRCell : UIView <UIScrollViewDelegate,YLDTYXMQHomeViewDelegate>
@property (nonatomic,strong)UIScrollView *backscrollview;
@property (nonatomic,strong)NSMutableArray *viewAry;
@property (nonatomic,strong)NSArray *modelAry;
@property (nonatomic,strong)YLDTYXMQHomeView *sqV;
@property (nonatomic,strong)UIView *hearView;
@property (nonatomic,strong)UILabel *hearlab;
@property (nonatomic,weak) id <YLDHomeJJRCellDelegate> delegate;
@end
