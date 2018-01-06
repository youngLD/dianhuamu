//
//  YLDMMBSupplyViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/10/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDMMBSupplyViewController.h"
#import "UIDefines.h"
#import "KMJRefresh.h"//MJ刷新
#import "HotSellModel.h"
#import "SellSearchTableViewCell.h"
#import "SellDetialViewController.h"
#import "HttpClient.h"
#import "AdvertView.h"
#import "BigImageViewShowView.h"
#import "ZIKFunction.h"
#import "YLDSsupplyBaseCell.h"
#import "YLDSadvertisementModel.h"
#import "YLDStextAdCell.h"
#import "YLDSBigImageVadCell.h"
#import "ZIKMyShopViewController.h"
#import "YLDSADViewController.h"
#import "YLDTADThreePicCell.h"
#import "YLDTLeftTextAdCell.h"
#import "YLDTMoreBigImageADCell.h"
@interface YLDMMBSupplyViewController ()<UITableViewDelegate,UITableViewDataSource,AdvertDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) BigImageViewShowView *bigImageViewShowView;
@property (nonatomic, strong) NSMutableArray *gyMArr;
@property (nonatomic, assign) NSInteger      page;            //页数从1开始
@property (nonatomic,strong) NSArray *luoAry;
@end

@implementation YLDMMBSupplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"供应信息";
    [self initData];
    [self.view setBackgroundColor:BGColor];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-44) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView=tableView;
    [self.view addSubview:tableView];
    [self requestData];


    // Do any additional setup after loading the view.
}
- (void)initData {
    self.page = 1;
    self.gyMArr = [NSMutableArray array];
}
#pragma mark - 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.tableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.tableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.tableView headerBeginRefreshing];
    
}
#pragma mark - 请求工程订单列表信息
- (void)requestMyOrderList:(NSString *)page {
    NSString *searchTime;
    if (self.page > 1 && self.gyMArr.count > 0) {
        HotSellModel *model = [self.gyMArr lastObject];
        searchTime = model.searchtime;
    }
    
    [self.tableView headerEndRefreshing];
    
    [HTTPCLIENT GoldSupplrWithPageSize:@"10" WithPage:[NSString stringWithFormat:@"%ld",self.page] Withgoldsupplier:@"9"   Success:^(id responseObject) {
//        CLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:kWidth/2 withSuperView:self.view];
            return ;
        }
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSArray *array = dic[@"supplys"];
        if (array.count == 0 && self.page == 1) {
            [ToastView showToast:@"暂无信息" withOriginY:kWidth/2 withSuperView:self.view];
            if (self.gyMArr.count > 0) {
                [self.gyMArr removeAllObjects];
            }
            [self.tableView footerEndRefreshing];
            [self.tableView reloadData];
            return ;
        }  else if (array.count == 0 && self.page > 1) {
            self.page--;
            [self.tableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"已无更多信息" withOriginY:kWidth/2 withSuperView:self.view];
            return;
        }  else {
            if (self.page == 1) {
                [self.gyMArr removeAllObjects];
            }
            NSArray *aryzz = [HotSellModel hotSellAryByAry:array];
            NSString *advertisementsStr=[dic objectForKey:@"advertisements"];
            NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
            NSArray *adAry=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];
//            NSArray *adAry= [YLDSadvertisementModel aryWithAry:dic[@"advertisements"]];
            [self.gyMArr addObjectsFromArray:[ZIKFunction aryWithMessageAry:aryzz withADAry:adAry]];
            NSString *lbadvertisementsStr=[dic objectForKey:@"carousels"];
            NSDictionary *lbadvertisementsDic=[ZIKFunction dictionaryWithJsonString:lbadvertisementsStr];
            self.luoAry=[YLDSadvertisementModel aryWithAry:lbadvertisementsDic[@"result"]];
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
        }
    } failure:^(NSError *error) {
        [self.tableView footerEndRefreshing];
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return self.gyMArr.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 0.368*kWidth;
    }else{
        id model=self.gyMArr[indexPath.row];
        if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
            YLDSadvertisementModel * model=self.gyMArr[indexPath.row];
            if (model.adsType==1) {
                return 160;
            }else if (model.adsType==0)
            {
                return (kWidth-20)*0.24242+25+60;
            }else if (model.adsType==2)
            {
                tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
                tableView.estimatedRowHeight = (kWidth-20)*0.5606+25+60;
                return tableView.rowHeight;
            }else if (model.adsType==3)
            {
                return (kWidth-20)*0.24242+25+60;
            }else if (model.adsType==6)
            {
                return 160;
            }
        }
        return 190;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        AdvertView *adView=[[AdvertView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.368*kWidth)];
        adView.delegate=self;
        [adView setAdInfoWithAry:self.luoAry];
        [adView adStart];
        return adView;
    }else{
        id model=self.gyMArr[indexPath.row];
        if ([model isKindOfClass:[HotSellModel class]]) {
            YLDSsupplyBaseCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSsupplyBaseCell"];
            if (!cell) {
                cell=[YLDSsupplyBaseCell yldSsupplyBaseCell];
            }
            cell.model=self.gyMArr[indexPath.row];
            return cell;
        }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
        {
            YLDSadvertisementModel * model=self.gyMArr[indexPath.row];
            if (model.adsType==0) {
                YLDSBigImageVadCell *cell=[YLDSBigImageVadCell yldSBigImageVadCell];
                cell.model=model;
                return cell;
            }else if (model.adsType==1){
                YLDStextAdCell *cell=[YLDStextAdCell yldStextAdCell];
                cell.model=model;
                return cell;
            }else if (model.adsType==2){
                YLDTMoreBigImageADCell *cell=[YLDTMoreBigImageADCell yldTMoreBigImageADCell];
                cell.model=model;
                return cell;
            }else if (model.adsType==3){
                YLDTADThreePicCell *cell=[YLDTADThreePicCell yldTADThreePicCell];
                cell.model=model;
                return cell;
            }else if (model.adsType==6){
                YLDTLeftTextAdCell *cell=[YLDTLeftTextAdCell yldTLeftTextAdCell];
                cell.model=model;
                return cell;
            }
        }
        UITableViewCell *cell=[UITableViewCell new];
        
        return cell;


    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id model=self.gyMArr[indexPath.row];
    if ([model isKindOfClass:[HotSellModel class]]) {
        HotSellModel *model=self.gyMArr[indexPath.row];
        
        SellDetialViewController *vc=[[SellDetialViewController alloc]initWithUid:model];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
  
    }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
    {
        YLDSadvertisementModel *model=self.gyMArr[indexPath.row];
        if (model.adType==0) {
            YLDSADViewController *advc=[[YLDSADViewController alloc]init];
            advc.urlString=model.content;
            advc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:advc animated:YES];
        }else if (model.adType==1)
        {
            YLDSADViewController *advc=[[YLDSADViewController alloc]init];
            advc.urlString=model.link;
            advc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:advc animated:YES];
        }else if (model.adType==2)
        {
            ZIKMyShopViewController *shopVC = [[ZIKMyShopViewController alloc] init];
            shopVC.memberUid = model.shop;
            shopVC.type = 1;
            shopVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:shopVC animated:YES];
        }
    }
    
}
-(void)advertPush:(NSInteger)index
{
    if (index<self.luoAry.count) {
        YLDSadvertisementModel *model=self.luoAry[index];
        if (model.adType==0) {
            YLDSADViewController *advc=[[YLDSADViewController alloc]init];
            advc.urlString=model.content;
            advc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:advc animated:YES];
        }else if (model.adType==1)
        {
            YLDSADViewController *advc=[[YLDSADViewController alloc]init];
            advc.urlString=model.link;
            advc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:advc animated:YES];
        }else if (model.adType==2)
        {
            ZIKMyShopViewController *shopVC = [[ZIKMyShopViewController alloc] init];
            shopVC.memberUid = model.shop;
            shopVC.type = 1;
            shopVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:shopVC animated:YES];
        }
    }
//    [self.bigImageViewShowView showInKeyWindowWithIndex:index];
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
