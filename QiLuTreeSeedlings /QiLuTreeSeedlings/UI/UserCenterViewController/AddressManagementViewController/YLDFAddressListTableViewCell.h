//
//  YLDFAddressListTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/12.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDFAddressModel.h"
@protocol YLDFAddressListTableViewCellDelegate // 必须实现的方法
-(void)addressEditWithModel:(YLDFAddressModel *)model;
-(void)addressDeleteWithModel:(YLDFAddressModel *)model;
-(void)addressSelectWithModel:(YLDFAddressModel *)model;
@required

@end
@interface YLDFAddressListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *lineV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic,strong) YLDFAddressModel *model;
@property (weak,nonatomic) id <YLDFAddressListTableViewCellDelegate> delegate;
+(YLDFAddressListTableViewCell *)yldFAddressListTableViewCell;
@end
