//
//  YLDPZListViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/7.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"
#import "ZIKCitySectionHeaderView.h"


@protocol YLDPZListViewControllerDelegate;
@interface YLDPZListViewController : ZIKRightBtnSringViewController<ZIKCitySectionHeaderViewDelegate>
/**
 *  已选择的城市
 */
@property (nonatomic) NSArray *citys;
/**
 *  地址选择delegate
 */
@property (nonatomic,weak) id <YLDPZListViewControllerDelegate> delegate;
/**
 *  地址选择样式（单选，多选）（目前只要求多选）
 */


@end
@protocol YLDPZListViewControllerDelegate <NSObject>

@required
/**
 *  地址选择必须实现方法
 *
 *  @param citysStr 选择的城市的code字符串
 */
- (void)selectpzInfo:(NSString *)pzStr;
@optional
-(void)selectpzModels:(NSArray *)ary;

@end
