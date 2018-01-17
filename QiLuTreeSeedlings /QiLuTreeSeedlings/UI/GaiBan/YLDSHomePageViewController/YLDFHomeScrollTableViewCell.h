//
//  YLDFHomeScrollTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/16.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLDFHomeScrollTableViewCellDelegate
-(void)scrollViewEndWithIndex:(NSInteger )index;
-(void)scrollViewSelectWithModel:(id)model;
@end
@interface YLDFHomeScrollTableViewCell : UITableViewCell
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong,nonatomic) NSMutableArray *tableViewAry;
@property (assign,nonatomic)NSInteger lastType;
@property (nonatomic,strong) NSArray *firstAry;
@property (nonatomic,assign) NSInteger scrollEnable;
@property (nonatomic,assign) NSInteger actionIndex;
@property (nonatomic,weak) id <YLDFHomeScrollTableViewCellDelegate> delegate;
@end
