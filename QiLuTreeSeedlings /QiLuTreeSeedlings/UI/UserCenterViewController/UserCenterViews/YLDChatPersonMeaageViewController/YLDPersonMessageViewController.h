//
//  YLDPersonMessageViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/1/11.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDPersonMessageViewController : UIViewController
@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic)NSInteger from;
@property (nonatomic)BOOL isSender;
@property (nonatomic)NSString *senderID;
-(id)initWithFrom:(NSInteger)from withDic:(NSDictionary *)dic;
@end
