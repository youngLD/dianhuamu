//
//  ZIKOrderViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKOrderViewController.h"

/*****工具******/
#import "HttpClient.h"
#import "YYModel.h"//类型转换
#import "KMJRefresh.h"//MJ刷新
#import "UIDefines.h"
#import "JSONKit.h"
/*****工具******/

/*****Model******/
#import "ZIKStationOrderModel.h"
/*****Model******/

/*****View******/
#import "AdvertView.h"//广告页 section（0）
#import "ZIKOrderSingleTableViewCell.h"
#import "BigImageViewShowView.h"//点击显示大图
#import "ZIKOrderSecondTableViewCell.h"//筛选cell section（1）
#import "ZIKStationOrderScreeningView.h"//筛选页面
#import "ZIKStationOrderTableViewCell.h"//工程订单cell  section（2）
/*****View******/

/*****Controller******/
#import "ZIKCityListViewController.h"//城市选择
#import "ZIKStationOrderDetailViewController.h"//订单详情界面
#import "YLDTMoreBigImageADCell.h"
#import "YLDSadvertisementModel.h"
#import "YLDSBigImageVadCell.h"
#import "YLDStextAdCell.h"
#import "YLDTLeftTextAdCell.h"
#import "YLDTADThreePicCell.h"
#import "YLDSADViewController.h"
#import "ZIKMyShopViewController.h"
/*****Controller******/

/*****宏定义******/
static NSString *SectionHeaderViewIdentifier = @"StationCenterSectionHeaderViewIdentifieraa";

@interface ZIKOrderViewController ()<UITableViewDataSource,UITableViewDelegate,AdvertDelegate,ZIKCityListViewControllerDelegate,ZIKStationOrderScreeningViewDelegate,ZIKOrderSecondTableViewCellDelegate>
@property (nonatomic, weak)  UITableView     *orderTV;//工程订单Tableview
@property (nonatomic, assign) NSInteger      page;            //页数从1开始
@property (nonatomic, strong) NSMutableArray *orderMArr;//我的订单数组
@property (nonatomic, strong) BigImageViewShowView         *bigImageViewShowView;//显示大图
@property (nonatomic, strong) ZIKStationOrderScreeningView *screenView;//筛选界面

@property (nonatomic, strong) NSMutableArray *citys;
@property (nonatomic, strong) NSString       *citysStr;//地址的code string “，，”
@property (nonatomic) SelectStyle selectStyle;
//*  @param orderBy      排序，发布时间：orderDate,截止日期：endDate,默认orderDate
//*  @param orderSort    排序，升序：asc,降序：desc,默认desc
//*  @param status       0:已结束，1：报价中，2：已报价
//*  @param orderTypeUid 订单类型ID
//*  @param area         用苗地，Json格式， [{"provinceCode":"11", "cityCode":"110101"},{"provinceCode":"11", "cityCode":"110102"}]

@property (nonatomic, strong) NSString *orderBy;
@property (nonatomic, strong) NSString *orderSort;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *ordetTypeUid;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSMutableArray *areaMArr;


@property (nonatomic, strong) NSMutableArray *cityMutableArray;
@end

@implementation ZIKOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (self.screenView) {
        self.screenView.hidden = NO;
    }
}

- (void)initData {
    self.page           = 1;//页面page从1开始
    self.bigImageViewShowView = [[BigImageViewShowView alloc] initWithNomalImageAry:@[@"bangde1.jpg",@"bangde2.jpg",@"bangde3.jpg",@"bangde4.jpg",@"bangde1.png"]];
//    self.bigImageViewShowView = [[BigImageViewShowView alloc] initWithNomalImageAry:@[@"站长通-海报-2"]];
    self.areaMArr  = [NSMutableArray arrayWithCapacity:5];
    self.orderMArr = [[NSMutableArray alloc] init];

    _cityMutableArray = [[NSMutableArray alloc] init];
}

- (void)initUI {
    self.leftBarBtnTitleString = @"点花木";
    __weak typeof (self) weakSelf=self;
    self.leftBarBtnBlock = ^{
        if ([weakSelf.title isEqualToString:@" 工程订单 "]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
          [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKBackHome" object:nil];
        }
        
    };
    if ([self.title isEqualToString:@"金牌订单"]) {
        self.vcTitle=@"金牌订单";
        self.backColor=NavSColor;
    }
    if ([self.title isEqualToString:@"苗帮订单"]) {
        self.vcTitle=@"苗帮订单";
        self.backColor=NavSColor;
    }

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-50) style:UITableViewStylePlain];
    tableView.delegate   = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.orderTV = tableView;
    if ([self.title isEqualToString:@" 工程订单 "]) {
        self.vcTitle=@"工程订单";
        CGRect r=tableView.frame;
        r.size.height=kHeight-64;
        tableView.frame=r;
    }
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ZIKOrderSecondTableViewCell" bundle:nil];
    [self.orderTV registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];

}

#pragma mark - 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.orderTV addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.orderTV addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.orderTV headerBeginRefreshing];

}

#pragma mark - 请求工程订单列表信息
- (void)requestMyOrderList:(NSString *)page {
    //我的供应列表
    [self.orderTV headerEndRefreshing];
    [HTTPCLIENT stationGetOrderSearchWithOrderBy:self.orderBy orderSort:self.orderSort status:self.status orderTypeUid:self.ordetTypeUid area:self.area pageNumber:page pageSize:@"15" Success:^(id responseObject) {
        //CLog(@"result:%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            [self.orderTV footerEndRefreshing];
            return ;
        } else {
            NSDictionary *resultDic = responseObject[@"result"];
            NSString *advertisementsStr=[resultDic objectForKey:@"advertisements"];
            NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
            NSArray *adary=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];
            
            
            NSArray *orderListArr   = resultDic[@"orderList"];
            if (self.page == 1 && orderListArr.count == 0) {
                [ToastView showTopToast:@"已无更多信息"];
                [self.orderTV footerEndRefreshing];
                if(self.orderMArr.count > 0 ) {
                    [self.orderMArr removeAllObjects];
                }
                [self.orderTV reloadData];
                return ;
            } else if (orderListArr.count == 0 && self.page > 1) {
                [ToastView showTopToast:@"已无更多信息"];
                self.page--;
                [self.orderTV footerEndRefreshing];
                return;
            } else {
                if (self.page == 1) {
                    [self.orderMArr removeAllObjects];
                }

                NSMutableArray *orderAry=[NSMutableArray array];
                [orderListArr enumerateObjectsUsingBlock:^(NSDictionary *orderDic, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZIKStationOrderModel *model = [ZIKStationOrderModel yy_modelWithDictionary:orderDic];
                    [model initStatusType];
                    [orderAry addObject:model];
                }];
                [self.orderMArr addObjectsFromArray:[ZIKFunction aryWithMessageAry:orderAry withADAry:adary andIndex:2]];

                [self.orderTV reloadData];

                [self.orderTV footerEndRefreshing];

            }
        }
        
    } failure:^(NSError *error) {
        [self.orderTV footerEndRefreshing];

        //CLog(@"%@",error);
    }];

};
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ZIKOrderSecondTableViewCell *sectionHeaderView = [self.orderTV dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
                sectionHeaderView.delegate = self;
                [sectionHeaderView.screeningButton addTarget:self action:@selector(screeningBtnClick) forControlEvents:UIControlEventTouchUpInside];
        sectionHeaderView.backgroundColor = [UIColor whiteColor];
        sectionHeaderView.contentView.backgroundColor = [UIColor whiteColor];
        sectionHeaderView.backgroundView.backgroundColor = [UIColor whiteColor];
        return sectionHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model=self.orderMArr[indexPath.row];
    if ([model isKindOfClass:[YLDSadvertisementModel class]])
    {
        YLDSadvertisementModel *model=self.orderMArr[indexPath.row];
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
            tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
            tableView.estimatedRowHeight = (kWidth-20)*0.5606+25+60;
            return tableView.rowHeight;
        }else if (model.adsType==6)
        {
            return 160;
        }
        
    }else{
        self.orderTV.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
        self.orderTV.estimatedRowHeight = 185;
        return tableView.rowHeight;
    }
    return 185;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderMArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model=self.orderMArr[indexPath.row];
    if ([model isKindOfClass:[ZIKStationOrderModel class]]) {
        __block  ZIKStationOrderTableViewCell *cell = [ZIKStationOrderTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.orderMArr.count > 0) {
            __block  ZIKStationOrderModel *model = self.orderMArr[indexPath.row];
            [cell configureCell:model];
            cell.indexPath = indexPath;
            //按钮点击展开隐藏
            cell.openButtonBlock = ^(NSIndexPath *indexPath){
                model.isShow = !model.isShow;
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            };
        }
        return cell;
    }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
    {
        YLDSadvertisementModel * model=self.orderMArr[indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0)
    {
        ZIKStationOrderDetailViewController *orderDetailVC = [[ZIKStationOrderDetailViewController alloc] init];
        if ([self.title isEqualToString:@"金牌订单"]||[self.title isEqualToString:@"苗帮订单"]) {
            orderDetailVC.hidesBottomBarWhenPushed  = YES;
            orderDetailVC.navColor =NavSColor;
        }
        id model=self.orderMArr[indexPath.row];
        if ([model isKindOfClass:[ZIKStationOrderModel class]]) {
            if (self.orderMArr.count > 0) {
                ZIKStationOrderModel *model = self.orderMArr[indexPath.row];
                orderDetailVC.orderUid   = model.uid;
                orderDetailVC.statusType = model.statusType;
                [self.navigationController pushViewController:orderDetailVC animated:YES];
            }
        }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
        {
            YLDSadvertisementModel * model=self.orderMArr[indexPath.row];
            if (model.adType==0) {
                YLDSADViewController *advc=[[YLDSADViewController alloc]init];
                advc.urlString=model.content;
                [self.navigationController pushViewController:advc animated:YES];
            }else if (model.adType==1)
            {
                YLDSADViewController *advc=[[YLDSADViewController alloc]init];
                advc.urlString=model.link;
                [self.navigationController pushViewController:advc animated:YES];
            }else if (model.adType==2)
            {
                ZIKMyShopViewController *shopVC = [[ZIKMyShopViewController alloc] init];
                shopVC.memberUid = model.shop;
                shopVC.type = 1;
                [self.navigationController pushViewController:shopVC animated:YES];
            }

        }
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)screeningBtnClick {
    [self showSideView];
}

- (void)showSideView {

    [HTTPCLIENT stationGetOrderTypeSuccess:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else {
            // CLog(@"%@",responseObject[@"orderType"]);
            NSDictionary *orderTypeDic = responseObject[@"result"];
            //CLog(@"%@",orderTypeDic);

            NSString *typeName = [orderTypeDic[@"orderType"] objectForKey:@"lxName"];
            NSArray *typeArr = [orderTypeDic[@"orderType"] objectForKey:@"zidianList"];
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            if (!self.screenView) {
                self.screenView = [[ZIKStationOrderScreeningView alloc] init];//WithFrame:CGRectMake(Width, 0, Width, Height)];
                self.screenView.orderTypeName = typeName;
                self.screenView.orderTypeArr = typeArr;
                self.screenView.delegate = self;
            }
            [UIView animateWithDuration:.3 animations:^{
                self.screenView.frame = CGRectMake(0, 0, Width, Height);
            }];
            [[[UIApplication sharedApplication] keyWindow] addSubview:_screenView];
        }
    } failure:^(NSError *error) {
        ;
    }];


//    [self.view addSubview:self.screenView];
}
-(void)clearBtnAction
{
    _citysStr=nil;
    [self.citys removeAllObjects];
    [self.areaMArr removeAllObjects];
    
}
-(void)screeningBtnClickSendOrderStateInfo:(NSString *)orderState orderTypeInfo:(NSString *)orderType orderAddressInfo:(NSString *)orderAddress {
    //CLog(@"orderState:%@,orderType:%@,orderAddress:%@",orderState,orderType,orderAddress);
    self.status = orderState;
    self.ordetTypeUid = orderType;
    if ([orderAddress isEqualToString:@"请选择地址"]) {
        self.area = nil;
        [self.areaMArr removeAllObjects];
    }else{
        self.area = [self.areaMArr JSONString];
    }
    
    [self requestMyOrderList:@"1"];
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:0 inSection:1];
    ZIKOrderSecondTableViewCell *cell = (ZIKOrderSecondTableViewCell *)[self.orderTV cellForRowAtIndexPath:indexPath];
    if (self.screenView.isScreen) {
       [cell.screeningButton setImage:[UIImage imageNamed:@"工程订单_筛选on"] forState:UIControlStateNormal];
    } else {
       [cell.screeningButton setImage:[UIImage imageNamed:@"工程订单_筛选"] forState:UIControlStateNormal];
    }

}

-(void)StationOrderScreeningbackBtnAction {

}

#pragma mark ----- ZIKOrderSecondTableViewCellDelegate筛选按钮点击
-(void)sendTimeSortInfo:(NSDictionary *)timeSortDic {
    //CLog(@"timeSortDic:%@",timeSortDic);
    self.orderBy = timeSortDic[@"time"];
    self.orderSort = timeSortDic[@"sort"];
    self.page = 1;
    [self requestMyOrderList:[NSString stringWithFormat:@"%ld",(long)self.page]];
}

#pragma mark ----- AdvertDelegate广告页面点击
//广告页面点击
-(void)advertPush:(NSInteger)index
{
    [self.bigImageViewShowView showInKeyWindowWithIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addressSelectLabelAction {
//    ShowActionV();

    ZIKCityListViewController *cityVC = [[ZIKCityListViewController alloc] init];
    if ([self.title isEqualToString:@"金牌订单"]) {
       cityVC.hidesBottomBarWhenPushed = YES;
    }else{
      
    }
    
    self.screenView.hidden = YES;
    cityVC.selectStyle = SelectStyleMultiSelect;
    self.selectStyle = SelectStyleMultiSelect;
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:NO];
//    [self presentViewController:cityVC animated:YES completion:^{
//
//    }];
    
    [self.citys removeAllObjects];
    cityVC.citys = self.citys;
//    RemoveActionV();

}

#pragma mark - 确定返回后，传回地址执行协议
- (void)selectCitysInfo:(NSString *)citysStr {
    self.screenView.hidden = NO;
    _citysStr = citysStr;
    if (self.areaMArr.count > 0) {
        [self.areaMArr removeAllObjects];
    }
    GetCityDao *citydao = [GetCityDao new];
    [citydao openDataBase];
    __block NSString *str = @"";
    NSArray *cityArray = [_citysStr componentsSeparatedByString:@","];
    [cityArray enumerateObjectsUsingBlock:^(NSString *cityCode, NSUInteger idx, BOOL * _Nonnull stop) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[citydao getCityNameByCityUid:cityCode]]];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
        if (cityCode.length>2) {
            dic[@"provinceCode"] = [citydao getCityParentCode:cityCode];
            dic[@"cityCode"]     = cityCode;
        }else{
            dic[@"provinceCode"] = cityCode;
        }
        
        //{"provinceCode":"11", "cityCode":"110101"}
       
        [self.areaMArr addObject:dic];
    }];
    [citydao closeDataBase];
    //CLog(@"%@",self.areaMArr);
    self.screenView.orderAddressSelectLabel.text = [str substringToIndex:str.length-1];
}

- (IBAction)selectBtnClick:(id)sender {
    //self.citys = nil;
    ZIKCityListViewController *cityVC = [[ZIKCityListViewController alloc] init];
    cityVC.hidesBottomBarWhenPushed = YES;
    cityVC.selectStyle = SelectStyleMultiSelect;
    self.selectStyle = SelectStyleMultiSelect;
    cityVC.delegate = self;
    //    [self.navigationController pushViewController:cityVC animated:YES];
    cityVC.citys = self.citys;
}

- (NSArray *)citys {
    //if (_citys == nil) {
//    ShowActionV();
    _citys = [[NSMutableArray alloc] init];
    GetCityDao *dao = [[GetCityDao alloc] init];
    [dao openDataBase];
    NSArray *allProvince = [dao getCityByLeve:@"1"];
    [allProvince enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        ZIKCityModel *cityModel = [ZIKCityModel initCityModelWithDic:dic];
        //             cityModel.province.citys = [dao getCityByLeve:@"2" andParent_code:cityModel.province.code];
        NSMutableArray *cityMArr = [dao getCityByLeve:@"2" andParent_code:cityModel.province.code];


        NSMutableDictionary *dicionary = [NSMutableDictionary dictionary];
        [dicionary setObject:cityModel.province.provinceID forKey:@"id"];
        [dicionary setObject:cityModel.province.code forKey:@"code"];
        [dicionary setObject:cityModel.province.parent_code forKey:@"parent_code"];
        [dicionary setObject:@"全省" forKey:@"name"];
        [dicionary setObject:cityModel.province.level forKey:@"level"];
        [cityMArr insertObject:dicionary atIndex:0];
        cityModel.province.citys = cityMArr;

        [_citys addObject:cityModel];

    }];
    //self.dataAry = [CityModel creatCityAryByAry:allTown];
    [dao closeDataBase];
    if (![self.screenView.orderAddress isEqualToString:@"请选择地址"]) {
        NSArray *cityArray = [_citysStr componentsSeparatedByString:@","];
        __block NSInteger numcount = 0;
        [_citys enumerateObjectsUsingBlock:^(ZIKCityModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            [model.province.citys enumerateObjectsUsingBlock:^(NSMutableDictionary *cityDic, NSUInteger idx, BOOL * _Nonnull stop) {
                [cityArray enumerateObjectsUsingBlock:^(NSString *cityCode, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([cityDic[@"code"] isEqualToString:cityCode]) {
                        cityDic[@"select"] = @"1";
                        if (++numcount == cityArray.count) {
                            *stop = YES;
                        }
                    }
                }];
            }];
        }];
    }
    
    //}
    return _citys;
//    RemoveActionV();
}

@end
