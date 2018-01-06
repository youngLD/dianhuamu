//
//  YLDMMBBugViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/10/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDMMBBugViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "KMJRefresh.h"
#import "ZIKFunction.h"
/*****工具******/

#import "HotBuyModel.h"
#import "BuySearchTableViewCell.h"
#import "BuyDetialInfoViewController.h"
#import "YLDTBuyListCell.h"
#import "YLDSadvertisementModel.h"
#import "ZIKMyShopViewController.h"
#import "YLDSADViewController.h"
#import "YLDSBigImageVadCell.h"
#import "YLDStextAdCell.h"
#import "YLDTADThreePicCell.h"
#import "YLDTLeftTextAdCell.h"
#import "YLDTMoreBigImageADCell.h"
@interface YLDMMBBugViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *buyTableView;
@property (nonatomic, strong) NSMutableArray *buyMArr;
@property (nonatomic, assign) NSInteger      page;
@end

@implementation YLDMMBBugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"求购信息";
    [self.view setBackgroundColor:BGColor];
    self.buyMArr=[NSMutableArray array];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-44)];
    self.buyTableView=tableView;
    tableView.delegate=self;
    tableView.dataSource=self;
    [ZIKFunction setExtraCellLineHidden:self.buyTableView];
    [self.view addSubview:tableView];
    [self requestData];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _buyMArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model=self.buyMArr[indexPath.row];
    if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
        YLDSadvertisementModel *model=self.buyMArr[indexPath.row];
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
    }else{
        return 90;
    }
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model=self.buyMArr[indexPath.row];
    if ([model isKindOfClass:[HotBuyModel class]]) {
        YLDTBuyListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDTBuyListCell"];
        if (!cell) {
            cell=[YLDTBuyListCell yldTBuyListCell];
            
        }
        cell.model=model;
        return cell;
    }else if([model isKindOfClass:[YLDSadvertisementModel class]])
    {
        YLDSadvertisementModel *model=self.buyMArr[indexPath.row];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id model = self.buyMArr[indexPath.row];
    if ([model isKindOfClass:[HotBuyModel class]]) {
        HotBuyModel *model=self.buyMArr[indexPath.row];
        BuyDetialInfoViewController *vc=[[BuyDetialInfoViewController alloc]initWithSaercherInfo:model.uid];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
        YLDSadvertisementModel *model=self.buyMArr[indexPath.row];
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
#pragma mark - 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.buyTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMySupplyList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.buyTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMySupplyList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.buyTableView headerBeginRefreshing];
}
#pragma mark - 请求我的求购列表信息
- (void)requestMySupplyList:(NSString *)page {
    //我的供应列表
    NSString *searchTime;
    if (self.page > 1 && self.buyMArr.count > 0) {
        HotBuyModel *model = [self.buyMArr lastObject];
        searchTime = model.searchTime;
    }
    
    [self.buyTableView headerEndRefreshing];
    [HTTPCLIENT cooperationCompanyBuyWithPageSize:@"15" page:page searchTime:nil goldsupplier:@"9" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:kWidth/2 withSuperView:self.view];
            return ;
        }
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSArray *array = dic[@"buys"];
        if (array.count == 0 && self.page == 1) {
            [ToastView showToast:@"暂无信息" withOriginY:kWidth/2 withSuperView:self.view];
            if (self.buyMArr.count > 0) {
                [self.buyMArr removeAllObjects];
            }
            [self.buyTableView footerEndRefreshing];
            [self.buyTableView reloadData];
            return ;
        }  else if (array.count == 0 && self.page > 1) {
            self.page--;
            [self.buyTableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"已无更多信息" withOriginY:kWidth/2 withSuperView:self.view];
            return;
        }  else {
            if (self.page == 1) {
                [self.buyMArr removeAllObjects];
            }
            NSArray *aryzz = [HotBuyModel creathotBuyModelAryByAry:array];
            NSString *advertisementsStr=[dic objectForKey:@"advertisements"];
            NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
            NSArray *adAry=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];
//            NSArray *adAry=[YLDSadvertisementModel aryWithAry:dic[@"advertisements"]];
            [self.buyMArr addObjectsFromArray:[ZIKFunction aryWithMessageAry:aryzz withADAry:adAry]];
            [self.buyTableView reloadData];
            [self.buyTableView footerEndRefreshing];
        }
    } failure:^(NSError *error) {
        [self.buyTableView footerEndRefreshing];
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
