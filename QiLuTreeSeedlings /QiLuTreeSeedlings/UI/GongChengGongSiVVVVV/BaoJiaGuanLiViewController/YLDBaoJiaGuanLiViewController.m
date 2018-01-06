//
//  YLDBaoJiaGuanLiViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDBaoJiaGuanLiViewController.h"
#import "YLDBaoJiaDetialViewController.h"
#import "YLDFaBuGongChengDingDanViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "KMJRefresh.h"
#import "YLDBaoJiaCell.h"
#import "YLDBaoModel.h"
#import "YLDBaoJiaDetialViewController.h"
@interface YLDBaoJiaGuanLiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,weak) UITableView *tableView;
@end

@implementation YLDBaoJiaGuanLiViewController
@synthesize pageNum;
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"报价管理";
    self.pageNum=1;
    self.dataAry=[NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fabubtnAction) name:@"YLDGONGChengFabuAction" object:nil];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 65, kWidth, kHeight-64-50)];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView=tableView;
    [self.view addSubview:tableView];
    __weak typeof(self) weakSelf=self;
    [tableView addHeaderWithCallback:^{
        weakSelf.pageNum=1;
        ShowActionV();
        [weakSelf getDataListPageNum:[NSString stringWithFormat:@"%ld",(long)weakSelf.pageNum] andKeyWord:@""];
    }];
    [tableView addFooterWithCallback:^{
        weakSelf.pageNum+=1;
         ShowActionV();
        [weakSelf getDataListPageNum:[NSString stringWithFormat:@"%ld",(long)weakSelf.pageNum] andKeyWord:@""];
    }];
    [tableView headerBeginRefreshing];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLDBaoModel *model=self.dataAry[indexPath.row];
    NSString *stsada;
    if (model.descriptions.length>0) {
        stsada=[NSString stringWithFormat:@"苗木说明：%@",model.descriptions];
    }else{
        stsada=@"苗木说明：";
    }
    CGFloat hieghtss=[self getHeightWithContent:stsada width:kWidth-20 font:14];
    if (hieghtss>25) {
        return 150-10 +hieghtss;
    }else
    {
        return 150;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDBaoJiaCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDBaoJiaCell"];
    if (!cell) {
        cell=[YLDBaoJiaCell yldBaoJiaCell];
    }
    YLDBaoModel *model=self.dataAry[indexPath.row];
    cell.model=model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YLDBaoModel *model=self.dataAry[indexPath.row];
    YLDBaoJiaDetialViewController *baojiaDetial=[[YLDBaoJiaDetialViewController alloc]initWithUid:model.uid];
    baojiaDetial.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:baojiaDetial animated:YES];
}
-(void)getDataListPageNum:(NSString *)pageNums andKeyWord:(NSString *)keyWord
{
    [HTTPCLIENT baojiaGuanLiWithStatus:nil Withkeyword:keyWord WithpageNumber:pageNums WithpageSize:@"15" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if (pageNum==1) {
                [self.dataAry removeAllObjects];
            }
            NSArray *itemList=[[responseObject objectForKey:@"result"] objectForKey:@"itemList"];
            if (itemList.count==0) {
                pageNum--;
                [ToastView showTopToast:@"已无更多信息"];
            }else{
                NSArray *dataSSary=[YLDBaoModel yldBaoModelAryWithAry:itemList];
                YLDBaoModel *model1=[dataSSary lastObject];
                YLDBaoModel *model2=[self.dataAry lastObject];
                if ([model1.uid isEqualToString:model2.uid]) {
                    pageNum--;
                    [ToastView showTopToast:@"已无更多信息"];
                }else{
                    [self.dataAry addObjectsFromArray:dataSSary];
                    [self.tableView reloadData];
                }
                
            }
            if (self.pageNum<1) {
                self.pageNum=1;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengshowTabBar" object:nil];
}
-(void)fabubtnAction
{
    if(self.tabBarController.selectedIndex==2)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
        YLDFaBuGongChengDingDanViewController *fabuVC=[[YLDFaBuGongChengDingDanViewController alloc]init];
        fabuVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:fabuVC animated:YES];
    }
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
