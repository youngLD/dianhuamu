 //
//  YLDZZsuppleyListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZZsuppleyListViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "KMJRefresh.h"
#import "HotSellModel.h"
#import "SellSearchTableViewCell.h"
#import "ScreeningView.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "SellDetialViewController.h"
#import "YLDSadvertisementModel.h"
#import "YLDSsupplyBaseCell.h"
#import "ZIKFunction.h"
#import "YLDSBigImageVadCell.h"
#import "YLDStextAdCell.h"
#import "ZIKMyShopViewController.h"
#import "YLDSADViewController.h"
#import "YLDTADThreePicCell.h"
#import "YLDTLeftTextAdCell.h"
#import "YLDTMoreBigImageADCell.h"
@interface YLDZZsuppleyListViewController ()<ScreeningViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic)NSInteger pageNum;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,weak) ScreeningView *screeningView;
@property (nonatomic,weak)UITextField *searchMessageField;
@property (nonatomic,strong)NSArray *guigeAry;
@property (nonatomic,copy)NSString *AreaProvince;
@property (nonatomic,copy)NSString *AreaCity;
@property (nonatomic,copy)NSString *AreaCounty;
@property (nonatomic,copy)NSString *goldsupplier;
@property (nonatomic,copy)NSString *productUid;
@property (nonatomic,copy)NSString *productName;
@end

@implementation YLDZZsuppleyListViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"站长供应";
    self.pageNum=1;
    self.dataAry=[NSMutableArray array];
    [self creatVVVVVV];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    __weak typeof(self) weakSlef=self;
    [tableView addHeaderWithCallback:^{
        weakSlef.pageNum=1;
        ShowActionV();
        if (self.searchMessageField.text.length==0) {
            [self getSuppleyLsitWithPage:weakSlef.pageNum];
        }else{
             [weakSlef getdatalistWithpageNumber:weakSlef.pageNum pageSize:@"15" goldsupplier:self.goldsupplier productUid:self.productUid productName:self.productName province:self.AreaProvince city:self.AreaCity county:self.AreaCounty WithAry:self.guigeAry];
        }
    }];
    [tableView addFooterWithCallback:^{
        weakSlef.pageNum+=1;
         ShowActionV();
        if (self.searchMessageField.text.length==0) {
            [self getSuppleyLsitWithPage:weakSlef.pageNum];
        }else{
            [weakSlef getdatalistWithpageNumber:weakSlef.pageNum pageSize:@"15" goldsupplier:self.goldsupplier productUid:self.productUid productName:self.productName province:self.AreaProvince city:self.AreaCity county:self.AreaCounty WithAry:self.guigeAry];
        }
    }];
    [self.tableView headerBeginRefreshing];
    // Do any additional setup after loading the view.
}
-(void)getSuppleyLsitWithPage:(NSInteger)pagenum
{
    NSString *searchTime;
    if (self.pageNum>1) {
        HotSellModel *model=[self.dataAry lastObject];
        searchTime=model.searchtime;
    }
    [HTTPCLIENT zhanzhanggongyingListWithPageNum:[NSString stringWithFormat:@"%ld",(long)pagenum] WithPageSize:@"15" WithsearchTime:searchTime Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if (self.pageNum==1) {
                [self.dataAry removeAllObjects];
            }
            NSDictionary *result=[responseObject objectForKey:@"result"];
            NSArray *supplyList=result[@"supplys"];
            if (supplyList.count==0) {
                [ToastView showTopToast:@"已无更多信息"];
                self.pageNum--;
            }else{

                NSArray *dataAry=[HotSellModel hotSellAryByAry:supplyList];
                NSString *advertisementsStr=[result objectForKey:@"advertisements"];
                NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
                NSArray *adAry=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];
                [self.dataAry addObjectsFromArray:[ZIKFunction aryWithMessageAry:dataAry withADAry:adAry]];
            }
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        RemoveActionV();
    } failure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
       RemoveActionV();
    }];
}
-(void)getdatalistWithpageNumber:(NSInteger)pageNumber  pageSize:(NSString *)pageSize goldsupplier:(NSString *)goldsupplier productUid:(NSString *)productUid productName:(NSString *)productName province:(NSString *)province city:(NSString *)city
                          county:(NSString *)county WithAry:(NSArray *)ary
{
    NSString *searchTime;
    if (self.pageNum>1) {
        HotSellModel *model=[self.dataAry lastObject];
        searchTime=model.searchtime;
    }
    [HTTPCLIENT ZhanZhanggongyingListWithPage:[NSString stringWithFormat:@"%ld",(long)pageNumber] WithPageSize:pageSize Withgoldsupplier:goldsupplier WithProductUid:productUid WithProductName:productName WithProvince:province WithCity:city WithCounty:county  WithAry:ary WithSearchTime:searchTime Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if (self.pageNum==1) {
                [self.dataAry removeAllObjects];
            }
            NSDictionary *result=[responseObject objectForKey:@"result"];
            NSArray *supplyList=result[@"supplys"];
            if (supplyList.count==0) {
                [ToastView showTopToast:@"已无更多信息"];
                self.pageNum--;
            }else{
                NSArray *dataAry=[HotSellModel hotSellAryByAry:supplyList];
                NSString *advertisementsStr=[result objectForKey:@"advertisements"];
                NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
                NSArray *adAry=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];
                [self.dataAry addObjectsFromArray:[ZIKFunction aryWithMessageAry:dataAry withADAry:adAry]];
            }

        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        RemoveActionV();
    } failure:^(NSError *error) {
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        RemoveActionV();
    }];
}

- (void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    self.goldsupplier=nil;
    self.productUid=nil;
    self.productName=textField.text;
    self.AreaProvince=nil;
    self.AreaCity=nil;
    self.AreaCounty=nil;
    self.guigeAry=nil;
    if (textField.text.length == 0) {
        [self.tableView headerBeginRefreshing];
        self.productName=nil;
    }
  
}
-(void)creeingActionWithAry:(NSArray *)ary WithProvince:(NSString *)province WihtCity:(NSString *)city WithCounty:(NSString *)county WithGoldsupplier:(NSString *)goldsupplier WithProductUid:(NSString *)productUid withProductName:(NSString *)productName
{
    self.guigeAry=ary;
    self.productName=productName;
    self.productUid=productUid;
    self.AreaProvince=province;
    self.AreaCity=city;
    self.AreaCounty=county;
    self.goldsupplier=goldsupplier;
    self.searchMessageField.text=productName;
    [self.tableView headerBeginRefreshing];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model=self.dataAry[indexPath.row];
    if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
        YLDSadvertisementModel * model=self.dataAry[indexPath.row];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model=self.dataAry[indexPath.row];
    if ([model isKindOfClass:[HotSellModel class]]) {
        YLDSsupplyBaseCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSsupplyBaseCell"];
        if (!cell) {
            cell=[YLDSsupplyBaseCell yldSsupplyBaseCell];
        }
        cell.model=model;
        
        
        return cell;
    }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
    {
        YLDSadvertisementModel * model=self.dataAry[indexPath.row];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id model=self.dataAry[indexPath.row];
    if ([model isKindOfClass:[HotSellModel class]]) {
        SellDetialViewController *sellDetialViewC=[[SellDetialViewController alloc]initWithUid:model];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
        
        [self.navigationController pushViewController:sellDetialViewC animated:YES];
    }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
    {
        YLDSadvertisementModel *model=self.dataAry[indexPath.row];
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
-(void)creatVVVVVV
{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(60, 25, kWidth-120, 44-10)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    backView.layer.masksToBounds=YES;
    backView.layer.cornerRadius=3;
    [self.navBackView addSubview:backView];
    UITextField * searchMessageField=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, backView.frame.size.width-60, 34)];
    self.searchMessageField=searchMessageField;
    searchMessageField.placeholder=@"请输入树种名称";
    [searchMessageField setTextColor:titleLabColor];
    
    searchMessageField.tag=1001;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:searchMessageField];
    [searchMessageField setFont:[UIFont systemFontOfSize:14]];
    searchMessageField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [backView addSubview:searchMessageField];
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(backView.frame.size.width-45, 0, 34,34)];
    [searchBtn setImage:[UIImage imageNamed:@"searchOrange"] forState:UIControlStateNormal];
    [searchBtn setEnlargeEdgeWithTop:10 right:0 bottom:0 left:0];
    [searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:searchBtn];
    
    
    UIButton *screenBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-25, 30, 20, 20)];
    [screenBtn setEnlargeEdgeWithTop:15 right:10 bottom:10 left:30];
    [screenBtn setImage:[UIImage imageNamed:@"screenBtnAction"] forState:UIControlStateNormal];
    UILabel *labee=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-53, 30, 30, 20)];
    [labee setFont:[UIFont systemFontOfSize:14]];
    [labee setTextColor:[UIColor whiteColor]];
    labee.text=@"筛选";
    [self.navBackView addSubview:labee];
    [screenBtn addTarget:self action:@selector(screeingBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackView addSubview:screenBtn];
}
-(void)screeingBtnAction
{
    if (self.screeningView) {
        [self.screeningView setSearchStr:self.searchMessageField.text];
        if (self.screeningView.superview==nil) {
            [self.view addSubview:self.screeningView];
        }
    }else{
        ScreeningView *screeningV=[[ScreeningView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight) andSearch:self.searchMessageField.text andSerachType:1];
        self.screeningView=screeningV;
        screeningV.delegate=self;
        [self.view addSubview:screeningV];
    }
    [self.screeningView showViewAction];
}
-(void)searchBtnAction:(UIButton *)sender
{
    if (self.searchMessageField.text.length==0) {
        [ToastView showTopToast:@"请输入搜索内容"];
        [self.searchMessageField becomeFirstResponder];
        return;
    }
  
    [self.searchMessageField resignFirstResponder];
    [self.tableView headerBeginRefreshing];
 
}
-(void)ScreeningbackBtnAction
{
    self.screeningView=nil;
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
