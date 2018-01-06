//
//  YLDGroupTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/12/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDGroupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *groupImage;
@property (weak, nonatomic) IBOutlet UILabel *gooupTitle;
+(YLDGroupTableViewCell *)yldGroupTableViewCell;
@end
