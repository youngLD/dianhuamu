//
//  YLDFPickCityView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/26.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCityDao.h"
@protocol YLDFPickCityViewDelegate <NSObject>
-(void)selectSheng:(CityModel *)sheng shi:(CityModel *)shi xian:(CityModel *)xian zhen:(CityModel *)zhen;
@end
@interface YLDFPickCityView : UIView
@property (nonatomic,weak) id <YLDFPickCityViewDelegate> delegate;
-(void)showAction;
-(void)removeAction;
@end
