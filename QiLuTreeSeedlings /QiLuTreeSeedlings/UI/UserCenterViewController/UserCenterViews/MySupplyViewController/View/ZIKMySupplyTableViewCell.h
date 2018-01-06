//
//  ZIKMySupplyTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/22.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZIKSupplyModel;
@interface ZIKMySupplyTableViewCell : UITableViewCell
@property (weak, nonatomic  ) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic  ) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic  ) IBOutlet UILabel     *titleLabel;
@property (weak, nonatomic  ) IBOutlet UILabel     *countLabel;
@property (weak, nonatomic  ) IBOutlet UILabel     *priceLabel;
@property (weak, nonatomic  ) IBOutlet UILabel     *timeLabel;
@property (weak, nonatomic  ) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic  ) IBOutlet UIImageView *refreshImageView;
@property (weak, nonatomic  ) IBOutlet UILabel     *refreshLabel;
@property (nonatomic, assign) BOOL        isSelect;
- (void)configureCell:(ZIKSupplyModel *)model;
@end
