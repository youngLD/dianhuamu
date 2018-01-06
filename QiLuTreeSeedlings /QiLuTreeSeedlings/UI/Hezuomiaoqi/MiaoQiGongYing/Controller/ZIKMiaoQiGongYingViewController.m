//
//  ZIKMiaoQiGongYingViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/6.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiGongYingViewController.h"
#import "HttpClient.h"
#import "YYModel.h"//类型转换
#import "KMJRefresh.h"//MJ刷新
#import "ZIKFunction.h"

#import "HotSellModel.h"
#import "SellSearchTableViewCell.h"
#import "SellDetialViewController.h"
#import "YLDSadvertisementModel.h"
#import "YLDSsupplyBaseCell.h"
#import "YLDStextAdCell.h"
#import "YLDSBigImageVadCell.h"
#import "ZIKMyShopViewController.h"
#import "YLDSADViewController.h"
#import "YLDTADThreePicCell.h"
#import "YLDTLeftTextAdCell.h"
#import "YLDTMoreBigImageADCell.h"
@interface ZIKMiaoQiGongYingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *gyTableView;
@property (nonatomic, strong) NSMutableArray *gyMArr;
@property (nonatomic, assign) NSInteger      page;            //页数从1开始

@end

@implementation ZIKMiaoQiGongYingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initUI];
    [self requestData];
}

- (void)initData {
    self.page = 1;
    self.gyMArr = [NSMutableArray array];
}

- (void)initUI {
    self.leftBarBtnTitleString = @"点花木";
    self.leftBarBtnBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKMiaoQiBackHome" object:nil];
    };

    self.gyTableView.delegate = self;
    self.gyTableView.dataSource = self;
    [ZIKFunction setExtraCellLineHidden:self.gyTableView];
}

#pragma mark - 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.gyTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.gyTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.gyTableView headerBeginRefreshing];

}

#pragma mark - 请求工程订单列表信息
- (void)requestMyOrderList:(NSString *)page {
    NSString *searchTime;
    if (self.page > 1 && self.gyMArr.count > 0) {
        HotSellModel *model = [self.gyMArr lastObject];
        searchTime = model.searchtime;
    }
   
    [self.gyTableView headerEndRefreshing];

    [HTTPCLIENT cooperationCompanySupplyWithPage:page pageSize:@"15" searchTime:searchTime Success:^(id responseObject) {
        CLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            return ;
        }
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSArray *array = dic[@"supplys"];
        if (array.count == 0 && self.page == 1) {
            [ToastView showToast:@"暂无信息" withOriginY:Width/2 withSuperView:self.view];
            if (self.gyMArr.count > 0) {
                [self.gyMArr removeAllObjects];
            }
            [self.gyTableView footerEndRefreshing];
            [self.gyTableView reloadData];
            return ;
        }  else if (array.count == 0 && self.page > 1) {
            self.page--;
            [self.gyTableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
            return;
        }  else {
            if (self.page == 1) {
                [self.gyMArr removeAllObjects];
            }
            
            NSArray *aryzz = [HotSellModel hotSellAryByAry:array];
            NSString *advertisementsStr=[dic objectForKey:@"advertisements"];
            NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
            NSArray *adAry=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];
//            NSArray *adAry=[YLDSadvertisementModel aryWithAry:dic[@"advertisements"]];
            [self.gyMArr addObjectsFromArray:[ZIKFunction aryWithMessageAry:aryzz withADAry:adAry]];
            [self.gyTableView reloadData];
            [self.gyTableView footerEndRefreshing];
        }
    } failure:^(NSError *error) {
        [self.gyTableView footerEndRefreshing];

    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gyMArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    id model=self.gyMArr[indexPath.row];
    if ([model isKindOfClass:[HotSellModel class]]) {
        YLDSsupplyBaseCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSsupplyBaseCell"];
        if (!cell) {
            cell=[YLDSsupplyBaseCell yldSsupplyBaseCell];
        }
        cell.model=model;
        
        
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
        }    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id model=self.gyMArr[indexPath.row];;
    if ([model isKindOfClass:[HotSellModel class]]) {
        HotSellModel *model = self.gyMArr[indexPath.row];
        SellDetialViewController *viewC = [[SellDetialViewController alloc] initWithUid:model];
        viewC.hidesBottomBarWhenPushed = YES;
        viewC.type = 2;
        [self.navigationController pushViewController:viewC animated:YES];
    }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
    {
        YLDSadvertisementModel *model = self.gyMArr[indexPath.row];
        if (model.adType==0) {
            YLDSADViewController *advc=[[YLDSADViewController alloc]init];
            advc.urlString=model.content;
            advc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:advc animated:YES];
        }else if (model.adType==1)
        {
            YLDSADViewController *advc=[[YLDSADViewController alloc]init];
            advc.urlString=model.link;
            advc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:advc animated:YES];
        }else if (model.adType==2)
        {
            ZIKMyShopViewController *shopVC = [[ZIKMyShopViewController alloc] init];
            shopVC.memberUid = model.shop;
            shopVC.type = 1;
            shopVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shopVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
