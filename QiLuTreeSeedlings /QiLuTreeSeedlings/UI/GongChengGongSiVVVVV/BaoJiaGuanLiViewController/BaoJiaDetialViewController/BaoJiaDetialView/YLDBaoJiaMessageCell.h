//
//  YLDBaoJiaMessageCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDBaoJiaMessageModel.h"
@protocol YLDBaoJiaMessageCellDelegate <NSObject>
@optional
-(void)actionWithtype:(NSInteger)type andModel:(YLDBaoJiaMessageModel *)model;
@end
@interface YLDBaoJiaMessageCell : UITableViewCell
@property (nonatomic,weak) id<YLDBaoJiaMessageCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *backV;
@property (weak, nonatomic) IBOutlet UIImageView *shenfenImagV;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *hezuoActionBtn;
@property (weak, nonatomic) IBOutlet UILabel *lianxirenLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lianxirenWi;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UITextView *shuomingTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV1;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;
@property (weak, nonatomic) IBOutlet UIImageView *imageV3;
@property (weak, nonatomic) IBOutlet UIImageView *kLineV;
@property (nonatomic,strong)YLDBaoJiaMessageModel *model;
+(YLDBaoJiaMessageCell *)ylBdaoJiaMessageCell;
+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;
@end
