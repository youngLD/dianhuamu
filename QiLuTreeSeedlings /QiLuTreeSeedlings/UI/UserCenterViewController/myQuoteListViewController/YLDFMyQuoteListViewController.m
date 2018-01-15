//
//  YLDFMyQuoteListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/13.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFMyQuoteListViewController.h"
#import "YLDMyQuoteTableViewCell.h"
#import "YLDFMyQuoteModel.h"
#import "KMJRefresh.h"
@interface YLDFMyQuoteListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIButton *nowBtn;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,copy) NSString *lastTime;
@end

@implementation YLDFMyQuoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    self.dataAry =[NSMutableArray array];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.vcTitle =@"我的报价";
    [self getdataList];
    __weak typeof(self)weakSelf=self;
    [self.tableView addHeaderWithCallback:^{
        weakSelf.lastTime=nil;
        [weakSelf getdataList];
    }];
    [self.tableView addFooterWithCallback:^{
        [weakSelf getdataList];
    }];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)baoJiaBtnAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.nowBtn.selected=NO;
    sender.selected=YES;
    self.nowBtn=sender;
    CGRect frame=self.moveView.frame;
    frame.origin.x=(sender.tag-1)*kWidth/2+15*sender.tag;
    [UIView animateWithDuration:0.3 animations:^{
        self.moveView.frame=frame;
    }];
    [self.tableView headerBeginRefreshing];
}
-(void)getdataList
{
    NSString *state=nil;
    if (self.nowBtn.tag==2) {
        state=@"over";
    }
    ShowActionV();
    [HTTPCLIENT myQuoteListWithLastTime:self.lastTime state:state Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *data=[responseObject objectForKey:@"data"];
            if (_lastTime==nil) {
                [self.dataAry removeAllObjects];
            }
            self.lastTime=data[@"lastTime"];
            NSArray *quotes=data[@"quotes"];
            NSArray *dataAry=[YLDFMyQuoteModel creatByAry:quotes];
            if (dataAry.count>0) {
                [self.dataAry addObjectsFromArray:dataAry];
                [self.tableView reloadData];
            }else{
                [ToastView showTopToast:@"暂无更多数据"];
            }
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } failure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
    tableView.estimatedRowHeight = 170;
    return tableView.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDMyQuoteTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDMyQuoteTableViewCell"];
    if (!cell) {
        cell=[YLDMyQuoteTableViewCell yldMyQuoteTableViewCell];
    }
    cell.model=self.dataAry[indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
