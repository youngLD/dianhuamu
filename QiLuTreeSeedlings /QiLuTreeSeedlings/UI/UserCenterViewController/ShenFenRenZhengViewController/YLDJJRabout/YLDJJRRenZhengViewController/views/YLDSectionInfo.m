//
//  YLDSectionInfo.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/7.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSectionInfo.h"

@implementation YLDSectionInfo
-(void)setSelectNum:(NSInteger)selectNum {
    _selectNum = selectNum;
    if (_selectNum == 0 ) {
        self.headerView.selectHintLabel.hidden = YES;
        self.headerView.titleLable.textColor = titleLabColor;
        return;
    }
    self.headerView.selectHintLabel.hidden = NO;

    self.headerView.selectHintLabel.text = [NSString stringWithFormat:@"已选%ld项",(long)_selectNum];
    self.headerView.titleLable.textColor = NavColor;
    //    self.headerView.titleLable.textColor = Nav
}
@end
