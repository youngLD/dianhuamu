//
//  YLDDDDMMTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/10/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLDDDDMMTableViewCellDelegate <NSObject>
@optional
-(void)chakanActionWithTag:(NSInteger)tag andDic:(NSDictionary *)dic;
@end
@interface YLDDDDMMTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bianhaoLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *shuomingLab;
@property (weak, nonatomic) IBOutlet UILabel *baojiaNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *backImgV;
@property (weak, nonatomic) IBOutlet UIImageView *lineImgV;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *chakanBtn;
@property (nonatomic,strong) NSDictionary *messageDic;
@property (nonatomic,weak)id<YLDDDDMMTableViewCellDelegate> delegate;
+(YLDDDDMMTableViewCell *)yldDDDMMTableViewCell;
+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;
@end
