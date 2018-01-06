//
//  YLDJJRD1TableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/9.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDJJrModel.h"
@interface YLDJJRD1TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *txImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *zhuyingLab;
@property (weak, nonatomic) IBOutlet UILabel *ziwoJSV;
@property (weak, nonatomic) IBOutlet UILabel *llLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *JSH;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (nonatomic,strong) YLDJJrModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jsBH;

+(YLDJJRD1TableViewCell *)yldJJRD1TableViewCell;
@end
