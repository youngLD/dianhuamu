//
//  YLDADClickCollectionViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/27.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDADClickCollectionViewCell.h"

@implementation YLDADClickCollectionViewCell
+(YLDADClickCollectionViewCell *)yldADClickCollectionViewCell
{
    YLDADClickCollectionViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDADClickCollectionViewCell" owner:self options:nil] firstObject];
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
