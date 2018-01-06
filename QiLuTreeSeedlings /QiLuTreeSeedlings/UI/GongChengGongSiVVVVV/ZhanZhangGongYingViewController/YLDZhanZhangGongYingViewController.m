//
//  YLDZhanZhangGongYingViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZhanZhangGongYingViewController.h"
#import "YLDFaBuGongChengDingDanViewController.h"
#import "YLDZhanZhangMessageViewController.h"
#import "AdvertView.h"
#import "UIDefines.h"
#import "YLDTuiJianGongZuoZhanCell.h"
#import "SellSearchTableViewCell.h"
#import "ZIKWorkstationViewController.h"
#import "KMJRefresh.h"
#import "HttpClient.h"
#import "YLDWorkstationlistModel.h"
#import "HotSellModel.h"
#import "SellDetialViewController.h"
#import "YLDZZsuppleyListViewController.h"
#import "BigImageViewShowView.h"
#import "YLDSsupplyBaseCell.h"
#import "ZIKFunction.h"
#import "YLDSadvertisementModel.h"
#import "YLDStextAdCell.h"
#import "YLDSBigImageVadCell.h"
#import "ZIKMyShopViewController.h"
#import "YLDSADViewController.h"
#import "YLDTADThreePicCell.h"
#import "YLDTLeftTextAdCell.h"
#import "YLDTMoreBigImageADCell.h"
@interface YLDZhanZhangGongYingViewController ()<AdvertDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic)NSInteger pageNum;
@property (nonatomic,strong)NSArray *workStationAry;
@property (nonatomic,strong)NSMutableArray *supplyAry;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong) BigImageViewShowView *bigImageViewShowView;
@property (nonatomic,strong) NSArray *luoboAry;
@end

@implementation YLDZhanZhangGongYingViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengshowTabBar" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum=1;
    self.supplyAry=[NSMutableArray array];
    self.backBtn.frame=CGRectMake(13, 26, 60, 30);
    self.vcTitle=@"站长供应";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-50) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    __weak typeof(self) weakSelf=self;
    self.tableView=tableView;
    [tableView addHeaderWithCallback:^{
        weakSelf.pageNum=1;
        [weakSelf getDataListWithPageNum:weakSelf.pageNum];
    }];
    [tableView addFooterWithCallback:^{
        weakSelf.pageNum+=1;
        [weakSelf getDataListWithPageNum:weakSelf.pageNum];
    }];
    [tableView headerBeginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fabubtnAction) name:@"YLDGONGChengFabuAction" object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)getDataListWithPageNum:(NSInteger )pageNum
{
    [HTTPCLIENT GCGSshouyeWithPageSize:@"3" WithsupplyCount:@"10"
        WithsupplyNumber:[NSString stringWithFormat:@"%ld",(long)pageNum]                       Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            if (self.pageNum==1) {
                [self.supplyAry removeAllObjects];
                NSArray *workStationList=dic[@"workstations"];
                self.workStationAry=[YLDWorkstationlistModel YLDWorkstationlistModelWithAry:workStationList];
            
                NSString *advertisementsStr=[dic objectForKey:@"carousels"];
                NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
                self.luoboAry=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];
                
            }
            
            NSArray *supplyList=dic[@"supplys"];
            if (supplyList.count<=0) {
                [ToastView showTopToast:@"已无更多信息"];
                
            }else{
                NSArray *dataAry=[HotSellModel hotSellAryByAry:supplyList];
                NSString *advertisementsStr=[dic objectForKey:@"advertisements"];
                NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
                NSArray *adAry=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];
//                NSArray *adAry=[YLDSadvertisementModel aryWithAry:[dic objectForKey:@"advertisements"]];
              [self.supplyAry addObjectsFromArray:[ZIKFunction aryWithMessageAry:dataAry withADAry:adAry]];
            }
            [self.tableView reloadData];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 0.368*kWidth;
    }
    if (indexPath.section==1) {
        return 125;
    }
    if (indexPath.section==2) {
        id model=self.supplyAry[indexPath.row];
        if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
            YLDSadvertisementModel * model=self.supplyAry[indexPath.row];
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
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.001;
    }
    return 36;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    if (section==1)
    {
        return self.workStationAry.count;
    }
    if (section==2) {
        return self.supplyAry.count;
    }
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0)
    {
        if (indexPath.row==0) {
            AdvertView *adView=[[AdvertView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 0.368*kWidth)];
            adView.delegate=self;
            [adView setAdInfoWithAry:self.luoboAry];
            [adView adStart];
            return adView;
//            UITableViewCell *cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 64, kWidth, 160.f/320.f*kWidth)];
//            UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 160.f/320.f*kWidth)];
//            [imageV setImage:[UIImage imageNamed:@"站长通-海报-2.png"]];
//            [cell addSubview:imageV];
//            return cell;
        }
    }
    if (indexPath.section==1) {
        YLDTuiJianGongZuoZhanCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDTuiJianGongZuoZhanCell"];
        if(!cell)
        {
            cell=[YLDTuiJianGongZuoZhanCell yldTuiJianGongZuoZhanCell];
        }
        cell.model=self.workStationAry[indexPath.row];
        return cell;
    }
    if (indexPath.section==2) {
        id model=self.supplyAry[indexPath.row];
        if ([model isKindOfClass:[HotSellModel class]]) {
            YLDSsupplyBaseCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSsupplyBaseCell"];
            if (!cell) {
                cell=[YLDSsupplyBaseCell yldSsupplyBaseCell];
            }
            cell.model=model;
            
            
            return cell;
        }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
        {
            YLDSadvertisementModel * model=self.supplyAry[indexPath.row];
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
        

    }
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    return cell;
}
- (void)advertPush:(NSInteger)index
{
    if (index<self.luoboAry.count) {
        YLDSadvertisementModel *model=self.luoboAry[index];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
         [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
        YLDWorkstationlistModel *model = self.workStationAry[indexPath.row];
        YLDZhanZhangMessageViewController *vccc=[[YLDZhanZhangMessageViewController alloc]initWithUid:model.uid];
        vccc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vccc animated:YES];
    }
    if (indexPath.section==2) {
         id model=self.supplyAry[indexPath.row];
        if ([model isKindOfClass:[HotSellModel class]]) {
            SellDetialViewController *sellDetialViewC=[[SellDetialViewController alloc]initWithUid:model];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
            sellDetialViewC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:sellDetialViewC animated:YES];
        }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
        {
            YLDSadvertisementModel *model=self.supplyAry[indexPath.row];
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
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *view=[self makeTitleViewWithTitle:@"推荐工作站" AndColor:kRedHintColor andY:0];
       UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 0, 40, 36)];
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        UIImageView *hotMoreRowImgV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-35, 10.5, 15, 15)];
        [hotMoreRowImgV setImage:[UIImage imageNamed:@"moreRow"]];
        [view addSubview:hotMoreRowImgV];
        [moreBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [moreBtn addTarget:self action:@selector(moreWorkstationAcion) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:moreBtn];
        return view;
    }
    if (section==2) {
        UIView *view=[self makeTitleViewWithTitle:@"工作站供应" AndColor:NavColor andY:0];
        UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 0, 40, 36)];
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        UIImageView *hotMoreRowImgV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-35, 10.5, 15, 15)];
        [hotMoreRowImgV setImage:[UIImage imageNamed:@"moreRow"]];
        [view addSubview:hotMoreRowImgV];
        [moreBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [moreBtn addTarget:self action:@selector(moresupplyAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:moreBtn];

        return view;
    }
    UIView *view=[[UIView alloc]init];
    
    return view;
}
-(void)moresupplyAction
{
     [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
    YLDZZsuppleyListViewController *yldZZSUPPLEYVC=[[YLDZZsuppleyListViewController alloc]init];
    yldZZSUPPLEYVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:yldZZSUPPLEYVC animated:YES];
}
-(void)moreWorkstationAcion
{
     [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
    ZIKWorkstationViewController *vc=[[ZIKWorkstationViewController alloc]init];
    vc.type=2;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//构建小标题栏
-(UIView *)makeTitleViewWithTitle:(NSString *)title AndColor:(UIColor *)color andY:(CGFloat )y
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, y, kWidth, 36)];
    [view setBackgroundColor:[UIColor clearColor]];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 5, 22)];
    [imageV setBackgroundColor:color];
    [view addSubview:imageV];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 90, 36)];
    titleLab.text=title;
    [titleLab setTextColor:color];
    [titleLab setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:titleLab];
    return view;
    
}
-(void)fabubtnAction
{
    if(self.tabBarController.selectedIndex==0)
    {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
        YLDFaBuGongChengDingDanViewController *fabuVC=[[YLDFaBuGongChengDingDanViewController alloc]init];
        fabuVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:fabuVC animated:YES];
    }
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
