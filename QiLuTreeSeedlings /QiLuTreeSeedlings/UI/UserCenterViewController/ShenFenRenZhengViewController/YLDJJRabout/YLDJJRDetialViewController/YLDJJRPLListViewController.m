//
//  YLDJJRPLListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/10.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRPLListViewController.h"
#import "YLDSPingLunCell.h"
#import "YLDSPingLunModel.h"
#import "ChangyanSDK.h"
#import "KMJRefresh.h"
@interface YLDJJRPLListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *pinglunAry;
@property (nonatomic, assign) NSInteger   commentNum;
@end

@implementation YLDJJRPLListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"苗木经纪人";
    self.commentNum=1;
    self.pinglunAry=[NSMutableArray array];
    __weak typeof(self) weakSelf=self;
    [self.tableView addHeaderWithCallback:^{
        weakSelf.commentNum=1;
        [weakSelf getcommentsWithPageNum:[NSString stringWithFormat:@"%ld",weakSelf.commentNum]];
    }];
    [self.tableView addFooterWithCallback:^{
        weakSelf.commentNum+=1;
        [weakSelf getcommentsWithPageNum:[NSString stringWithFormat:@"%ld",weakSelf.commentNum]];
    }];
    [self.tableView headerBeginRefreshing];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return  self.pinglunAry.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
    self.tableView.estimatedRowHeight = 90;
    return tableView.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDSPingLunCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSPingLunCell"];
    if (!cell) {
        cell=[YLDSPingLunCell yldSPingLunCell];
        cell.zanBtn.hidden=YES;
        cell.deleteBtn.hidden=YES;
        
    }
    YLDSPingLunModel *model=self.pinglunAry[indexPath.row];
    //        cell.delgate=self;
    cell.model=model;
    return cell;

}
-(void)getcommentsWithPageNum:(NSString *)pageNum
{
    __weak typeof(self) weakself=self;
    [ChangyanSDK getTopicComments:[NSString stringWithFormat:@"%@",self.topic_id] pageSize:@"30" pageNo:pageNum orderBy:nil style:@"indent" depth:nil subSize:@"10" completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        if (statusCode == CYSuccess)
        {
            if([pageNum isEqualToString:@"1"])
            {
                [weakself.pinglunAry removeAllObjects];
            }
            NSDictionary *dic=[ZIKFunction dictionaryWithJsonString:responseStr];
            NSArray *commentsAry=dic[@"comments"];
            
            if (commentsAry.count>0) {
                YLDSPingLunModel *model=[YLDSPingLunModel modelWithChangYanDic:[commentsAry lastObject]];
                YLDSPingLunModel *model2=[weakself.pinglunAry lastObject];
                if (model.uid!=model2.uid) {
                    [weakself.pinglunAry addObjectsFromArray:[YLDSPingLunModel aryWithChangYanAry:commentsAry]];
                    [weakself.tableView reloadData];
                }else{
                    [ToastView showTopToast:@"暂无更多评论"];
                }
                
            }else{
                [ToastView showTopToast:@"暂无更多评论"];
            }

        }
        if ([weakself.tableView isHeaderRefreshing]) {
            [weakself.tableView headerEndRefreshing];
        }
        if ([weakself.tableView isFooterRefreshing]) {
           [weakself.tableView footerEndRefreshing];
        }
        
    }];
 
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
