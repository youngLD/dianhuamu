//
//  YLDFSystemMessageView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/5.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFSystemMessageView.h"
#import "YLDFSystemMessageTableViewCell.h"
@interface YLDFSystemMessageView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataAry;
@end
@implementation YLDFSystemMessageView
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.dataAry=[NSMutableArray array];
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.estimatedRowHeight=95.0;
    tableView.rowHeight=UITableViewAutomaticDimension;
    return tableView.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDFSystemMessageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDFSystemMessageTableViewCell"];
    if (!cell) {
        cell=[YLDFSystemMessageTableViewCell yldFSystemMessageTableViewCell];
    }
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
