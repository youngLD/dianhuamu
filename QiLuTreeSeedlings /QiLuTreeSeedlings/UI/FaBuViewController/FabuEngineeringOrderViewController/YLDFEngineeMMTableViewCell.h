//
//  YLDFEngineeMMTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/9.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLDFEngineeMMTableViewCellDelegate
@optional
-(void)mmCellDeleteWithDic:(NSMutableDictionary *)dic;
-(void)mmCellEditWithDic:(NSMutableDictionary *)dic;
@end
@interface YLDFEngineeMMTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *mmNameLab;
@property (weak, nonatomic) IBOutlet UILabel *mmNumLab;
@property (weak, nonatomic) IBOutlet UILabel *demadLab;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageV;
@property (nonatomic,strong)NSMutableDictionary *dic;
@property (nonatomic,weak)id<YLDFEngineeMMTableViewCellDelegate> delegate;
+(YLDFEngineeMMTableViewCell *)yldFEngineeMMTableViewCell;
@end
