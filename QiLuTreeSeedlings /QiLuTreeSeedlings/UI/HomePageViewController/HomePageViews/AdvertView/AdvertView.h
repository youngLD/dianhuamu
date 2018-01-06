//
//  AdvertView.h
//  baba88
//
//  Created by JCAI on 15/7/20.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AdvertHeight        180

@protocol AdvertDelegate <NSObject>

- (void)advertPush:(NSInteger)index;

@end


@interface AdvertView : UITableViewCell

@property (nonatomic,weak) id<AdvertDelegate> delegate;


- (void)setAdInfoWithAry:(NSArray *)imageAry;

- (void)adStart;
- (void)adStop;

@end
