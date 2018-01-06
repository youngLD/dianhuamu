//
//  YLDSectionInfo.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/7.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIKCitySectionHeaderView.h"
@interface YLDSectionInfo : NSObject
@property (nonatomic,assign)BOOL open;
@property (nonatomic,assign)NSInteger selectNum;
@property (nonatomic,copy) NSString *typeUid;
@property (nonatomic,copy) NSString *typeName;
@property (nonatomic,strong)NSArray *pzAry;
@property (nonatomic,strong)ZIKCitySectionHeaderView *headerView;
@end
