//
//  YLDFBaoJiaView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/13.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDRangeTextField.h"
#import "YLDFMyOrderItemsModel.h"
@protocol YLDFBaoJiaViewCellDelegate
@optional
-(void)itemsBaojiaActionWithModel:(YLDFMyOrderItemsModel *)model withDic:(NSDictionary *)dic;

@end
@interface YLDFBaoJiaView : UIView<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet YLDRangeTextField *baojiaTextField;
@property (weak, nonatomic) IBOutlet YLDRangeTextField *guigeTextField;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIButton *baojiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *guanbiBtn;
@property (nonatomic,copy)NSString *imageUrl;
@property (nonatomic,weak) UIViewController *controller;
@property (nonatomic,strong)YLDFMyOrderItemsModel *model;
@property (nonatomic,weak)id <YLDFBaoJiaViewCellDelegate> delegate;
+(YLDFBaoJiaView *)yldFBaoJiaView;
-(void)show;
@end
