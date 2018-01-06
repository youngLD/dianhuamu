//
//  YLDJJRenShenQing2ViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/6.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"
#import "YLDRangeTextField.h"
@interface YLDJJRenShenQing2ViewController : ZIKArrowViewController
@property (weak, nonatomic) IBOutlet YLDRangeTextField *bankCardNField;
@property (weak, nonatomic) IBOutlet YLDRangeTextField *nameLab;
@property (weak, nonatomic) IBOutlet YLDRangeTextField *bankNameLab;

@property (nonatomic,copy) NSMutableDictionary *dic;
@property (nonatomic,assign) NSInteger type;
@end
