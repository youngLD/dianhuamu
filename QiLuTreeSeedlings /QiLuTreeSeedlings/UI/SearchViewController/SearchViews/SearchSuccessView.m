//
//  SearchSuccessView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/1.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SearchSuccessView.h"
#import "KMJRefresh.h"
#import "SellSearchTableViewCell.h"
#import "HttpClient.h"
#import "UIDefines.h"
#import "HotSellModel.h"
#import "HotBuyModel.h"
#import "YLDShopListModel.h"
#import "YLDShopListTableViewCell.h"
#import "BuySearchTableViewCell.h"

#import "ZIKQiugouMoreShareView.h"//分组分享view
#import "YLDSsupplyBaseCell.h"
#import "YLDSadvertisementModel.h"
#import "ZIKFunction.h"
#import "YLDTBuyListCell.h"
#import "YLDSBigImageVadCell.h"
#import "YLDStextAdCell.h"
#import "UIButton+ZIKEnlargeTouchArea.h"

#import "YLDTADThreePicCell.h"
#import "YLDTLeftTextAdCell.h"
#import "YLDTMoreBigImageADCell.h"
@interface SearchSuccessView()<UITableViewDataSource,UITableViewDelegate,ZIKQiugouMoreShareViewDelegate>//ZIKQiugouMoreShareViewDelegate分组分享代理
@property (nonatomic,strong)UITableView *selfTableView;
@property (nonatomic,strong)NSMutableArray *sellDataAry;
@property (nonatomic,strong)NSMutableArray *buyDataAry;
@property (nonatomic,strong)NSMutableArray *shopDataAry;
@property (nonatomic)NSInteger PageCount;
@property (nonatomic) NSInteger status;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,weak)UIView *moveView;
@property (nonatomic, strong) ZIKQiugouMoreShareView *shareView;//分组分享新增

@property (nonatomic) NSInteger sss;
@property (nonatomic,copy) NSString * fristTime;
@property (nonatomic,copy) NSString * lastTime;
@end
@implementation SearchSuccessView
-(void)dealloc
{
    self.selfTableView=nil;
    self.searchStr=nil;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.searchType=1;
        self.PageCount=1;
        self.searchBAT=1;
        self.status=1;
        self.searchStatus=@"free";
        UITableView *pullTableView =[[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
        pullTableView.delegate=self;
        pullTableView.dataSource=self;
        [pullTableView setBackgroundColor:BGColor];

        self.selfTableView=pullTableView;
        __weak typeof(self) weakSelf=self;
        [pullTableView addHeaderWithCallback:^{
            weakSelf.PageCount=1;
    
            if (weakSelf.searchBAT==1) {
                
                [weakSelf getListData];
                weakSelf.status=1;
                return;
            }
            if (weakSelf.searchBAT==2) {
                [weakSelf searchByScringList];
            }
        }];
        [pullTableView addFooterWithCallback:^{
            weakSelf.PageCount++;
            if (weakSelf.searchBAT==1) {
                [weakSelf getListData];
               
            }
            if (weakSelf.searchBAT==2) {
                [weakSelf searchByScringList];
            }
        }];
        [pullTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:pullTableView];
        self.sellDataAry=[NSMutableArray array];
        self.buyDataAry=[NSMutableArray array];
        //新增代码（分组分享）
        self.backgroundColor = [UIColor whiteColor];
        ZIKQiugouMoreShareView *shareView = [ZIKQiugouMoreShareView instanceShowShareView];
        shareView.frame = CGRectMake(0, self.frame.size.height-50, kWidth, 50);
        [shareView.selectTimeButton setEnlargeEdgeWithTop:10 right:0 bottom:10 left:0];
        shareView.delegate = self;
        [self addSubview:shareView];
        self.shareView = shareView;
        self.shareView.hidden = YES;
         //新增代码（分组分享）end
         

    }
    return self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchType==1) {
       return self.sellDataAry.count;
    }else if(self.searchType==2)
    {
        return self.buyDataAry.count;
    }else{
        return 0;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchType==1) {
        if (indexPath.row+1>self.sellDataAry.count) {
            if (indexPath.row+1<=self.buyDataAry.count) {
                id model=self.buyDataAry[indexPath.row];
                if ([model isKindOfClass:[HotBuyModel class]]) {
                    YLDTBuyListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDTBuyListCell"];
                    if (!cell) {
                        cell=[YLDTBuyListCell yldTBuyListCell];
                        
                    }
                    cell.model=model;
                    return cell;
                }else if([model isKindOfClass:[YLDSadvertisementModel class]])
                {
                    YLDSadvertisementModel *model=self.buyDataAry[indexPath.row];
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
        }else{
            id model=self.sellDataAry[indexPath.row];
            if ([model isKindOfClass:[HotSellModel class]]) {
                YLDSsupplyBaseCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSsupplyBaseCell"];
                if (!cell) {
                    cell=[YLDSsupplyBaseCell yldSsupplyBaseCell];
                }
                cell.model=model;
                
                
                return cell;
            }else if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
                YLDSadvertisementModel *model=self.sellDataAry[indexPath.row];
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
        

    }else if (self.searchType==2)
    {
        if (indexPath.row+1<=self.buyDataAry.count) {
            id model=self.buyDataAry[indexPath.row];
            if ([model isKindOfClass:[HotBuyModel class]]) {
                YLDTBuyListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDTBuyListCell"];
                if (!cell) {
                    cell=[YLDTBuyListCell yldTBuyListCell];
                    
                }
                cell.model=model;
                return cell;
            }else if([model isKindOfClass:[YLDSadvertisementModel class]])
            {
                YLDSadvertisementModel *model=self.buyDataAry[indexPath.row];
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
        }else{
            UITableViewCell *cell=[UITableViewCell new];
            return cell;
        }
        
        
    }
    
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchType==1&&indexPath.row+1<=self.sellDataAry.count) {
        
        id model=self.sellDataAry[indexPath.row];
         if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
            YLDSadvertisementModel *model=self.sellDataAry[indexPath.row];
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
             return 190;
         }
    }else if (self.searchType==2&&indexPath.row+1<=self.buyDataAry.count)
    {
        id model=self.buyDataAry[indexPath.row];
        if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
            YLDSadvertisementModel *model=self.buyDataAry[indexPath.row];
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

    return 44;
}



- (void)getListData
{
    
    if (self.searchType==1) {
        ShowActionV();
        HotSellModel *model=[self.sellDataAry lastObject];
        NSString *searhTimeStr;
        if (self.PageCount>1) {
            searhTimeStr=model.searchtime;
        }
        
        [HTTPCLIENT SellListWithWithPageSize:@"10" WithPage:self.fristTime Withgoldsupplier:@"0" WithSerachTime:self.lastTime  Success:^(id responseObject) {
            if (![[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                RemoveActionV();
                
                [self.selfTableView headerEndRefreshing];
                [self.selfTableView footerEndRefreshing];
                return ;
            }
            
            
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            self.fristTime=dic[@"fristTime"];
            self.lastTime=dic[@"lastTime"];
            NSString *advertisementsStr=[dic objectForKey:@"advertisements"];
            NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
            NSArray *adary=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];
            NSArray *aryzz=[HotSellModel hotSellAryByAry:[dic objectForKey:@"supplys"]];
            if (aryzz.count > 0) {
                if(self.PageCount==1)
                {
                    NSMutableArray *ary=[NSMutableArray array];
                    NSArray *aryyy=[ZIKFunction aryWithMessageAry:aryzz withADAry:adary];
                    [ary addObjectsFromArray:aryyy];
                    [ary addObjectsFromArray:self.sellDataAry];
                    [self.sellDataAry removeAllObjects];
                    [self.sellDataAry addObjectsFromArray:ary];
                    
                    
                }else
                {
                    [self.sellDataAry addObjectsFromArray:[ZIKFunction aryWithMessageAry:aryzz withADAry:adary]];
                }
 
                
            }else{
                [ToastView showTopToast:@"已无更多信息"];
               
            }
            
            RemoveActionV();
            
            [self.selfTableView headerEndRefreshing];
            [self.selfTableView footerEndRefreshing];
            [self.selfTableView reloadData]; 
        } failure:^(NSError *error) {
            RemoveActionV();
            [self.selfTableView headerEndRefreshing];
            [self.selfTableView footerEndRefreshing];
        }];
    }
    if (self.searchType==2) {
        ShowActionV();
        HotBuyModel *model=[self.buyDataAry lastObject];
        NSString *searhTimeStr;
        if (self.PageCount>1) {
            searhTimeStr=model.searchTime;
        }
        
        [HTTPCLIENT buySearchWithPage:[NSString stringWithFormat:@"%ld",self.PageCount] WithPageSize:@"11" Withgoldsupplier:nil WithproductUid:nil WithproductName:nil WithProvince:nil WithCity:nil WithCounty:nil WithsearchTime:searhTimeStr WithSearchStatus:self.searchStatus WithAry:nil   Success:^(id responseObject) {
           // NSLog(@"%@",responseObject);
            if(self.PageCount==1)
            {
                [self.buyDataAry removeAllObjects];
               
            }
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            self.status= [[dic objectForKey:@"status"] integerValue];

            self.sss=1;

            NSString *advertisementsStr=[dic objectForKey:@"advertisements"];
            NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
            NSArray *buyADAry=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];
            NSArray *buyzDataAry=[HotBuyModel creathotBuyModelAryByAry:[dic objectForKey:@"buys"]];
            
            if (buyzDataAry.count>0) {
              [self.buyDataAry addObjectsFromArray:[ZIKFunction aryWithMessageAry:buyzDataAry withADAry:buyADAry]];
                
            }else{
                [ToastView showTopToast:@"已无更多信息"];
            }
            
            RemoveActionV();
            [self.selfTableView reloadData];
            [self.selfTableView headerEndRefreshing];
            [self.selfTableView footerEndRefreshing];
        } failure:^(NSError *error) {
            RemoveActionV();
            [self.selfTableView headerEndRefreshing];
            [self.selfTableView footerEndRefreshing];
        }];
    }
   
}

-(void)searchViewActionWithSearchType:(NSInteger)type
{
    //新增代码（分组分享）
    if (type == 2) {
        [self showShareView];

    }else{
        [self hiddingShareView];
        self.lastTime=nil;
        self.fristTime=nil;
        [self.sellDataAry removeAllObjects];
    }
    //新增代码（分组分享）end
   
    self.searchType=type;
    self.PageCount=1;
    self.searchBAT=1;
    [self getListData];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.searchType==2) {
        if (self.sss==5||self.sss==6) {
            return 60;
        }
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view;
    if (self.searchType==2) {
        if (self.sss==5||self.sss==6) {
            view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 110)];
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, kWidth-80, 60)];
            [view setBackgroundColor:BGColor];
            [lab setTextColor:NavYellowColor];
            [lab setText:@"没有找到最新求购信息，以下是免费的订单，供您参考。"];
            [lab setFont:[UIFont systemFontOfSize:15]];
            lab.numberOfLines=0;
            [view addSubview:lab];

            self.sss++;

            return view;
        }
        return self.topView;
    }
    return view;
}
-(void)searchViewActionWith:(NSString *)searchStr AndSearchType:(NSInteger)type
{

    if (type==2) {
        [self showShareView];
    }else{
        [self hiddingShareView];
        self.lastTime=nil;
        self.fristTime=nil;
        [self.sellDataAry removeAllObjects];
    }
    if (searchStr.length==0) {
        self.searchBAT=1;
    }else{
      self.searchBAT=2;
    }

     self.PageCount=1;
    
    self.searchStr=searchStr;
    self.searchType=type;
    
    [self.selfTableView headerBeginRefreshing];
    
    
}
- (void)searchByScringList
{
    if (self.searchStr.length>0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *searchHistoryAry=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"searchHistoryAry"]];
        if (![searchHistoryAry containsObject:self.searchStr]) {
            if (searchHistoryAry.count<5) {
                [searchHistoryAry addObject:self.searchStr];
                [userDefaults setObject:searchHistoryAry forKey:@"searchHistoryAry"];
                [userDefaults synchronize];
            }else
            {
                [searchHistoryAry addObject:self.searchStr];
                [searchHistoryAry removeObjectAtIndex:0];
                [userDefaults setObject:searchHistoryAry forKey:@"searchHistoryAry"];
                [userDefaults synchronize];
            }
        }else{
            [searchHistoryAry removeObject:self.searchStr];
            [searchHistoryAry addObject:self.searchStr];
            [userDefaults setObject:searchHistoryAry forKey:@"searchHistoryAry"];
            [userDefaults synchronize];
            
        }
 
    }
    
    if (self.searchType==1) {
        ShowActionV();
        NSString *saerchTime;
        HotSellModel *model=[self.sellDataAry lastObject];
        if (self.PageCount>1) {
            saerchTime=model.searchtime;
        }
        [HTTPCLIENT sellSearchWithPage:self.fristTime WithPageSize:@"10" Withgoldsupplier:self.goldsupplier WithProductUid:self.productUid WithProductName:self.searchStr WithProvince:self.province WithCity:self.City WithCounty:self.county WithSearchTime:self.lastTime  WithAry:self.shaixuanAry  Success:^(id responseObject) {
            // NSLog(@"%@",responseObject);
            
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            NSString *advertisementsStr=[dic objectForKey:@"advertisements"];
            NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
            NSArray *adary=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];

            NSArray *aryzz=[HotSellModel hotSellAryByAry:[dic objectForKey:@"supplys"]];
            if (aryzz.count > 0) {
                
                if(self.PageCount==1)
                {
                    NSArray *aryyy=[ZIKFunction aryWithMessageAry:aryzz withADAry:adary];
                    NSMutableArray *tempAry=[NSMutableArray array];
                    [tempAry addObjectsFromArray:aryyy];
                    [tempAry addObjectsFromArray:self.sellDataAry];
                    [self.sellDataAry removeAllObjects];
                    [self.sellDataAry addObjectsFromArray:tempAry];
                    
                }else
                {
                    [self.sellDataAry addObjectsFromArray:[ZIKFunction aryWithMessageAry:aryzz withADAry:adary]];
                }
                
            }else{
                [ToastView showTopToast:@"已无更多信息"];
                
            }
            
            RemoveActionV();

            [self.selfTableView reloadData];
            [self.selfTableView headerEndRefreshing];
            [self.selfTableView footerEndRefreshing];
        } failure:^(NSError *error) {
            RemoveActionV();
            [self.selfTableView headerEndRefreshing];
            [self.selfTableView footerEndRefreshing];
        }];
        
    }
    if (self.searchType==2) {
        ShowActionV();
        HotBuyModel *model=[self.buyDataAry lastObject];
        NSString *searhTimeStr;
        if (self.PageCount>1) {
            searhTimeStr=model.searchTime;
        }
        [HTTPCLIENT buySearchWithPage:[NSString stringWithFormat:@"%ld",(long)self.PageCount] WithPageSize:@"11" Withgoldsupplier:self.goldsupplier WithproductUid:self.productUid WithproductName:self.searchStr WithProvince:self.province WithCity:self.City WithCounty:self.county WithsearchTime:searhTimeStr WithSearchStatus:self.searchStatus  WithAry:self.shaixuanAry Success:^(id responseObject) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            if(self.PageCount==1)
            {

                [self.buyDataAry removeAllObjects];
 
            }
            if (dic) {
                NSString *advertisementsStr=[dic objectForKey:@"advertisements"];
                NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
                NSArray *adary=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];;
                NSArray *buyzDataAry=[HotBuyModel creathotBuyModelAryByAry:[dic objectForKey:@"buys"]];
                
                if (buyzDataAry.count>0) {
                    [self.buyDataAry addObjectsFromArray:[ZIKFunction aryWithMessageAry:buyzDataAry withADAry:adary]];
                }else {
                    NSString *status=dic[@"searchStatus"];
                    if ([status isEqualToString:@"new"]&&self.PageCount==1) {
                        self.searchStatus = @"free";
                        self.sss=5;
//                        [self hiddingShareView];
                        [self.sellDataAry removeAllObjects];
                        [self.selfTableView headerEndRefreshing];
                        [self.selfTableView footerEndRefreshing];
                        [self.selfTableView reloadData];
                        RemoveActionV();
                        if ([self.delegate respondsToSelector:@selector(reloadBtnWithSearchStatus:)]) {
                            [self.delegate reloadBtnWithSearchStatus:@"free"];
                        }
                        [self.selfTableView headerBeginRefreshing];
                        return ;
                    }
                    if ([status isEqualToString:@"free"]) {
                        self.searchStatus = @"free";
                        self.sss=1;
                        [ToastView showTopToast:@"没有免费的求购"];
  
                        [self.selfTableView headerEndRefreshing];
                        [self.selfTableView footerEndRefreshing];
                        [self.selfTableView reloadData];
                        RemoveActionV();
                        return ;
                    }
                  

                }

                [self.selfTableView headerEndRefreshing];
                [self.selfTableView footerEndRefreshing];
            }
            RemoveActionV();
            [self.selfTableView reloadData];
        } failure:^(NSError *error) {
            RemoveActionV();
            [self.selfTableView headerEndRefreshing];
            [self.selfTableView footerEndRefreshing];
        }];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.searchType==1&&self.delegate) {
         id model = self.sellDataAry[indexPath.row];
        if ([model isKindOfClass:[HotSellModel class]]) {
          [self.delegate SearchSuccessViewPushSellDetial:model];
        }
        if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
            [self.delegate searchWithAdViewPushadDetial:model];
        }
        
    }
    if (self.searchType==2&&self.delegate) {
        id model = self.buyDataAry[indexPath.row];
        if ([model isKindOfClass:[HotBuyModel class]]) {
            HotBuyModel *model=self.buyDataAry[indexPath.row];
            [self.delegate SearchSuccessViewPushBuyDetial:model.uid];
        }
        if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
           [self.delegate searchWithAdViewPushadDetial:model];
        }
        

    }
    if (self.searchType==3&&self.delegate) {
        YLDShopListModel *model=self.shopDataAry[indexPath.row];
        [self.delegate SearchSuccessViewPushshopDetial:model.memberId];
    }
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

//新增分组分享
-(void)showShareView
{

    self.selfTableView.frame = CGRectMake(self.selfTableView.frame.origin.x, self.selfTableView.frame.origin.y, kWidth,self.bounds.size.height-50);
    self.shareView.hidden = NO;
}
-(void)hiddingShareView
{
    self.selfTableView.frame = CGRectMake(self.selfTableView.frame.origin.x, self.selfTableView.frame.origin.y, kWidth, self.bounds.size.height);
    self.shareView.hidden = YES;
}
-(void)sendTimeInfo:(NSString *)timeStr {
    if (![APPDELEGATE isNeedLogin]) {
        if ([self.delegate respondsToSelector:@selector(canUmshare)]) {
            [self.delegate canUmshare];
        }

        return;
    }

    [HTTPCLIENT groupShareWithProductUid:self.productUid  productName:self.searchStr province:self.province city:self.City county:self.county startTime:timeStr searchStatus:self.searchStatus  spec_XXXXXX:self.shaixuanAry  Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        NSDictionary *shareDic = responseObject[@"result"];
        NSString *shareText   = shareDic[@"text"];
        NSString *shareTitle  = shareDic[@"title"];
        NSString *urlStr = shareDic[@"pic"];
        NSData * data    = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr]];
        UIImage *shareImage  = [[UIImage alloc] initWithData:data];
        NSString *shareUrl    = shareDic[@"url"];
        if ([self.delegate respondsToSelector:@selector(umshare:title:image:url:)]) {
            [self.delegate umshare:shareText title:shareTitle image:shareImage url:shareUrl];
        }

    } failure:^(NSError *error) {
        ;
    }];
}


@end
