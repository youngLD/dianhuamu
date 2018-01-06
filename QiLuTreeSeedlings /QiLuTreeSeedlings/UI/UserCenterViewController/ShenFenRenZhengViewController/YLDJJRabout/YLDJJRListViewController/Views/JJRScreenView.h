//
//  JJRScreenView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/27.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDPickLocationView.h"
@protocol JJRScreenViewDelegate // 必须实现的方法
@required

-(void)screenActionWithAreaCode:(NSString *)areaCode WithName:(NSString *)name;
// 可选实现的方法
@optional


@end
@interface JJRScreenView : UIView<YLDPickLocationDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic,weak) id <JJRScreenViewDelegate> delegate;
+(JJRScreenView *)jjrScreenView;
-(void)showView;
@end
