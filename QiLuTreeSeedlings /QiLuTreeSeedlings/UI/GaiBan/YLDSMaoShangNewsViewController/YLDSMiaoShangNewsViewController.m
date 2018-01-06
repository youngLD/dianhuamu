//
//  YLDSMiaoShangNewsViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/21.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSMiaoShangNewsViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "ZIKFunction.h"
#import "KMJRefresh.h"
#import "YLDSNewsListNoPicCell.h"
#import "YLDSNewsListOnePicCell.h"
#import "YLDSNewsListThreePicCell.h"
#import "YLDStextAdCell.h"
#import "YLDSBigImageVadCell.h"
#import "ZIKNewsDetialViewController.h"
#import "ZIKMyShopViewController.h"
#import "YLDSADViewController.h"
#import "ZIKVoucherCenterViewController.h"
#import "YLDLoginViewController.h"
#import "UINavController.h"
#import "YLDSPinDaoViewController.h"
#import "YLDSMyFollowViewController.h"
#import "YLDTADThreePicCell.h"
#import "YLDTLeftTextAdCell.h"
#import "YLDTMoreBigImageADCell.h"
#define TopBtnW 90
@interface YLDSMiaoShangNewsViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSArray *classAry;
@property (nonatomic,strong) NSMutableArray *newsDataAry;
@property (nonatomic,assign) NSInteger pageCount;
@property (nonatomic,strong)UIButton *nowBtn;
@property (nonatomic,strong)UIScrollView *topScrollV;
@property (nonatomic,strong)UIScrollView *bottomScrollV;
@property (nonatomic,strong)YLDZXLmodel *payZBModel;
@property (nonatomic)BOOL paySuccess;
@property (nonatomic,strong)UIButton *goTopBtn;
@property (nonatomic,copy)NSString *firstTime;
@property (nonatomic,copy)NSString *lastTime;
@end

@implementation YLDSMiaoShangNewsViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PaySuccessNotification" object:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        RemoveActionV();
    if (_paySuccess) {
        ZIKNewsDetialViewController *zikNDVC=[[ZIKNewsDetialViewController alloc]init];
        zikNDVC.urlString=_payZBModel.uid;
        zikNDVC.newstitle=_payZBModel.articleCategoryName;
        zikNDVC.newstext=_payZBModel.title;
        zikNDVC.newsimageUrl=[_payZBModel.picAry firstObject];
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
    self.vcTitle=@"苗商头条";
    self.rightBarBtnTitleString=@"我的关注";
    __weak typeof(self)weakself=self;
    self.rightBarBtnBlock = ^{
        if ([APPDELEGATE isNeedLogin]) {
            YLDSMyFollowViewController *vc=[YLDSMyFollowViewController new];
            vc.hidesBottomBarWhenPushed=YES;
            [weakself.navigationController pushViewController:vc animated:YES];

        }else{
            YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
            [ToastView showTopToast:@"请先登录"];
            UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
            
            [weakself presentViewController:navVC animated:YES completion:^{
                
            }];

        }
};

    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.newsDataAry=[NSMutableArray array];
  
    ShowActionV();
    UIScrollView *bottomSCV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+50, kWidth, kHeight-114)];
    bottomSCV.delegate=self;
    bottomSCV.tag=111;
    self.bottomScrollV=bottomSCV;
    [self.view addSubview:bottomSCV];
    [HTTPCLIENT getNewsClassSuccess:^(id responseObject) {
        RemoveActionV();
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            self.classAry=[[responseObject objectForKey:@"result"] objectForKey:@"ArticleCategory"];
            [self bottomScrollvAddViewWithAry:self.classAry];
            [self topActionWithAry:self.classAry];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
    self.goTopBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, kHeight-80, 50, 50)];
    [self.goTopBtn setImage:[UIImage imageNamed:@"goTopAciotn"] forState:UIControlStateNormal];
    [self.goTopBtn setImage:[UIImage imageNamed:@"goTopAciotn"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.goTopBtn];
    [self.goTopBtn addTarget:self action:@selector(gotopBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.goTopBtn.hidden=YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySccessAction) name:@"PaySuccessNotification" object:nil];
}
-(void)gotopBtnAction
{
        UITableView *actionTableView = [self.bottomScrollV viewWithTag:self.nowBtn.tag + 200];
    [actionTableView setContentOffset:CGPointMake(0,0) animated:YES];
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
-(void)topActionWithAry:(NSArray *)ary
{
    UIScrollView *topScrollV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    [topScrollV setContentSize:CGSizeMake(TopBtnW*ary.count+56, 0)];
    [topScrollV setBackgroundColor:BGColor];
    [self.view addSubview:topScrollV];
    
    
    
    topScrollV.userInteractionEnabled=YES;
    topScrollV.showsVerticalScrollIndicator=NO;
    topScrollV.showsHorizontalScrollIndicator=NO;
    self.topScrollV=topScrollV;
    
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(i*TopBtnW, 0, TopBtnW, 50)];
        btn.tag=i+1;
        [btn.titleLabel setFont:[UIFont systemFontOfSize:19]];
        [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
        [btn setTitle:dic[@"name"] forState:UIControlStateSelected];
        [btn setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
        [btn setTitleColor:NavColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [topScrollV addSubview:btn];
        if (self.actionClassUid.length>0) {
            if ([self.actionClassUid isEqualToString:dic[@"uid"]]) {
                self.nowBtn=btn;
                [self topBtnAction:btn];
            }
        }else{
            if (i==0) {
                self.nowBtn=btn;
                [self topBtnAction:btn];
            }
        }
        
    }
    UIButton *dingyiBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-56, 64, 56, 50)];
    [dingyiBtn addTarget:self action:@selector(pingdaoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [dingyiBtn setImage:[UIImage imageNamed:@"zidingyianniu"] forState:UIControlStateNormal];
    [self.view addSubview:dingyiBtn];
    
}
-(void)pingdaoBtnAction
{
    YLDSPinDaoViewController *pingdaoVC=[[YLDSPinDaoViewController alloc]init];
    pingdaoVC.classAry=self.classAry;
    [self presentViewController:pingdaoVC animated:YES completion:^{
        
    }];
}
-(void)bottomScrollvAddViewWithAry:(NSArray *)ary
{
    [self.bottomScrollV setContentSize:CGSizeMake(kWidth*ary.count, 0)];
    self.bottomScrollV.pagingEnabled = YES;
    for (int i=0; i<ary.count; i++) {
        UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(kWidth*i, 0, kWidth, kHeight-114)];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.tag=201+i;
        tableView.separatorColor = kLineColor;
        tableView.separatorInset = UIEdgeInsetsMake(0,10, 0,10);        // 设置端距，这里表示separator离左边和右边均10像素
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        __weak typeof(self) weakself=self;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [tableView setTableFooterView:view];
        __weak typeof(tableView) weaktableView=tableView;
        [tableView addHeaderWithCallback:^{
            weakself.pageCount=1;
            self.goTopBtn.hidden=YES;
            NSInteger index=tableView.tag-201;
            NSDictionary *dic=self.classAry[index];
            [weakself getNewsdataWithPage:[NSString stringWithFormat:@"%ld",weakself.pageCount] withzhonglei:dic[@"uid"] withKeyWord:nil andTalbeView:weaktableView];
        }];
        [tableView addFooterWithCallback:^{
            weakself.pageCount+=1;
            NSInteger index=weaktableView.tag-201;
            NSDictionary *dic=self.classAry[index];
            [weakself getNewsdataWithPage:[NSString stringWithFormat:@"%ld",weakself.pageCount] withzhonglei:dic[@"uid"] withKeyWord:nil andTalbeView:weaktableView];
        }];
        [self.bottomScrollV addSubview:tableView];
    }
}
-(void)topBtnAction:(UIButton *)sender
{
    
    if (self.nowBtn!=sender) {
        _lastTime=nil;
        _firstTime=nil;
        [self.newsDataAry removeAllObjects];
    }
    self.nowBtn.selected=NO;
    sender.selected=YES;
    self.nowBtn=sender;
    
    [self.bottomScrollV setContentOffset:CGPointMake(kWidth*(sender.tag-1), 0) animated:YES];
    UITableView *actionTableView = [self.bottomScrollV viewWithTag:sender.tag + 200];
    [actionTableView headerBeginRefreshing];
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
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsDataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model=self.newsDataAry[indexPath.row];
    if ([model isKindOfClass:[YLDZXLmodel class]]) {
        YLDZXLmodel *model=self.newsDataAry[indexPath.row];
        if (model.picAry.count<=0) {
            YLDSNewsListNoPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YLDSNewsListNoPicCell"];
            if (!cell) {
                cell=[YLDSNewsListNoPicCell yldSNewsListNoPicCell];
            }
            cell.model=model;
            return cell;
        }
        if (model.picAry.count>0&&model.picAry.count<3) {
            YLDSNewsListOnePicCell  *cell= [tableView dequeueReusableCellWithIdentifier:@"YLDSNewsListOnePicCell"];
            if (!cell) {
                cell = [YLDSNewsListOnePicCell yldSNewsListOnePicCell];
            }
            cell.model=model;
            return cell;
        }
        if (model.picAry.count>=3) {
            YLDSNewsListThreePicCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSNewsListThreePicCell"];
            if (!cell) {
                cell=[YLDSNewsListThreePicCell yldSNewsListThreePicCell];
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
        UITableViewCell *cell=[UITableViewCell new];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ZIKNewsDetialViewController *zikNDVC=[[ZIKNewsDetialViewController alloc]init];
            zikNDVC.urlString=model.uid;
            zikNDVC.newstitle=model.articleCategoryName;
            zikNDVC.newstext=model.title;
            zikNDVC.newsimageUrl=[model.picAry firstObject];
            [self.navigationController pushViewController:zikNDVC animated:YES];
        }
        
    }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
    {
       YLDSadvertisementModel *model=self.newsDataAry[indexPath.row];
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
-(void)getNewsdataWithPage:(NSString *)page withzhonglei:(NSString *)zhonglei withKeyWord:(NSString *)keyWrod andTalbeView:(UITableView *)tableview
{
    if ([zhonglei isEqualToString:@"879999D6-65A4-4B4E-8135-D29965778C45"]) {
        _firstTime=page;
    }
    [HTTPCLIENT getNewsListWitharticleCategory:zhonglei pageNumber:_firstTime pageSize:@"15" keywords:_lastTime Success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if (self.pageCount==1) {
                [self.newsDataAry removeAllObjects];
            }
            NSDictionary *result=[responseObject objectForKey:@"result"];
            NSString *advertisementsStr=[result objectForKey:@"advertisements"];
            NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
            NSArray *adAry=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];
            _firstTime=[result objectForKey:@"firstTime"];
            _lastTime=[result objectForKey:@"lastTime"];
            NSArray *newsAry=[YLDZXLmodel yldZXLmodelbyAry:[result objectForKey:@"article"]];
            [self.newsDataAry addObjectsFromArray:[ZIKFunction aryWithMessageAry:newsAry withADAry:adAry andIndex:2]];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        [tableview reloadData];
        [tableview footerEndRefreshing];
        [tableview headerEndRefreshing];
    } failure:^(NSError *error) {
        [tableview footerEndRefreshing];
    }];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag>=200) {
        if (scrollView.contentOffset.y>kHeight&&self.goTopBtn.hidden==YES) {
            self.goTopBtn.hidden=NO;
        }
        if (scrollView.contentOffset.y<kHeight&&self.goTopBtn.hidden==NO) {
            self.goTopBtn.hidden=YES;
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag==111) {
        NSInteger index=scrollView.contentOffset.x/kWidth;
        if (index+1==self.nowBtn.tag) {
            return;
        }else if(index<self.classAry.count)
        {
            UIButton *btn=[self.topScrollV viewWithTag:index+1];
            [self topBtnAction:btn];
        }
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
