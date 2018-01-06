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
#import "ZIKStationOrderTableViewCell.h"
#import "YLDTBuyListCell.h"
#import "YLDSsupplyBaseCell.h"
#import "HotBuyModel.h"
#import "HotSellModel.h"
#import "ZIKStationOrderModel.h"
#import "YYModel.h"
#import "SearchViewController.h"
#import "YLDLoginViewController.h"
#import "YLDJPGYSBaseTabBarController.h"
#import "ZIKStationTabBarViewController.h"
#import "YLDGongChengGongSiViewController.h"
#import "ZIKMiaoQiTabBarViewController.h"
#import "YLDMXETabBarViewController.h"
#import "YLDChatBaseTabBarController.h"
#import "YLDZBLmodel.h"
#import "YLDZXLmodel.h"

#import "YLDPenJingMiMuViewController.h"
#import "YLDZaoXingMMViewController.h"
#import "YLDZiCaiShangChengViewController.h"
#import "ZIKFunction.h"
#import "YLDSadvertisementModel.h"
#import "BuyDetialInfoViewController.h"
#import "SellDetialViewController.h"
#import "ZIKStationOrderDetailViewController.h"
#import "YLDSMiaoShangNewsViewController.h"
#import "ZIKOrderViewController.h"
#import "YLDSBigImageVadCell.h"
#import "YLDStextAdCell.h"
#import "ZIKMyShopViewController.h"
#import "YLDSADViewController.h"
#import "ZIKNewsDetialViewController.h"
#import "YLDSMiaoShangNewsViewController.h"
#import "YLDLoginViewController.h"
#import "UINavController.h"
#import "YLDShengJiViewViewController.h"
#import "ZIKMyShopViewController.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "YLDSearchActionViewController.h"
#import "YLDSNewsListNoPicCell.h"
#import "YLDSNewsListOnePicCell.h"
#import "YLDSNewsListThreePicCell.h"
#import "ZIKVoucherCenterViewController.h"
#import "YLDSPinDaoViewController.h"
//朋友圈
#import "SDTimeLineTableViewController.h"

#import "YLDHomeJJRCell.h"
#import "YLDJJrModel.h"
#import "YLDJJRListViewController.h"
#import "YLDJJRDeitalViewController.h"
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
#define TopBtnW 90
@interface YLDSHomePageViewController ()<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,CircleViewsDelegate,AdvertDelegate,YLDSearchActionVCDelegate,YLDHomeJJRCellDelegate,YLDPickLocationDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *searchTopV;
@property (nonatomic,strong)NSMutableArray *orderMArr;//工程订单
@property (nonatomic,strong)NSMutableArray *supplyDataAry;//热门供应
@property (nonatomic,strong)NSArray *BuyDataAry;//热门求购
@property (nonatomic,strong)NSArray *zbDataAry;//招标
@property (nonatomic,strong)NSArray *zxDataAry;//资讯
@property (nonatomic,strong)NSArray *jmDataAry;//加盟
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
@property (nonatomic,strong)YLDZXLmodel *payZBModel;
@property (nonatomic)BOOL paySuccess;
@property (nonatomic,strong)UIButton *goTopBtn;
@property (nonatomic,strong)NSArray *borkers;
@property (nonatomic,assign)NSInteger lastType;
@property (nonatomic,strong)UIButton *ActionVNowBtn;
@property (nonatomic,strong)UIButton *qiugouNowBtn;
@property (nonatomic,copy)NSString *qiugouState;
@property (nonatomic,strong)UIView *qiugouView;
@property (nonatomic,strong)UIButton *cityBtn;
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,copy)NSString *supplyFirstTime;
@property (nonatomic,copy)NSString *supplyLastTime;
@property (nonatomic,copy)NSString *newsFirstTime;
@property (nonatomic,copy)NSString *newsLastTime;
@end

@implementation YLDSHomePageViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (_paySuccess) {
        ZIKNewsDetialViewController *zikNDVC=[[ZIKNewsDetialViewController alloc]init];
        zikNDVC.urlString=_payZBModel.uid;
        zikNDVC.newstitle=_payZBModel.articleCategoryName;
        zikNDVC.newstext=_payZBModel.title;
        zikNDVC.newsimageUrl=[_payZBModel.picAry firstObject];
        zikNDVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:zikNDVC animated:YES];
        _paySuccess=NO;
        _payZBModel =nil;
    }else{
        _paySuccess=NO;
        _payZBModel =nil;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushMessageForSaoMa:) name:@"saosaokanxinwen" object:nil];
    self.PageCount=1;
    self.supplyDataAry=[NSMutableArray array];
    self.orderMArr=[NSMutableArray array];
    self.newsDataAry=[NSMutableArray array];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.locationManager.distanceFilter = 1.0;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        
    {
        //            [self.locationManager requestAlwaysAuthorization]; // 永久授权
        
        [self.locationManager requestWhenInUseAuthorization]; //使用中授权
        
    }
    
    [self.locationManager startUpdatingLocation];
    
    self.qiugouState=@"free";
    self.topActionV=[self creatGBTypeV];
    self.qiugouView=[self creatHomeQiuGouStateView];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,kWidth , kHeight-44) style:UITableViewStylePlain];
#ifdef __IPHONE_11_0
    if ([tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
#endif
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 55)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth, 55)];
    btn.tag=4;
    [btn setTitle:@"查看更多" forState:UIControlStateNormal];
    [btn setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    tableView.tableFooterView =view;
    [tableView setBackgroundColor:BGColor];
    tableView.tag=112;
    tableView.dataSource=self;
    tableView.delegate=self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView=tableView;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    //缓存
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *result = [userDefaults objectForKey:@"homePageCaches1"];
    self.supplyDataAry=[NSMutableArray array];
    if (result) {
        self.zbDataAry=[YLDZBLmodel creatByAry:[result objectForKey:@"tenders"]];
        self.zxDataAry=[YLDZXLmodel yldZXLmodelbyAry:[result objectForKey:@"articles"]];
        NSArray *orderListArr=[[result objectForKey:@"order"] objectForKey:@"orders"];
        [orderListArr enumerateObjectsUsingBlock:^(NSDictionary *orderDic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKStationOrderModel *model = [ZIKStationOrderModel yy_modelWithDictionary:orderDic];
                [model initStatusType];
                [self.orderMArr addObject:model];
        }];
        NSString *orderAdvertisementsStr=[[result objectForKey:@"order"] objectForKey:@"advertisements"];
        NSDictionary *orderAdvertisementsDic=[ZIKFunction dictionaryWithJsonString:orderAdvertisementsStr];
            
        NSArray *orderAdAry=[YLDSadvertisementModel aryWithAry:[orderAdvertisementsDic objectForKey:@"result"]];
        [self.orderMArr addObjectsFromArray:orderAdAry];
        NSDictionary *buydic=[result objectForKey:@"buy"];
        NSString *buyAdvertisementsStr=[buydic objectForKey:@"advertisements"];
        NSDictionary *buyAdvertisementsDic=[ZIKFunction dictionaryWithJsonString:buyAdvertisementsStr];
        NSArray *buyADAry=[YLDSadvertisementModel aryWithAry:buyAdvertisementsDic[@"result"]];
        NSArray *buyDataAry=[HotBuyModel creathotBuyModelAryByAry:[buydic objectForKey:@"buys"]];
        NSArray *borkers = result[@"borkers"];
            self.borkers=[YLDJJrModel yldJJrModelByAry:borkers];
            self.BuyDataAry = [ZIKFunction aryWithMessageAry:buyDataAry withADAry:buyADAry];
        NSDictionary *supply1=[result objectForKey:@"supply"];
        NSArray *supplyAry=[HotSellModel hotSellAryByAry:[supply1 objectForKey:@"supplys"]];
        NSString *supplyAdvertisementsStr=[supply1 objectForKey:@"advertisements"];
        NSDictionary *supplyAdvertisementsDic=[ZIKFunction dictionaryWithJsonString:supplyAdvertisementsStr];
        NSArray *supplyadAry=[YLDSadvertisementModel aryWithAry:[supplyAdvertisementsDic objectForKey:@"result"]];;
        [self.supplyDataAry addObjectsFromArray:[ZIKFunction aryWithMessageAry:supplyAry withADAry:supplyadAry]];
        self.jmDataAry=[result objectForKey:@"joins"];
            
        NSString *carouselsAdvertisementsStr=[result objectForKey:@"carousels"];
        NSDictionary *carouselsAdvertisementsDic=[ZIKFunction dictionaryWithJsonString:carouselsAdvertisementsStr];
        self.lunboAry=[YLDSadvertisementModel aryWithAry:[carouselsAdvertisementsDic objectForKey:@"result"]];

    }
    

    [self.view addSubview:tableView];
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
        weakSelf.PageCount=1;
        [weakSelf getDataListWithPageNum:[NSString stringWithFormat:@"%ld",weakSelf.PageCount]];
    }];
    
    //给MJRefreshStateIdle状态设置一组图片，可以是一张，idleImages为数组
    
    [header setImages:idleImages duration:1.2 forState:MJRefreshStateIdle];
    
    //[header setImages:idleImages forState:MJRefreshStatePulling];
    
    [header setImages:idleImages duration:1.2 forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    self.topView1=[self creatTopSeachV];
    [self.view addSubview:self.topView1];
 
    [self getDataListWithPageNum:@"1"];
    [HTTPCLIENT getNewsClassSuccess:^(id responseObject) {
        RemoveActionV();
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            self.classAry=[[responseObject objectForKey:@"result"] objectForKey:@"ArticleCategory"];
        
            [self topActionWithAry:self.classAry];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySccessAction) name:@"PaySuccessNotification" object:nil];
    
 
    self.goTopBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, kHeight-110, 50, 50)];
    [self.goTopBtn setImage:[UIImage imageNamed:@"goTopAciotn"] forState:UIControlStateNormal];
    [self.goTopBtn setImage:[UIImage imageNamed:@"goTopAciotn"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.goTopBtn];
    [self.goTopBtn addTarget:self action:@selector(gotopBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.goTopBtn.hidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMessageForDingzhiXinXi:) name:@"dingzhixinxituisong" object:nil];
}

-(void)pushMessageForDingzhiXinXi:(NSNotification *)notification
{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}
-(void)gotopBtnAction
{
    [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
}
-(void)paySccessAction
{
    if (self.payZBModel) {
        _paySuccess =YES;
        self.payZBModel.isbuy=1;
        self.payZBModel.readed=YES;
        self.payZBModel.viewTimes+=1;
    }
    
}



#pragma mark ---------TOPBtnAction----------
-(void)topBtnAction:(UIButton *)sender
{
    if (self.nowBtn!=sender) {
        _newsFirstTime=nil;
        _newsLastTime=nil;
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
    [self getNewsdataWithPage:[NSString stringWithFormat:@"%ld",self.PageCount] withzhonglei:dic[@"uid"] withKeyWord:nil];
    
}
-(void)topActionVBtnAction:(UIButton *)sender
{
//    if (sender.selected) {
//        return;
//    }
  
    self.ActionVNowBtn.selected=NO;
    sender.selected=YES;
    self.lastType=sender.tag;
    self.ActionVNowBtn=sender;
    CGRect frame=self.topActionMoveV.frame;
    frame.origin.x=sender.tag*(kWidth/4);
    [UIView animateWithDuration:0.3 animations:^{
        self.topActionMoveV.frame=frame;
        [self reloadTableVVVWithLastType];
    }];
    
    
    
}
-(void)qiugouSteteBtnAction:(UIButton *)sender
{
//    if (sender.selected) {
//        return;
//    }
    self.qiugouNowBtn.selected=NO;
    sender.selected=YES;
    
    self.qiugouNowBtn=sender;
    if (sender.tag==1) {
      self.qiugouState=@"free";
    }
    if (sender.tag==2) {
        self.qiugouState=@"new";
    }
    [self reloadTableVVVWithLastType];
    
}
-(void)reloadTableVVVWithLastType
{
    
    if(_lastType==1)
    {
        ShowActionV();
        [HTTPCLIENT buySearchWithPage:@"1" WithPageSize:@"15" Withgoldsupplier:nil WithproductUid:nil WithproductName:nil WithProvince:nil WithCity:nil WithCounty:nil WithsearchTime:nil WithSearchStatus:self.qiugouState WithAry:nil   Success:^(id responseObject) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            NSString *advertisementsStr=[dic objectForKey:@"advertisements"];
            NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
            NSArray *adary=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];
            
            NSArray *buyzDataAry=[HotBuyModel creathotBuyModelAryByAry:[dic objectForKey:@"buys"]];
            
            if (buyzDataAry.count>0) {
              _BuyDataAry =  [ZIKFunction aryWithMessageAry:buyzDataAry withADAry:adary];
                
            }else{
                _BuyDataAry=@[];
                [ToastView showTopToast:@"已无更多信息"];
            }
            
            RemoveActionV();
            [self.tableView reloadData];
            if (buyzDataAry.count>0) {
                [self.tableView layoutIfNeeded];
                NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:5];
                [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
           
            
           
            dispatch_async(dispatch_get_main_queue(), ^{
            [self changeNav];
                
            });
        } failure:^(NSError *error) {
            RemoveActionV();
            
        }];
    }
    if(_lastType==0)
    {
        ShowActionV();
        [HTTPCLIENT SellListWithWithPageSize:@"20" WithPage:_supplyFirstTime Withgoldsupplier:@"0" WithSerachTime:_supplyLastTime  Success:^(id responseObject) {
            
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            self.supplyFirstTime=dic[@"fristTime"];
            self.supplyLastTime=dic[@"lastTime"];
            NSString *advertisementsStr=[dic objectForKey:@"advertisements"];
            NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
            NSArray *adary=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];
            NSArray *aryzz=[HotSellModel hotSellAryByAry:[dic objectForKey:@"supplys"]];
            if (aryzz.count > 0) {
                [self.supplyDataAry removeAllObjects];
                [self.supplyDataAry addObjectsFromArray:[ZIKFunction aryWithMessageAry:aryzz withADAry:adary]];
                
                
            }

            
            [self.tableView reloadData];
            if (aryzz.count > 0) {
                [self.tableView layoutIfNeeded];
                NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:5];
                
                [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self changeNav];

            });
            RemoveActionV();
        } failure:^(NSError *error) {
            RemoveActionV();
            
        }];

    }
    if(_lastType==2)
    {
        
       [self.tableView reloadData];
       [self.tableView layoutIfNeeded];
        [HTTPCLIENT getHomePageInfoSuccess:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]!=0) {
                
               
                [self.orderMArr removeAllObjects];
                NSDictionary *result = [responseObject objectForKey:@"result"];
               
                NSArray *orderListArr=[[result objectForKey:@"order"] objectForKey:@"orders"];
                NSMutableArray *orderAry=[NSMutableArray array];
                [orderListArr enumerateObjectsUsingBlock:^(NSDictionary *orderDic, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZIKStationOrderModel *model = [ZIKStationOrderModel yy_modelWithDictionary:orderDic];
                    [model initStatusType];
                    [orderAry addObject:model];
                }];
                NSString *orderAdvertisementsStr=[[result objectForKey:@"order"] objectForKey:@"advertisements"];
                NSDictionary *orderAdvertisementsDic=[ZIKFunction dictionaryWithJsonString:orderAdvertisementsStr];
                
                NSArray *orderAdAry=[YLDSadvertisementModel aryWithAry:[orderAdvertisementsDic objectForKey:@"result"]];
                self.orderMArr=[ZIKFunction aryWithMessageAry:orderAry withADAry:orderAdAry andIndex:2];
                [self.tableView reloadData];
                if (self.orderMArr.count > 0) {
                    [self.tableView layoutIfNeeded];
                    NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:5];
                    
                    [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
                
                
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
          [self changeNav];
        });
        RemoveActionV();
       
    }
    if(_lastType==3)
    {
        
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:5];
        
        [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
         [self changeNav];
        });
        RemoveActionV();
        
    }
}

#pragma mark ---------TableView相关----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < 5) {
        return 1;
    }
    if (section == 5) {
        if (_lastType==1) {
            return self.BuyDataAry.count;
        }
        if (_lastType==0) {
            return  self.supplyDataAry.count;
        }
        if (_lastType==2) {
            return self.orderMArr.count;
        }
        if (_lastType==3) {
            return self.newsDataAry.count;
        }
        
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 0.368*kWidth;
    }
    if (indexPath.section==1) {
        return 100;
    }
    if (indexPath.section==2) {
        double  kkk = kWidth*(11/30.f-0.0417);
        return kkk+60+50;
    }
    if (indexPath.section==3) {
        return 0.01;
    }
    if (indexPath.section==4) {
        return 0.01;
    }
    if (indexPath.section==5) {
        if (_lastType==1) {
            id model=self.BuyDataAry[indexPath.row];
            if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
                YLDSadvertisementModel *model=self.BuyDataAry[indexPath.row];
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
            
            
        }
        if (_lastType==0) {
            id model=self.supplyDataAry[indexPath.row];
            if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
                YLDSadvertisementModel * model=self.supplyDataAry[indexPath.row];
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
        if (_lastType==2) {
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
                    return (kWidth-20)*0.24242+25+60;
                }else if (model.adsType==6)
                {
                    return 160;
                }
                
            }else{
                self.tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
                self.tableView.estimatedRowHeight = 185;
                return tableView.rowHeight;
            }

            
        }
        if (_lastType==3) {
            id model=self.newsDataAry[indexPath.row];
            if ([model isKindOfClass:[YLDZXLmodel class]]) {
                YLDZXLmodel *model=self.newsDataAry[indexPath.row];
                if (model.picAry.count<=0) {
                    return 90;
                }
                if (model.picAry.count>0&&model.picAry.count<3) {
                    
                    return 130;
                }
                if (model.picAry.count>=3) {
                    return 180;
                }
            }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
            {
                YLDSadvertisementModel *model=self.newsDataAry[indexPath.row];
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
        }
        
        
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==2) {
        return 40;
    }
    
    if (section==5) {
        if (_lastType==1) {
            return 90;
        }
        if (_lastType==3) {
            return 90;
        }
        return 50;
    }
    if (section==6) {
        return 40;
    }
    if (section==7) {
        return 40;
    }
    if (section==8) {
        return 50;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==2) {
        
        UIView *xxview=[self makeTitleViewWithTitle:@"" AndColor:NavColor andY:0];
        UIButton *jjrtjBuyBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, 270, 36)];
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
        UIButton *moreHotBuyBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-110, 0, 80, 36)];
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
    if (section==5) {
        
        if (_lastType==1) {
            CGRect frame=self.topActionV.frame;
            frame.size.height=100;
            self.topActionV.frame=frame;
            [self.topScrollV removeFromSuperview];
            [self.topActionV addSubview:self.qiugouView];
            return self.topActionV;
        }else if (_lastType==3) {
            CGRect frame=self.topActionV.frame;
            frame.size.height=100;
            self.topActionV.frame=frame;
            [self.qiugouView removeFromSuperview];
            [self.topActionV addSubview:self.topScrollV];
            return self.topActionV;
        }else
        {
            CGRect frame=self.topActionV.frame;
            frame.size.height=50;
            self.topActionV.frame=frame;
            [self.qiugouView removeFromSuperview];
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
    if (indexPath.section==5&&_lastType==0) {
        id model=self.supplyDataAry[indexPath.row];
        
        if ([model isKindOfClass:[HotSellModel class]]) {
            HotSellModel *model=self.supplyDataAry[indexPath.row];
            
            SellDetialViewController *sellDetialViewC=[[SellDetialViewController alloc]initWithUid:model];
            sellDetialViewC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:sellDetialViewC animated:YES];
        }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
        {
            YLDSadvertisementModel *model=self.supplyDataAry[indexPath.row];
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
    if (indexPath.section==5&&_lastType==2) {
        
        id model=self.orderMArr[indexPath.row];
        
        if ([model isKindOfClass:[ZIKStationOrderModel class]]) {
            if (![APPDELEGATE isNeedLogin]) {
                YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
                [ToastView showTopToast:@"请先登录"];
                UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
                
                [self presentViewController:navVC animated:YES completion:^{
                    
                }];
                return;
            }
            
            ZIKStationOrderModel *model=self.orderMArr[indexPath.row];
            ZIKStationOrderDetailViewController *orderDetailVC = [[ZIKStationOrderDetailViewController alloc] init];
            
            orderDetailVC.orderUid   = model.uid;
            orderDetailVC.statusType = model.statusType;
            orderDetailVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:orderDetailVC animated:YES];
        }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
        {
            YLDSadvertisementModel *model=self.orderMArr[indexPath.row];
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
    if (indexPath.section==5&&_lastType==1) {
        id model = self.BuyDataAry[indexPath.row];
        if ([model isKindOfClass:[HotBuyModel class]]) {
            HotBuyModel *model=self.BuyDataAry[indexPath.row];
            BuyDetialInfoViewController *vc=[[BuyDetialInfoViewController alloc]initWithSaercherInfo:model.uid];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
            YLDSadvertisementModel *model=self.BuyDataAry[indexPath.row];
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
    if (indexPath.section==5&&_lastType==3) {
        id model=self.newsDataAry[indexPath.row];
        
        if ([model isKindOfClass:[YLDZXLmodel class]]) {
            YLDZXLmodel *model=self.newsDataAry[indexPath.row];
            if (model.tenderBuy==YES && model.isbuy== 0&&model.tenderPrice>0) {
                if (![APPDELEGATE isNeedLogin]) {
                    YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
                    [ToastView showTopToast:@"请先登录"];
                    UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
                    
                    [self presentViewController:navVC animated:YES completion:^{
                        
                    }];
                    return;
                }
                self.payZBModel=model;
                ZIKVoucherCenterViewController *vc=[[ZIKVoucherCenterViewController alloc]init];
                vc.infoType=4;
                vc.uid=model.uid;
                vc.wareStr=@"查看此招标信息";
                vc.price=[NSString stringWithFormat:@"%.2lf",model.tenderPrice];
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                ZIKNewsDetialViewController *zikNDVC=[[ZIKNewsDetialViewController alloc]init];
                zikNDVC.urlString=model.uid;
                zikNDVC.newstitle=model.articleCategoryName;
                zikNDVC.newstext=model.title;
                zikNDVC.hidesBottomBarWhenPushed=YES;
                zikNDVC.newsimageUrl=[model.picAry firstObject];
                [self.navigationController pushViewController:zikNDVC animated:YES];
            }
        }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
        {
            YLDSadvertisementModel *model=self.newsDataAry[indexPath.row];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        AdvertView *adView=[tableView dequeueReusableCellWithIdentifier:@"AdvertView"];
        if (!adView) {
            adView=[[AdvertView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AdvertView"];
            
            
            adView.delegate=self;
            adView.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [adView setAdInfoWithAry:self.lunboAry];
        [adView adStart];
        return adView;
    }
    if (indexPath.section==1) {
        CircleViews *circleViews=[[CircleViews alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
        circleViews.selectionStyle = UITableViewCellSelectionStyleNone;
        circleViews.delegate=self;
        return circleViews;
    }
    if (indexPath.section==2) {
        YLDHomeJJRCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDHomeJJRCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell=[[YLDHomeJJRCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YLDHomeJJRCell"];
            cell.delegate=self;

        }
        cell.modelAry=self.borkers;
        return cell;
    }
    
    if (indexPath.section==5&&_lastType==2) {
        
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
        
        
    }
    if (indexPath.section==5&&_lastType==1) {
        id model=self.BuyDataAry[indexPath.row];
        if ([model isKindOfClass:[HotBuyModel class]]) {
            YLDTBuyListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDTBuyListCell"];
            if (!cell) {
                cell=[YLDTBuyListCell yldTBuyListCell];
                
            }
            cell.model=model;
            return cell;
        }else if([model isKindOfClass:[YLDSadvertisementModel class]])
        {
            YLDSadvertisementModel *model=self.BuyDataAry[indexPath.row];
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
    if (indexPath.section==5&&_lastType==0) {
        
        id model=self.supplyDataAry[indexPath.row];
        if ([model isKindOfClass:[HotSellModel class]]) {
            YLDSsupplyBaseCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSsupplyBaseCell"];
            if (!cell) {
                cell=[YLDSsupplyBaseCell yldSsupplyBaseCell];
            }
            cell.model=model;
            
            
            return cell;
        }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
        {
            YLDSadvertisementModel * model=self.supplyDataAry[indexPath.row];
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
    if (indexPath.section==5&&_lastType==3) {
        id model=self.newsDataAry[indexPath.row];
        if ([model isKindOfClass:[YLDZXLmodel class]]) {
            YLDZXLmodel *model=self.newsDataAry[indexPath.row];
            if (model.picAry.count<=0) {
                YLDSNewsListNoPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YLDSNewsListNoPicCell"];
                if (!cell) {
                    cell=[YLDSNewsListNoPicCell yldSNewsListNoPicCell];
                    UIView *lineV=[[UIView alloc]initWithFrame:CGRectMake(10, cell.frame.size.height-0.5, kWidth-20, 0.5)];
                    [lineV setBackgroundColor:kLineColor];
                    [cell addSubview:lineV];
                }
                cell.model=model;
                return cell;
            }
            if (model.picAry.count>0&&model.picAry.count<3) {
                YLDSNewsListOnePicCell  *cell= [tableView dequeueReusableCellWithIdentifier:@"YLDSNewsListOnePicCell"];
                if (!cell) {
                    cell = [YLDSNewsListOnePicCell yldSNewsListOnePicCell];
                    UIView *lineV=[[UIView alloc]initWithFrame:CGRectMake(10, cell.frame.size.height-0.5, kWidth-20, 0.5)];
                    [lineV setBackgroundColor:kLineColor];
                    [cell addSubview:lineV];
                }
                cell.model=model;
                return cell;
            }
            if (model.picAry.count>=3) {
                YLDSNewsListThreePicCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSNewsListThreePicCell"];
                if (!cell) {
                    cell=[YLDSNewsListThreePicCell yldSNewsListThreePicCell];
                    UIView *lineV=[[UIView alloc]initWithFrame:CGRectMake(10, cell.frame.size.height-0.5, kWidth-20, 0.5)];
                    [lineV setBackgroundColor:kLineColor];
                    [cell addSubview:lineV];
                }
                cell.model=model;
                return cell;
            }
        }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
        {
            YLDSadvertisementModel *model=self.newsDataAry[indexPath.row];
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
        ZIKOrderViewController *orderVC=[[ZIKOrderViewController alloc]init];
        orderVC.vcTitle=@"工程订单";
        orderVC.title=@" 工程订单 ";
        orderVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
    if (sender.tag==4&&_lastType==1) {
        NSInteger type=3;
        if ([self.qiugouState isEqualToString:@"new"]) {
            type=2;
        }
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
        YLDSMiaoShangNewsViewController *newsVC=[[YLDSMiaoShangNewsViewController alloc]init];
        newsVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:newsVC animated:YES];

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
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, y, kWidth, 36)];
    [view setBackgroundColor:BGColor];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 5, 22)];
    [imageV setBackgroundColor:color];
    [view addSubview:imageV];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 220, 36)];
    titleLab.text=title;
    [titleLab setTextColor:color];
    [titleLab setFont:[UIFont systemFontOfSize:18]];
    [view addSubview:titleLab];
    if ([title isEqualToString:@"热门求购"]) {
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-60, 0, 120,36)];
        [lab setFont:[UIFont systemFontOfSize:14]];
        [lab setTextColor:titleLabColor];
        [lab setTextAlignment:NSTextAlignmentCenter];
        lab.text=@"下拉刷新";
        [view addSubview:lab];
    }
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
            [self getNewsdataWithPage:[NSString stringWithFormat:@"%ld",self.PageCount] withzhonglei:dic[@"uid"] withKeyWord:nil];
            
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
-(UIView *)creatHomeQiuGouStateView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 50, kWidth, 40)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.tag=11;
    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,kWidth/2, 40)];
    [btn1 setTitle:@"免费求购" forState:UIControlStateNormal];
    btn1.tag=1;
    [btn1 addTarget:self action:@selector(qiugouSteteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
    [btn1 setTitleColor:NgreenColor forState:UIControlStateSelected];
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:btn1];

    self.qiugouNowBtn=btn1;
    btn1.selected=YES;

    UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2, 0, kWidth/2, 40)];
    
    [btn2 setTitle:@"精品求购" forState:UIControlStateNormal];

    [btn2 setImage:[UIImage imageNamed:@"jingpinXX"] forState:UIControlStateNormal];
    [btn2 setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
    [btn2 setTitleColor:NgreenColor forState:UIControlStateSelected];
    btn2.tag=2;
    [btn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn2.imageView.image.size.width, 0, btn2.imageView.image.size.width)];
    [btn2 setImageEdgeInsets:UIEdgeInsetsMake(0, btn2.titleLabel.bounds.size.width, 0, -btn2.titleLabel.bounds.size.width)];
    [btn2 addTarget:self action:@selector(qiugouSteteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:btn2];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(kWidth/2, 5, 0.5, 30)];
    [lineView1 setBackgroundColor:kLineColor];
    [view addSubview:lineView1];
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0, 39.5, kWidth, 0.5)];
    [lineView2 setBackgroundColor:kLineColor];
    [view addSubview:lineView2];

    return view;
}
#pragma mark ---------搜索相关----------
-(void)searchBtnAction
{
    YLDSearchActionViewController *yldsaVC=[[YLDSearchActionViewController alloc]init];
    yldsaVC.delegate=self;
    yldsaVC.searchType=3;
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag==112) {

        if (scrollView.contentOffset.y<=1&&scrollView.contentOffset.y<-5) {
            if(self.topView1.hidden==NO)
            {
                self.topView1.hidden=YES;
            }
            
        }else if (scrollView.contentOffset.y<=1&&scrollView.contentOffset.y>=-5) {
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
            
        }else if(scrollView.contentOffset.y>1&&scrollView.contentOffset.y<kWidth*0.368){
            CGFloat xx=scrollView.contentOffset.y/(kWidth*0.368);
            UIImageView *imageV=[self.topView1 viewWithTag:3];
            if (imageV.hidden==NO) {
                imageV.hidden=YES;
            }
            [self.topView1 setBackgroundColor:kRGB(250, 250, 250, 1*xx)];
            if(scrollView.contentOffset.y>50&&scrollView.contentOffset.y<kWidth*0.368)
            {
                UIView *searchV=[self.topView1 viewWithTag:1];
                [searchV setBackgroundColor:[UIColor whiteColor]];
                UILabel *lab=[searchV viewWithTag:11];
                [lab setTextColor:kRGB(153, 153,153, 1)];
                
            }
           
            

        }else if(scrollView.contentOffset.y>=kWidth*0.368&&scrollView.contentOffset.y<=kWidth*0.368+150){
            [self changeNav];
        }
        
        if(scrollView.contentOffset.y>kWidth*0.368+100){
            if (scrollView.frame.origin.y<64) {
                CGRect frame=self.tableView.frame;
                frame.origin.y=64;
                frame.size.height=kHeight-47-64;
                self.tableView.frame=frame;
                
            }
        }else{
            if (scrollView.frame.origin.y>=64) {
                CGRect frame=self.tableView.frame;
                frame.origin.y=0;
                frame.size.height=kHeight-47;
                self.tableView.frame=frame;
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
#pragma mark ---------新闻接口----------
-(void)getNewsdataWithPage:(NSString *)page withzhonglei:(NSString *)zhonglei withKeyWord:(NSString *)keyWrod
{
    [HTTPCLIENT getNewsListWitharticleCategory:zhonglei pageNumber:_newsFirstTime pageSize:@"15" keywords:_newsLastTime Success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            
            NSDictionary *result=[responseObject objectForKey:@"result"];
            _newsFirstTime=[result objectForKey:@"firstTime"];
            _newsLastTime=[result objectForKey:@"lastTime"];
            NSString *AdvertisementsStr=[result objectForKey:@"advertisements"];
            NSDictionary *AdvertisementsDic=[ZIKFunction dictionaryWithJsonString:AdvertisementsStr];
            NSArray *adAry=[YLDSadvertisementModel aryWithAry:[AdvertisementsDic objectForKey:@"result"]];
            NSArray *newsAry=[YLDZXLmodel yldZXLmodelbyAry:[result objectForKey:@"article"]];
            if (newsAry.count>0) {
                [self.newsDataAry removeAllObjects];
            }else if([page isEqualToString:@"1"])
            {
                [self.newsDataAry removeAllObjects];
            }
            [self.newsDataAry addObjectsFromArray:[ZIKFunction aryWithMessageAry:newsAry withADAry:adAry andIndex:2]];
            
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        if(self.what==YES)
        {
            [self.tableView reloadData];
            if (self.newsDataAry.count > 0) {
                [self.tableView layoutIfNeeded];
                NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:5];
                
                [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        ;
        }
        
        
        self.what=YES;
    } failure:^(NSError *error) {
        
    }];
}

-(void)getDataListWithPageNum:(NSString *)num
{
    [HTTPCLIENT getHomePageInfoSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]!=0) {
            
                [self.supplyDataAry removeAllObjects];
                [self.orderMArr removeAllObjects];
            NSDictionary *result = [responseObject objectForKey:@"result"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:result forKey:@"homePageCaches1"];
            [userDefaults synchronize];

            NSArray *borkers = result[@"borkers"];
            self.borkers=[YLDJJrModel yldJJrModelByAry:borkers];
                self.zbDataAry=[YLDZBLmodel creatByAry:[result objectForKey:@"tenders"]];
                self.zxDataAry=[YLDZXLmodel yldZXLmodelbyAry:[result objectForKey:@"articles"]];
                NSArray *orderListArr=[[result objectForKey:@"order"] objectForKey:@"orders"];
            NSMutableArray *orderAry=[NSMutableArray array];
                [orderListArr enumerateObjectsUsingBlock:^(NSDictionary *orderDic, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZIKStationOrderModel *model = [ZIKStationOrderModel yy_modelWithDictionary:orderDic];
                    [model initStatusType];
                    [orderAry addObject:model];
                }];
            NSString *orderAdvertisementsStr=[[result objectForKey:@"order"] objectForKey:@"advertisements"];
            NSDictionary *orderAdvertisementsDic=[ZIKFunction dictionaryWithJsonString:orderAdvertisementsStr];
            
            NSArray *orderAdAry=[YLDSadvertisementModel aryWithAry:[orderAdvertisementsDic objectForKey:@"result"]];
            self.orderMArr=[ZIKFunction aryWithMessageAry:orderAry withADAry:orderAdAry andIndex:2];
            
            NSDictionary *buydic=[result objectForKey:@"buy"];
            
            NSString *buyAdvertisementsStr=[buydic objectForKey:@"advertisements"];
            NSDictionary *buyAdvertisementsDic=[ZIKFunction dictionaryWithJsonString:buyAdvertisementsStr];
            NSArray *buyADAry=[YLDSadvertisementModel aryWithAry:buyAdvertisementsDic[@"result"]];
            NSArray *buyDataAry=[HotBuyModel creathotBuyModelAryByAry:[buydic objectForKey:@"buys"]];
            NSMutableArray *tempAry =nil;
            if (buyADAry.count>0) {
              tempAry = [ZIKFunction aryWithMessageAry:buyDataAry withADAry:[NSArray arrayWithObject:[buyADAry firstObject]]];
            }else{
                tempAry=[NSMutableArray arrayWithArray:buyDataAry];
            }
            
            if (buyADAry.count>1) {
                [tempAry addObject:[buyADAry lastObject]];
            }
            self.BuyDataAry=tempAry;
                NSDictionary *supply1=[result objectForKey:@"supply"];
                NSArray *supplyAry=[HotSellModel hotSellAryByAry:[supply1 objectForKey:@"supplys"]];
            NSString *supplyAdvertisementsStr=[supply1 objectForKey:@"advertisements"];
            NSDictionary *supplyAdvertisementsDic=[ZIKFunction dictionaryWithJsonString:supplyAdvertisementsStr];
            NSArray *supplyadAry=[YLDSadvertisementModel aryWithAry:[supplyAdvertisementsDic objectForKey:@"result"]];
            [self.supplyDataAry addObjectsFromArray:[ZIKFunction aryWithMessageAry:supplyAry withADAry:supplyadAry]];
                self.jmDataAry=[result objectForKey:@"joins"];
            NSString *carouselsAdvertisementsStr=[result objectForKey:@"carousels"];
            NSDictionary *carouselsAdvertisementsDic=[ZIKFunction dictionaryWithJsonString:carouselsAdvertisementsStr];
            self.lunboAry=[YLDSadvertisementModel aryWithAry:[carouselsAdvertisementsDic objectForKey:@"result"]];

                
            [self.tableView reloadData];

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
        //self.saomiaoLabel.text = qrString;
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
        //self.saomiaoLabel.text = @"fail~";
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
            ZIKStationOrderDetailViewController *orderDetailVC = [[ZIKStationOrderDetailViewController alloc] init];
            
            orderDetailVC.orderUid   = uid;
            orderDetailVC.statusType = 1;
            orderDetailVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:orderDetailVC animated:YES];
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
        BuyDetialInfoViewController *buydetialVC=[[BuyDetialInfoViewController alloc]
                                                  initWithSaercherInfo:uid];
        buydetialVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:buydetialVC animated:YES];
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
        ZIKNewsDetialViewController *zikNDVC=[[ZIKNewsDetialViewController alloc]init];
        zikNDVC.hidesBottomBarWhenPushed=YES;
        zikNDVC.urlString=uid;
        
        [self.navigationController pushViewController:zikNDVC animated:YES];
        
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
#pragma mark ----------定位相关----------
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

@end
