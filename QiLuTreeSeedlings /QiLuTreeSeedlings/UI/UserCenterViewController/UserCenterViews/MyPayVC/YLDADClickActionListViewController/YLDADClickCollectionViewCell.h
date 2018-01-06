//
//  YLDADClickCollectionViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/27.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDADClickCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageVV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
+(YLDADClickCollectionViewCell *)yldADClickCollectionViewCell;
@end
