//
//  YLDFTopSearchView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/2.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLDFTopSearchViewDelegate <NSObject>
@optional
-(void)textFieldChangeVVWithStr:(NSString *)textStr;

@end
@interface YLDFTopSearchView : UIView
@property (nonatomic,weak) id<YLDFTopSearchViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *textField;
+(YLDFTopSearchView *)yldFTopSearchView;
-(void)setobss;
@end
