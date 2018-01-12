//
//  YLDSHomePageViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/1/12.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSHomePageViewController.h"

#import "QRCodeViewController.h"//二维码扫描
#import "KMJRefresh.h"

#import "UIDefines.h"
#import "AdvertView.h"
#import "CircleViews.h"
#import "YYModel.h"
#import "SearchViewController.h"
#import "YLDLoginViewController.h"
#import "YLDGongChengGongSiViewController.h"

#import "ZIKFunction.h"

#import "SellDetialViewController.h"

#import "YLDSBigImageVadCell.h"
#import "YLDStextAdCell.h"
#import "YLDSADViewController.h"
#import "YLDLoginViewController.h"
#import "UINavController.h"
#import "ZIKMyShopViewController.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "YLDSearchActionViewController.h"

#import "ZIKVoucherCenterViewController.h"
#import "YLDSPinDaoViewController.h"
//朋友圈
#import "SDTimeLineTableViewController.h"


#import "YLDJJRMyViewController.h"
#import "YLDJJRSHZViewController.h"
#import "YLDJJRenShenQing1ViewController.h"
#import "YLDJJRTSView.h"
#import "YLDJJRNotPassViewController.h"
#import "JJRGGViewController.h"
#import "YLDHomeMoreViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "GetCityDao.h"
#import "YLDPickLocationView.h"
#import "MJRefreshGifHeader.h"

#import "YLDTADThreePicCell.h"
#import "YLDTLeftTextAdCell.h"
#import "YLDTMoreBigImageADCell.h"
#import "YLDTHZDWViewController.h"


//第四版
#import "YLDFSupplyModel.h"
#import "YLDFBuyModel.h"
#import "YLFMySupplyTableViewCell.h"
#import "YLDFHomeFenYeViewConroller.h"
#import "ZIKOrderViewController.h"
#import "YLDFMyBuyTableViewCell.h"
#import "YLDFEOrderModel.h"
#import "YLDEngineeringOrderTableViewCell.h"
#import "YLDFSupplyFabuViewController.h"
#import "YLDFBuyFBViewController.h"
#import "YLDFabuSuccessViewController.h"
#import "YLDFMySupplyListViewController.h"
#import "YLDFBuyListViewController.h"
#import "YLDHomeJJRCell.h"
#import "YLDJJrModel.h"
#import "YLDJJRListViewController.h"
#import "YLDJJRDeitalViewController.h"
#import "YLDFEOrderDetialViewController.h"
#define TopBtnW 90
@interface YLDSHomePageViewController ()<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,CircleViewsDelegate,AdvertDelegate,YLDSearchActionVCDelegate,YLDHomeJJRCellDelegate,YLDPickLocationDelegate,UITabBarControllerDelegate,YLDEngineeringOrderTableViewCellDelegate,YLDFabuSuccessDelegate,supplyFabuDelegate,buyFabuDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *searchTopV;
@property (nonatomic,strong)NSMutableArray *orderMArr;//工程订单
@property (nonatomic,strong)NSMutableArray *dataAry;//热门供应

@property (nonatomic,strong)NSArray *lunboAry;
@property (nonatomic)NSInteger PageCount;
@property (nonatomic,strong)NSArray *classAry;
@property (nonatomic,strong)UIButton *nowBtn;
@property (nonatomic,strong)UIScrollView *topScrollV;
@property (nonatomic,strong)UIView *topActionV;
@property (nonatomic,strong)UIView *topActionMoveV;
@property (nonatomic,strong) NSMutableArray *newsDataAry;
@property (nonatomic)CGRect rect;
@property (nonatomic)BOOL what;
@property (nonatomic,strong)UIView *topView1;

@property (nonatomic)BOOL paySuccess;
@property (nonatomic,strong)UIButton *goTopBtn;
@property (nonatomic,strong)NSArray *borkers;
@property (nonatomic,assign)NSInteger lastType;
@property (nonatomic,strong)UIButton *ActionVNowBtn;
@property (nonatomic,strong)UIButton *qiugouNowBtn;
//@property (nonatomic,copy)NSString *qiugouState;
@property (nonatomic,strong)UIButton *cityBtn;
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,copy)NSString *lastTime;
@property (nonatomic,strong)UIView *heardView;
@property (nonatomic,strong)UIView *hearActionView;
@property (nonatomic,strong)UIView *CBGV;
@property (nonatomic,strong)UIView *adBGView;
@property (nonatomic,strong)UIView *JJRMView;

@property (nonatomic,strong)YLDHomeJJRCell *JJRLView;
@property (nonatomic,assign)CGFloat GGW;
@property (nonatomic,assign)CGFloat JJRW;
@end

@implementation YLDSHomePageViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry =[NSMutableArray array];
    [self getnewClassAction];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushMessageForSaoMa:) name:@"saosaokanxinwen" object:nil];
    self.PageCount=1;
    _GGW=0.368*kWidth;
    double  kkk = kWidth*(12/40.f-0.0417);
    _JJRW=kkk+70;
    self.orderMArr=[NSMutableArray array];
    self.newsDataAry=[NSMutableArray array];
    
    [self openDingweiAction];

    self.topActionV=[self creatGBTypeV];


   
    [self creatTableViewHearder];
    [self getDataListWithPageNum:@"1"];
    //缓存
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *result = [userDefaults objectForKey:@"homePageCaches2"];

    if (result) {
        
    }
    
    self.topView1=[self creatTopSeachV];
    [self.view addSubview:self.topView1];
    
    [self CreatXuanfuBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMessageForDingzhiXinXi:) name:@"dingzhixinxituisong" object:nil];
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(nonnull UIViewController *)viewController
{
    
    
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController==self.navigationController) {
        if (self.tableView.tableHeaderView==nil) {
            [self gotopBtnAction];
        }
        
    }
    return YES;
}
-(void)pushMessageForDingzhiXinXi:(NSNotification *)notification
{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}
#pragma mark ---------TOPBtnAction----------
-(void)topBtnAction:(UIButton *)sender//新闻的头部
{
    if (self.nowBtn!=sender) {
        _lastTime=nil;
    }
    self.nowBtn.selected=NO;
    self.nowBtn=sender;
    sender.selected=YES;

    NSInteger  tag=sender.tag;
    CGFloat actionW=(tag-0.5)*TopBtnW;
    if(actionW>kWidth/2&&actionW<self.topScrollV.contentSize.width-kWidth/2)
    {
        [self.topScrollV setContentOffset:CGPointMake((tag-0.5)*TopBtnW-kWidth/2, 0) animated:YES];
    }else if (actionW<kWidth/2)
    {
        [self.topScrollV setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (actionW>self.topScrollV.contentSize.width-kWidth/2)
    {
        [self.topScrollV setContentOffset:CGPointMake(self.topScrollV.contentSize.width-kWidth, 0) animated:YES];
    }
    NSDictionary *dic=self.classAry[self.nowBtn.tag-1];
    self.PageCount=1;

    
}
-(void)topActionVBtnAction:(UIButton *)sender
{
    self.ActionVNowBtn.selected=NO;
    _lastTime=nil;
    sender.selected=YES;
    self.lastType=sender.tag;
    self.ActionVNowBtn=sender;
    CGRect frame=self.topActionMoveV.frame;
    frame.origin.x=sender.tag*(kWidth/4);
   
    [UIView animateWithDuration:0.3 animations:^{
        if(self.tableView.tableHeaderView!=nil)
        {
            self.tableView.tableHeaderView=nil;
            [self.tableView setBackgroundColor:BGColor];
            if (self.goTopBtn.hidden==YES) {
                self.goTopBtn.hidden=NO;
            }
            if (self.tableView.frame.origin.y!=64) {
                self.tableView.frame=CGRectMake(0,64,kWidth, kHeight-44-64);
            }
            if (self.topView1.alpha!=1) {
                self.topView1.alpha=1;
                
            }
            [self changeNav];
        }
        self.topActionMoveV.frame=frame;
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
}



#pragma mark ---------TableView相关----------
-(void)cellOpenBtnActionWithCell:(YLDEngineeringOrderTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {
        return  self.dataAry.count;
 
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        id model=self.dataAry[indexPath.row];
        if ([model isKindOfClass:[YLDFSupplyModel class]]) {
           return 182;
        }
        if ([model isKindOfClass:[YLDFBuyModel class]]) {
            return 141;
        }
        if ([model isKindOfClass:[YLDFEOrderModel class]]) {
            tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
            tableView.estimatedRowHeight = 185;
            return tableView.rowHeight;
        }
        
    }
   
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section==0) {

        if (_lastType==3) {
            return 100;
        }
        return 50;
    }

    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section==0) {
        
        if (_lastType==1) {
            CGRect frame=self.topActionV.frame;
            frame.size.height=50;
            self.topActionV.frame=frame;
            [self.topScrollV removeFromSuperview];
            return self.topActionV;
        }else if (_lastType==3) {
            CGRect frame=self.topActionV.frame;
            frame.size.height=100;
            self.topActionV.frame=frame;
            [self.topActionV addSubview:self.topScrollV];
            return self.topActionV;
        }else
        {
            CGRect frame=self.topActionV.frame;
            frame.size.height=50;
            self.topActionV.frame=frame;

            [self.topScrollV removeFromSuperview];
            return self.topActionV;
        }
        
    }
    UIView *view=[UIView new];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        id model=self.dataAry[indexPath.row];
        if ([model  isKindOfClass:[YLDFEOrderModel class]])
        {
            YLDFEOrderModel *modelz=self.dataAry[indexPath.row];
            YLDFEOrderDetialViewController *vc=[YLDFEOrderDetialViewController new];
            vc.hidesBottomBarWhenPushed=YES;
            vc.orderId=modelz.engineeringProcurementId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        id model=self.dataAry[indexPath.row];
        if ([model isKindOfClass:[YLDFSupplyModel class]]) {
            YLFMySupplyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLFMySupplyTableViewCell"];
            if (!cell) {
                cell=[YLFMySupplyTableViewCell yldFListSupplyTableViewCell];
                
            }
            cell.model=self.dataAry[indexPath.row];
            return cell;
        }
        if ([model  isKindOfClass:[YLDFBuyModel class]]) {
            YLDFMyBuyTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"YLDFMyBuyTableViewCell"];
            if (!cell) {
                cell=[YLDFMyBuyTableViewCell yldFListBuyTableViewCell];
            }
            cell.model=self.dataAry[indexPath.row];
            return cell;
        }
        if ([model  isKindOfClass:[YLDFEOrderModel class]]) {
            YLDEngineeringOrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDEngineeringOrderTableViewCell"];
            if (!cell) {
                cell=[YLDEngineeringOrderTableViewCell yldEngineeringOrderTableViewCell];
                cell.delegate=self;
            }
            cell.model=self.dataAry[indexPath.row];
            return cell;
        }
        
        
    }

    UITableViewCell *cell=[UITableViewCell new];
    
    return cell;
}
-(void)moreBtnAction:(UIButton *)sender{
    
    if(sender.tag==2)
    {
        YLDJJRListViewController *vc=[YLDJJRListViewController new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag==4&&_lastType==2) {
        if (![APPDELEGATE isNeedLogin]) {
            YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
            [ToastView showTopToast:@"请先登录"];
            UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
            
            [self presentViewController:navVC animated:YES completion:^{
                
            }];
            return ;
        }
        
    }
    if (sender.tag==4&&_lastType==1) {
        NSInteger type=3;
//        if ([self.qiugouState isEqualToString:@"new"]) {
//            type=2;
//        }
        SearchViewController *searVC=[[SearchViewController alloc]initWithSearchType:type];
        searVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:searVC animated:YES];
    }
    if (sender.tag==4&&_lastType==0) {
        SearchViewController *searVC=[[SearchViewController alloc]initWithSearchType:1];
        searVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:searVC animated:YES];
    }
    if (sender.tag==4&&_lastType==3) {
        

    }
   
}
#pragma mark ---------地址选择相关----------
-(void)areaBtnAction
{
    YLDPickLocationView *pickLocationV=[[YLDPickLocationView alloc]initWithFrame:[UIScreen mainScreen].bounds CityLeve:CityLeveShi];
    pickLocationV.delegate=self;
    pickLocationV.isLock=YES;
    [pickLocationV showPickView];
}
-(void)selectSheng:(CityModel *)sheng shi:(CityModel *)shi xian:(CityModel *)xian zhen:(CityModel *)zhen
{
    NSString *namestr=nil;
    if (sheng.code) {
        namestr=sheng.cityName;
        APPDELEGATE.cityModel=sheng;
        
    }else{
        return;
    }
    
    if (shi.code) {
        namestr=shi.cityName;
        APPDELEGATE.cityModel=shi;
        
    }
    [self.cityBtn setTitle:namestr forState:UIControlStateNormal];
    [self.cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.cityBtn.imageView.image.size.width, 0, self.cityBtn.imageView.image.size.width)];
    [self.cityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.cityBtn.titleLabel.bounds.size.width, 0, -self.cityBtn.titleLabel.bounds.size.width)];
    [self.tableView headerBeginRefreshing];
}
#pragma mark ---------构建小标题----------
-(UIView *)makeTitleViewWithTitle:(NSString *)title AndColor:(UIColor *)color andY:(CGFloat )y
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, y, kWidth, 40)];
    [view setBackgroundColor:BGColor];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 9, 5, 22)];
    [imageV setBackgroundColor:color];
    [view addSubview:imageV];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 220, 40)];
    titleLab.text=title;
    [titleLab setTextColor:color];
    [titleLab setFont:[UIFont systemFontOfSize:18]];
    [view addSubview:titleLab];

    return view;
    
}

#pragma mark ---------各种nav----------
-(void)topActionWithAry:(NSArray *)ary
{
    UIScrollView *topScrollV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, kWidth, 40)];
    [topScrollV setContentSize:CGSizeMake(TopBtnW*ary.count, 0)];
    [topScrollV setBackgroundColor:BGColor];
    topScrollV.userInteractionEnabled=YES;
    topScrollV.showsVerticalScrollIndicator=NO;
    topScrollV.showsHorizontalScrollIndicator=NO;
    [topScrollV setBackgroundColor:[UIColor whiteColor]];
    self.topScrollV=topScrollV;
    
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(i*TopBtnW, 0, TopBtnW, 40)];
        btn.tag=i+1;
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
        [btn setTitle:dic[@"name"] forState:UIControlStateSelected];
        [btn setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
        [btn setTitleColor:NavColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [topScrollV addSubview:btn];
        
        UIView *lineV=[[UIView alloc]initWithFrame:CGRectMake(i*TopBtnW-0.5, 5, 0.5, 30)];
        [lineV setBackgroundColor:kLineColor];
        [topScrollV addSubview:lineV];
        if (i==0) {
            self.nowBtn=btn;
            btn.selected=YES;

            
        }
    }
    UIView *lineV=[[UIView alloc]initWithFrame:CGRectMake(0, 39.5,TopBtnW*ary.count, 0.5)];
    [lineV setBackgroundColor:kLineColor];
    [topScrollV addSubview:lineV];
}
-(UIView *)creatTopSeachV
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    UIImageView *iamgeV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    iamgeV.tag=3;
    [iamgeV setImage:[UIImage imageNamed:@"topsssss"]];
    [view addSubview:iamgeV];
    [view setBackgroundColor:[UIColor clearColor]];
    UIButton *cityBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 27, 65, 30)];
    [cityBtn setTitle:APPDELEGATE.cityModel.cityName forState:UIControlStateNormal];
    [cityBtn setImage:[UIImage imageNamed:@"selectAreaR"] forState:UIControlStateNormal];
    
    [cityBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    self.cityBtn=cityBtn;
    [cityBtn addTarget:self action:@selector(areaBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [cityBtn setEnlargeEdgeWithTop:10 right:5 bottom:15 left:10];
    [view addSubview:cityBtn];
    [cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.cityBtn.imageView.image.size.width, 0, self.cityBtn.imageView.image.size.width)];
    [cityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.cityBtn.titleLabel.bounds.size.width, 0, -self.cityBtn.titleLabel.bounds.size.width)];
    UIButton *saomaBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-40, 27, 30, 30)];
    saomaBtn.tag=2;
    [saomaBtn setImage:[UIImage imageNamed:@"saomaW"] forState:UIControlStateNormal];
    [saomaBtn addTarget:self action:@selector(saomaBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [saomaBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    [view addSubview:saomaBtn];
    UIView *searchView=[[UIView alloc]initWithFrame:CGRectMake(70, 27, kWidth-75-50, 30)];
    searchView.tag=1;
    searchView.layer.masksToBounds=YES;
    searchView.layer.cornerRadius=15;
    [searchView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:searchView];
    
    UILabel *titleLLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 30)];
    titleLLab.tag=11;
    [titleLLab setTextColor:kRGB(153, 153, 153, 1)];
    [searchView addSubview:titleLLab];
    [titleLLab setFont:[UIFont systemFontOfSize:15]];
    [titleLLab setText:@"请输入树种名称"];
    UIImageView *searchIamV=[[UIImageView alloc]initWithFrame:CGRectMake(searchView.frame.size.width-30, 2.5, 25, 25)];
    searchIamV.tag=12;
    searchIamV.image=[UIImage imageNamed:@"serachSG"];
    [searchView addSubview:searchIamV];
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:searchView.bounds];
    [searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    return view;
}
-(UIView *)creatGBTypeV
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    NSArray *ary=@[@"推荐供应",@"推荐求购",@"推荐订单",@"头条"];
    for (int i=0; i<ary.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/4*i, 0, kWidth/4, 48)];
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        [btn setTitleColor:titleLabColor  forState:UIControlStateNormal];
        [btn setTitleColor:MoreDarkTitleColor  forState:UIControlStateSelected];
        btn.tag=i;
        [btn addTarget:self action:@selector(topActionVBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.selected=YES;
            self.ActionVNowBtn=btn;
        }
       [view addSubview:btn];
    }
    UIView *linV=[[UIView alloc]initWithFrame:CGRectMake(0, 49.5, kWidth, 0.5)];
    [linV setBackgroundColor:kLineColor];
    [view addSubview:linV];
    UIView *moveView=[[UIView alloc]initWithFrame:CGRectMake(0, 47, kWidth/4, 3)];
    [moveView setBackgroundColor:NavColor];
    [view addSubview:moveView];
    self.topActionMoveV=moveView;
    [view setBackgroundColor:[UIColor whiteColor]];
    
    return view;
}

#pragma mark ---------搜索相关----------
-(void)searchBtnAction
{
    YLDSearchActionViewController *yldsaVC=[[YLDSearchActionViewController alloc]init];
    yldsaVC.delegate=self;
    yldsaVC.searchType=1;
    [self presentViewController:yldsaVC animated:NO completion:^{
        
    }];

}

-(void)searchActionWithType:(NSInteger)searchType searchString:(NSString *)searchStr
{
    SearchViewController *searchV=[[SearchViewController alloc]initWithSearchType:searchType andSaerChStr:searchStr];
    searchV.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:searchV animated:NO];
}
#pragma mark ---------滑动改变nav----------
-(void)gotopBtnAction
{
    self.goTopBtn.hidden=YES;
    self.adBGView.alpha=1;
    self.CBGV.alpha=1;
    self.JJRLView.alpha=1;
    self.JJRMView.alpha=1;
    self.tableView.frame=CGRectMake(0, 0, kWidth, kHeight-44);
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    [UIView animateWithDuration:0.3 animations:^{
        [self BackchangeNav];
        self.tableView.tableHeaderView=self.heardView;
        [self.tableView.tableHeaderView addSubview:self.hearActionView];
    } completion:^(BOOL finished) {
//    [self setBgContentOffsetAnimation:0];
        
    }];
    
    
//

    
    
    
}
-(void)setBgContentOffsetAnimation:(CGFloat )OffsetY

{    [UIView animateWithDuration:0.3 animations:^
      
    {
        self.tableView.contentOffset = CGPointMake(0, OffsetY);
        
    }];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag==112) {
        if (self.tableView.tableHeaderView!=nil) {
            if(scrollView.contentOffset.y<_JJRW+_GGW+100+20)
            {
                if (self.goTopBtn.hidden==NO) {
                    self.goTopBtn.hidden=YES;
                }
            }
            if (scrollView.contentOffset.y<-2)
            {
                [self.tableView.tableHeaderView addSubview:self.hearActionView];
                if(self.topView1.hidden==NO)
               {
                   self.topView1.hidden=YES;
                }
            }
            
            if (scrollView.contentOffset.y>=-2){
                if(self.topView1.hidden==YES)
                {
                        self.topView1.hidden=NO;
                }
            }
            
            if (scrollView.contentOffset.y>=1) {
              
                [self.view insertSubview:self.hearActionView belowSubview:self.tableView];
            if(scrollView.contentOffset.y>1&&scrollView.contentOffset.y<_JJRW) {
                    self.JJRLView.alpha =1-scrollView.contentOffset.y/_JJRW;
                }
                if(scrollView.contentOffset.y>=_JJRW&&scrollView.contentOffset.y<_JJRW+40)
                {
                    self.JJRMView.alpha=1-(scrollView.contentOffset.y-_JJRW)/40;
                } if(scrollView.contentOffset.y>=_JJRW+40&&scrollView.contentOffset.y<_JJRW+140)
                {
                    self.CBGV.alpha=1-(scrollView.contentOffset.y-_JJRW-40)/100;
                    self.topView1.alpha=1-(scrollView.contentOffset.y-_JJRW-40)/100;
                } if(scrollView.contentOffset.y>=_JJRW+40+100&&scrollView.contentOffset.y<=_JJRW+140+_GGW)
                {
                    self.adBGView.alpha=1-(scrollView.contentOffset.y-_JJRW-140)/_GGW;
                   self.tableView.frame=CGRectMake(0,(scrollView.contentOffset.y-_JJRW-140)/_GGW*64,kWidth, kHeight-44-(scrollView.contentOffset.y-_JJRW-140)/_GGW*64);
//                    NSLog(@"%lf--%lf",scrollView.contentOffset.y-_JJRW-140);
                   
                } if(scrollView.contentOffset.y>=_JJRW+_GGW+100+39&&self.tableView.tableHeaderView!=nil) {
                    self.tableView.tableHeaderView=nil;
                    [self.tableView setBackgroundColor:BGColor];
                    if (self.goTopBtn.hidden==YES) {
                        self.goTopBtn.hidden=NO;
                    }
                    if (self.tableView.frame.origin.y!=64) {
                       self.tableView.frame=CGRectMake(0,64,kWidth, kHeight-44-64);
                    }
                    if (self.topView1.alpha!=1) {
                        self.topView1.alpha=1;
                        [self changeNav];

                    }
                    
                    [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                    
                }
            }else{
//                [self.view insertSubview:self.hearActionView aboveSubview:self.tableView];
                [self.tableView.tableHeaderView addSubview:self.hearActionView];

            }
        }else{
            if (self.goTopBtn.hidden==YES) {
                self.goTopBtn.hidden=NO;
            }
        }

    }

}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.tag==112) {
        if (self.JJRLView.alpha!=1) {
            self.JJRLView.alpha=1;
        }
    }
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.tag==112) {
    if (self.tableView.tableHeaderView!=nil) {
        if (targetContentOffset->y>=_JJRW) {
            [scrollView setContentOffset:CGPointMake(0, _JJRW+_GGW+40+100) animated:YES];

        }else{
//            [self setBgContentOffsetAnimation:0];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    }
    
}
-(void)changeNav
{
    [self.topView1 setBackgroundColor:kRGB(250, 250, 250, 1)];
    UIImageView *imageV=[self.topView1 viewWithTag:3];
    if (imageV.hidden==NO) {
        imageV.hidden=YES;
    }
    UIView *searchV=[self.topView1 viewWithTag:1];
    [searchV setBackgroundColor:kRGB(220, 220, 220, 1)];
    UIButton *saomaBtn=[self.topView1 viewWithTag:2];
    [saomaBtn setImage:[UIImage imageNamed:@"saomaG"] forState:UIControlStateNormal];
    [self.cityBtn setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
    [_cityBtn setImage:[UIImage imageNamed:@"selectAreaRB"] forState:UIControlStateNormal];
}
-(void)BackchangeNav
{
    [self.topView1 setBackgroundColor:[UIColor clearColor]];
    
    if(self.topView1.hidden==YES)
    {
        self.topView1.hidden=NO;
    }
    UIImageView *imageV=[self.topView1 viewWithTag:3];
    if (imageV.hidden==YES) {
        imageV.hidden=NO;
    }
    
    UIButton *saomaBtn=[self.topView1 viewWithTag:2];
    [saomaBtn setImage:[UIImage imageNamed:@"saomaW"] forState:UIControlStateNormal];
    [_cityBtn setImage:[UIImage imageNamed:@"selectAreaR"] forState:UIControlStateNormal];
    [self.cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGRect frame =  self.topView1.frame;
    frame.origin.y=0;
    self.topView1.frame=frame;
}
#pragma mark ---------网络请求----------
-(void)reloadTableVVVWithLastType
{
    //供应
    if (_lastType==0) {
        [HTTPCLIENT SupplynewLsitWithQuery:nil WithlastTime:_lastTime Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                if (!_lastTime) {
                    [self.dataAry removeAllObjects];
                }
                NSDictionary *data=[responseObject objectForKey:@"data"];
                NSArray *supplys=data[@"supplys"];
                NSArray *supplysModelAry=[YLDFSupplyModel YLDFSupplyModelAryWithAry:supplys];
                YLDFSupplyModel *model=[supplysModelAry lastObject];
                self.lastTime=model.lastTime;
                [self.dataAry addObjectsFromArray:supplysModelAry];
                [self.tableView reloadData];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView footerEndRefreshing];
        } failure:^(NSError *error) {
            [self.tableView footerEndRefreshing];
            [self.tableView.mj_header endRefreshing];
        }];
    }
    if (_lastType==1) {
        [HTTPCLIENT BuysNewLsitWithQuery:nil WithlastTime:_lastTime Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                if (!_lastTime) {
                    [self.dataAry removeAllObjects];
                }
                NSDictionary *data=[responseObject objectForKey:@"data"];
                NSArray *buys=data[@"buys"];
                NSArray *buysModelAry=[YLDFBuyModel YLDFBuyModelAryWithAry:buys];
                YLDFBuyModel *model=[buysModelAry lastObject];
                self.lastTime=model.lastTime;
                [self.dataAry addObjectsFromArray:buysModelAry];
                [self.tableView reloadData];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            [self.tableView footerEndRefreshing];
            [self.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
          
            [self.tableView footerEndRefreshing];
            [self.tableView.mj_header endRefreshing];
        }];
    }
    if (_lastType==2) {
        [HTTPCLIENT getEOrderListWithLastTime:_lastTime Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                if (!_lastTime) {
                    [self.dataAry removeAllObjects];
                }
                NSArray *order=[responseObject objectForKey:@"data"];
               
                NSArray *orderModelAry=[YLDFEOrderModel creatModeByAry:order];
                YLDFEOrderModel *model=[orderModelAry lastObject];
                self.lastTime=model.lastTime;
                [self.dataAry addObjectsFromArray:orderModelAry];
                
                [self.tableView reloadData];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            [self.tableView footerEndRefreshing];
            [self.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            [self.tableView footerEndRefreshing];
            [self.tableView.mj_header endRefreshing];
        }];
    }
    if (_lastType==2) {
        [self.tableView footerEndRefreshing];
        [self.tableView.mj_header endRefreshing];
    }
    
}
-(void)getDataListWithPageNum:(NSString *)num
{
    [HTTPCLIENT getHomePageInfoSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]!=0) {
            
                [self.dataAry removeAllObjects];
                [self.orderMArr removeAllObjects];
            NSDictionary *result = [responseObject objectForKey:@"data"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:result forKey:@"homePageCaches2"];
            [userDefaults synchronize];

            NSArray *borkers = result[@"brokers"];
            self.borkers=[YLDJJrModel yldJJrModelByAry:borkers];
            _JJRLView.modelAry=self.borkers;
            if (self.lastType==0) {
                NSArray *supplysAry=result[@"supplys"];
                NSArray *supplyDataAry=[YLDFSupplyModel YLDFSupplyModelAryWithAry:supplysAry];
                YLDFSupplyModel *model=[supplyDataAry lastObject];
                _lastTime=model.lastTime;
                [self.dataAry addObjectsFromArray:supplyDataAry];
                
                [self.tableView reloadData];
            }
      

        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
       [self.tableView.mj_header endRefreshing];
    }];
}



#pragma mark ----------扫码相关----------
-(void)saomaBtnAction
{
    QRCodeViewController *qrcodevc = [[QRCodeViewController alloc] init];
    qrcodevc.QRCodeSuccessBlock = ^(QRCodeViewController *aqrvc,NSString *qrString){
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
        if ([qrString containsString:@"http"])
        {
            NSRange range = [qrString rangeOfString:@"/Home/openApp"];
            if(range.location != NSNotFound){
                
                [self saomiaoSuccessWithstr:qrString];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:qrString]];
        }
        
    }

        
    };
    qrcodevc.QRCodeFailBlock = ^(QRCodeViewController *aqrvc){
        [ToastView showTopToast:@"扫描失败"];
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    };
    qrcodevc.QRCodeCancleBlock = ^(QRCodeViewController *aqrvc){
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
        //self.saomiaoLabel.text = @"cancle~";
        [ToastView showTopToast:@"取消扫描"];
    };
    [self presentViewController:qrcodevc animated:YES completion:nil];
}
-(void)pushMessageForSaoMa:(NSNotification *)notification
{
    NSString *qrString=(NSString *)notification.object;
    [self saomiaoSuccessWithstr:qrString];
    
}
-(void)saomiaoSuccessWithstr:(NSString *)qrString
{
    NSRange range1 = [qrString rangeOfString:@"projectorderid="];
    if( range1.location != NSNotFound){
        if ([APPDELEGATE isNeedLogin]) {
            NSString *uid=[qrString substringWithRange:NSMakeRange(range1.location+range1.length, qrString.length-range1.location-range1.length)];
//            ZIKStationOrderDetailViewController *orderDetailVC = [[ZIKStationOrderDetailViewController alloc] init];
//
//            orderDetailVC.orderUid   = uid;
//            orderDetailVC.statusType = 1;
//            orderDetailVC.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:orderDetailVC animated:YES];
        }else{
            YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
            [ToastView showTopToast:@"请先登录"];
            UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
            
            [self presentViewController:navVC animated:YES completion:^{
                
            }];
            return ;
        }
        
    }
    
    NSRange range2 = [qrString rangeOfString:@"buyDetailUid="];
    if( range2.location != NSNotFound){
        
        NSString *uid=[qrString substringWithRange:NSMakeRange(range2.location+range2.length, qrString.length-range2.location-range2.length)];
//        BuyDetialInfoViewController *buydetialVC=[[BuyDetialInfoViewController alloc]
//                                                  initWithSaercherInfo:uid];
//        buydetialVC.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:buydetialVC animated:YES];
    }
    
    NSRange range3 = [qrString rangeOfString:@"supplyDetailUid="];
    if( range3.location != NSNotFound){
        
        NSString *uid=[qrString substringWithRange:NSMakeRange(range3.location+range3.length, qrString.length-range3.location-range3.length)];
        HotSellModel *model=[HotSellModel new];
        model.uid=uid;
        model.supplybuyUid=uid;
        SellDetialViewController *sellDetialViewC=[[SellDetialViewController alloc]initWithUid:model];
        sellDetialViewC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:sellDetialViewC animated:YES];
    }
    NSRange range4 = [qrString rangeOfString:@"reviewarticl="];
    if( range4.location != NSNotFound){
        
        NSString *uid=[qrString substringWithRange:NSMakeRange(range4.location+range4.length, qrString.length-range4.location-range4.length)];
//        ZIKNewsDetialViewController *zikNDVC=[[ZIKNewsDetialViewController alloc]init];
//        zikNDVC.hidesBottomBarWhenPushed=YES;
//        zikNDVC.urlString=uid;
//        
//        [self.navigationController pushViewController:zikNDVC animated:YES];
        
    }

}
#pragma mark ----------圆形按钮点击推送----------
-(void)circleViewsPush:(NSInteger)index{
    
    if (index==0) {
        SearchViewController *searVC=[[SearchViewController alloc]initWithSearchType:3];
        searVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:searVC animated:YES];
        return;
    }
    if (index==1) {
        SearchViewController *searVC=[[SearchViewController alloc]initWithSearchType:1];
        searVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:searVC animated:YES];
        return;
    }
    if (index==2) {
        if (![APPDELEGATE isNeedLogin]) {
            YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
            [ToastView showTopToast:@"请先登录"];
            UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
            
            [self presentViewController:navVC animated:YES completion:^{
                
            }];
            return ;
        }
        ZIKOrderViewController *orderVC=[[ZIKOrderViewController alloc]init];
        orderVC.vcTitle=@"工程订单";
        orderVC.title=@" 工程订单 ";
        orderVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
    if (index==3) {
        YLDHomeMoreViewController *vc=[[YLDHomeMoreViewController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
   
    }
}
#pragma mark ----------经纪人相关----------
-(UIView *)JJRMoreView
{
        UIView *xxview=[self makeTitleViewWithTitle:@"" AndColor:NavColor andY:0];
        UIButton *jjrtjBuyBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, 270, 40)];
        jjrtjBuyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [jjrtjBuyBtn setTitle:@"苗木经纪人" forState:UIControlStateNormal];
        jjrtjBuyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
        [jjrtjBuyBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
        [jjrtjBuyBtn setTitleColor:NavColor forState:UIControlStateNormal];
        [xxview addSubview:jjrtjBuyBtn];
        [xxview setBackgroundColor:[UIColor whiteColor]];
        UIImageView *liImagV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 1)];
        [liImagV setBackgroundColor:BGColor];
        [xxview addSubview:liImagV];
        UIButton *moreHotBuyBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-110, 0, 80, 40)];
        [moreHotBuyBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [moreHotBuyBtn setTitleColor:titleLabColor forState:UIControlStateNormal];
        moreHotBuyBtn.tag=2;
        UIImageView *hotMoreRowImgV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-35, 10.5, 15, 15)];
        [hotMoreRowImgV setImage:[UIImage imageNamed:@"moreRow"]];
        [xxview addSubview:hotMoreRowImgV];
        [moreHotBuyBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [moreHotBuyBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [xxview addSubview:moreHotBuyBtn];
    
        return xxview;
}
-(void)yxmqActionWithTag:(NSInteger)tag
{
    YLDTHZDWViewController *vc=[YLDTHZDWViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    vc.endType=tag;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)jjrActionWithModel:(YLDJJrModel *)model
{
    YLDJJRDeitalViewController *vc=[YLDJJRDeitalViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    vc.uid=model.userUid;
    vc.vzuid=model.uid;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)jjrListMoreAction
{
    YLDJJRListViewController *vc=[YLDJJRListViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----------广告点击推送----------
-(void)advertPush:(NSInteger)index
{
    if (index<self.lunboAry.count) {
        YLDSadvertisementModel *model=self.lunboAry[index];
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
#pragma mark ----------频道展示页面----------
-(void)pingdaoBtnAction
{
    YLDSPinDaoViewController *pingdaoVC=[[YLDSPinDaoViewController alloc]init];
    pingdaoVC.classAry=self.classAry;
    [self presentViewController:pingdaoVC animated:YES completion:^{
        
    }];
}
#pragma mark ----------获取新闻分类----------
-(void)getnewClassAction
{
    [HTTPCLIENT getNewsClassSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            self.classAry=[responseObject objectForKey:@"data"];
            [self topActionWithAry:self.classAry];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark --生成tableview--
-(void)creatTableViewHearder
{
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,kWidth , kHeight-44) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView=tableView;
#ifdef __IPHONE_11_0
    if ([tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
#endif
    UIView *heardView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, _GGW+40+100+_JJRW)];
    [heardView setBackgroundColor:[UIColor clearColor]];
    _tableView.tableHeaderView=heardView;
    self.heardView=heardView;
    UIView *hearActionV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, _GGW+40+100+_JJRW)];
    [hearActionV setBackgroundColor:BGColor];
    [heardView addSubview:hearActionV];
    self.hearActionView=hearActionV;
    
    AdvertView * adView=[[AdvertView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AdvertView"];
    
    adView.delegate=self;
    adView.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [adView setAdInfoWithAry:self.lunboAry];
    [adView adStart];
    UIView *adBGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, _GGW)];
    _adBGView=adBGView;
    [adBGView addSubview:adView];
    [hearActionV addSubview:adBGView];
    CircleViews *circleViews=[[CircleViews alloc]initWithFrame:CGRectMake(0, 0, kWidth,100)];
    
    circleViews.delegate=self;
    UIView *circleViewsBGV=[[UIView alloc]initWithFrame:CGRectMake(0, _GGW, kWidth, 100)];
    [circleViewsBGV addSubview:circleViews];
    [hearActionV addSubview:circleViewsBGV];
    _CBGV=circleViewsBGV;
    _JJRMView =[self JJRMoreView];
    _JJRMView.frame=CGRectMake(0, _GGW+100, kWidth, 40);
    [hearActionV addSubview:_JJRMView];
    _JJRLView=[[YLDHomeJJRCell alloc]init];
    _JJRLView.delegate=self;
    _JJRLView.frame=CGRectMake(0, _GGW+40+100, kWidth, _JJRW);
    
    [hearActionV addSubview:_JJRLView];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.tag=112;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self talbeviewsetRefreshHead];
}
#pragma mark ----------定位相关----------

-(void)openDingweiAction
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.locationManager.distanceFilter = 1.0;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        
    {
        [self.locationManager requestWhenInUseAuthorization]; //使用中授权
        
    }
    
    [self.locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error

{
    //    NSLog(@"%@", error);
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    CLLocation *newLocation = locations[0];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0){
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             
             GetCityDao *citydao=[GetCityDao new];
             [citydao openDataBase];
             APPDELEGATE.cityModel = [citydao getCityCodeByColumn1:city];
             [citydao closeDataBase];
             [self.cityBtn setTitle:APPDELEGATE.cityModel.cityName forState:UIControlStateNormal];
             [self.cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.cityBtn.imageView.image.size.width, 0, self.cityBtn.imageView.image.size.width)];
             [self.cityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.cityBtn.titleLabel.bounds.size.width, 0, -self.cityBtn.titleLabel.bounds.size.width)];

             [self.tableView headerBeginRefreshing];
         } else if (error == nil && [array count] == 0)
         {
//             NSLog(@"No results were returned.");
         } else if (error != nil)
         {
//             NSLog(@"An error occurred = %@", error);
         }
     }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
-(void)talbeviewsetRefreshHead
{
    NSMutableArray *idleImages = [NSMutableArray array];
    
    for (int i = 1; i <= 30; i ++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"runningC%d",i]];
        
        [idleImages addObject:image];
        
    }
    
    
    
    NSMutableArray *pullingImages = [NSMutableArray array];

    UIImage *image = [UIImage imageNamed:@"runningC1"];

    [pullingImages addObject:image];

        __weak typeof(self) weakSelf=self;
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        if (weakSelf.tableView.tableHeaderView!=nil) {
            weakSelf.PageCount=1;
            [weakSelf getDataListWithPageNum:[NSString stringWithFormat:@"%ld",weakSelf.PageCount]];
        }else{
            self.lastTime=nil;
            [weakSelf reloadTableVVVWithLastType];
        }
        
        
    }];
    
    //给MJRefreshStateIdle状态设置一组图片，可以是一张，idleImages为数组
    
    [header setImages:idleImages duration:1.2 forState:MJRefreshStateIdle];

    //[header setImages:idleImages forState:MJRefreshStatePulling];
    //
   [header setImages:idleImages duration:1.2 forState:MJRefreshStateRefreshing];

     self.tableView.mj_header = header;
    
    
    [self.tableView addFooterWithCallback:^{
        [weakSelf reloadTableVVVWithLastType];
    }];
}
#pragma mark ----------悬浮按钮----------
-(void)CreatXuanfuBtn
{
    UIButton *fabuQiuGBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-80, kHeight-170, 70, 70)];
    [fabuQiuGBtn setImage:[UIImage imageNamed:@"shouyeQiugouxuanfu"] forState:UIControlStateNormal];
    [fabuQiuGBtn setImage:[UIImage imageNamed:@"shouyeQiugouxuanfu"] forState:UIControlStateHighlighted];
    [fabuQiuGBtn addTarget:self action:@selector(wodeqiugouFabuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fabuQiuGBtn];
    UIButton *fabuGongyingBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-80, kHeight-240, 70, 70)];
    [fabuGongyingBtn setImage:[UIImage imageNamed:@"shouyeGongyingxuanfu"] forState:UIControlStateNormal];
    [fabuGongyingBtn setImage:[UIImage imageNamed:@"shouyeGongyingxuanfu"] forState:UIControlStateHighlighted];
    [fabuGongyingBtn addTarget:self action:@selector(wodegongyingFabuAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fabuGongyingBtn];
    self.goTopBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, kHeight-100, 50, 50)];
    [self.goTopBtn setImage:[UIImage imageNamed:@"goTopAciotn"] forState:UIControlStateNormal];
    [self.goTopBtn setImage:[UIImage imageNamed:@"goTopAciotn"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.goTopBtn];
    [self.goTopBtn addTarget:self action:@selector(gotopBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.goTopBtn.hidden=YES;
}
#pragma mark ----------发布相关----------
-(void)wodeqiugouFabuBtnAction
{
    if(![APPDELEGATE isNeedLogin])
    {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    YLDFBuyFBViewController *vc=[YLDFBuyFBViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)wodegongyingFabuAction
{
    if(![APPDELEGATE isNeedLogin])
    {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    YLDFSupplyFabuViewController *vc=[YLDFSupplyFabuViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)YLfabuSuccessWithBuyDic:(NSDictionary *)buyDic
{
    
}
-(void)YLfabuSuccessWithSupplyDic:(NSDictionary *)supplydic
{
    
}
-(void)YLfabuSuccessWithContinueType:(NSInteger)type{
    if (type==1) {
        [self wodegongyingFabuAction];
    }else if (type==2)
    {
        [self wodeqiugouFabuBtnAction];
    }
//    else if (type==3)
//    {
//        YLDFEOrderFaBuOneViewController *vc=[YLDFEOrderFaBuOneViewController new];
//        vc.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}
-(void)YLfabuSuccessWithAdministrationType:(NSInteger)type{
    if (type==1) {
        [self mySupplyListAction];
    }else if (type==2)
    {
        [self myBuyLsitAction];
    }
//    else if (type==3)
//    {
//        YLDJJRMyViewController *vc=[YLDJJRMyViewController new];
//        vc.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}
-(void)fabuSuccessWithbuyId:(NSDictionary *)buydic
{
    YLDFabuSuccessViewController *vc=[YLDFabuSuccessViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    vc.delegate=self;
    vc.buyDic=buydic;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)fabuSuccessWithOrderId:(NSNotification *)obj
{

}
-(void)fabusupplyBtnAction
{
    YLDFSupplyFabuViewController *vc=[YLDFSupplyFabuViewController new];
    vc.delegate=self;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)fabuSuccessWithSupplyId:(NSDictionary *)supplydic
{
    YLDFabuSuccessViewController *vc=[YLDFabuSuccessViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    vc.supplyDic=supplydic;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)mySupplyListAction
{
    if(![APPDELEGATE isNeedLogin])
    {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    YLDFMySupplyListViewController *vc=[YLDFMySupplyListViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)myBuyLsitAction
{
    if(![APPDELEGATE isNeedLogin])
    {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    YLDFBuyListViewController *vc=[YLDFBuyListViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
