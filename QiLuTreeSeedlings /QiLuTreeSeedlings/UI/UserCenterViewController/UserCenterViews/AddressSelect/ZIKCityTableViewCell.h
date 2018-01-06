//
//  ZIKCityTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"
#import "YLDPZInfo.h"
@interface ZIKCityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (nonatomic) BOOL isSelect;
@property (nonatomic) NSDictionary  *city;
@property (nonatomic)CityModel *model;
@property (nonatomic)YLDPZInfo *info;
@end
