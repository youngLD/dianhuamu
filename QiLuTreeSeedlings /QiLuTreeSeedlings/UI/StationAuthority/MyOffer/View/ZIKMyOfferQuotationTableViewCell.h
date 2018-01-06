//
//  ZIKMyOfferQuotationTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 2016/10/11.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZIKMyOfferQuoteListModel;
@interface ZIKMyOfferQuotationTableViewCell : UITableViewCell
@property (nonatomic,strong)ZIKMyOfferQuoteListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(ZIKMyOfferQuoteListModel *)model;
@end
