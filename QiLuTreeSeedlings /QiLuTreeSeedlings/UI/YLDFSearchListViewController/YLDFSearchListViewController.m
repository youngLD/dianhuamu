//
//  YLDFSearchListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/19.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFSearchListViewController.h"
#import "YLDSearchActionViewController.h"
#import "YLDDataCacheHelp.h"
#import "UIDefines.h"
#import "ZIKFunction.h"
#import "HttpClient.h"
#import "KMJRefresh.h"
#import "YLDFSupplyModel.h"
#import "YLDFBuyModel.h"
#import "YLDFEOrderModel.h"
#import "YLFMySupplyTableViewCell.h"
#import "YLDFMyBuyTableViewCell.h"
#import "YLDEngineeringOrderTableViewCell.h"
#import "YLDFShopModel.h"
#import "YLDShopListTableViewCell.h"
#import "YLDFEOrderDetialViewController.h"
#import "YLDFBuyDetialViewController.h"
#import "YLDFSupplyViewController.h"
#import "YLDFShopDeitalViewController.h"
#define pageSize 5
@interface YLDFSearchListViewController ()<YLDSearchActionVCDelegate,UITableViewDelegate,UITableViewDataSource,YLDEngineeringOrderTableViewCellDelegate,YLDShopListTableViewCellDelegate>
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,strong) YLDDataCacheHelp *dataCache;
@property (nonatomic,assign) NSInteger pageCount;
@property (nonatomic,assign) NSInteger cacheIndex;
@property (nonatomic,copy) NSString *lastTime;
@end

@implementation YLDFSearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataCache=[[YLDDataCacheHelp alloc]initWithC:3];
    self.dataAry=[NSMutableArray array];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.pageCount=1;
    self.cacheIndex=1;
    if (self.searchType==0) {
        self.searchType=1;
    }
    self.searchV.layer.masksToBounds=YES;
    self.searchV.layer.cornerRadius=20;
    if (self.searchType==1) {
        self.nowtypeBtn=self.supplyBtn;
        self.supplyBtn.selected=YES;
    }
    if (self.searchType==2) {
        self.nowtypeBtn=self.buyBtn;
        self.buyBtn.selected=YES;
    }
    if (self.searchType==3) {
        self.nowtypeBtn=self.orderBtn;
        self.orderBtn.selected=YES;
    }
    if (self.searchType==4) {
        self.nowtypeBtn=self.companyBtn;
        self.companyBtn.selected=YES;
    }
    __weak typeof(self) weakSelf=self;
    if (self.searchStr==nil) {
        self.typeViewH.constant=0.01;
        self.typeView.hidden=YES;
        self.areaView.hidden=YES;
        self.areaVH.constant=0.5;
        [self.tableView addHeaderWithCallback:^{
            weakSelf.pageCount=1;
            weakSelf.cacheIndex++;
            if (_tableView.tableFooterView) {
                _tableView.tableFooterView=nil;
                [weakSelf addListFooderView];
            }
            NSArray *dataAry = [weakSelf.dataCache getDataAryWithIndex:weakSelf.searchType-1 withPage:weakSelf.cacheIndex WithPageSize:pageSize];
            if (dataAry.count==0) {
                [weakSelf getdatAction];
            }else
            {
                NSMutableArray *tempAry=[NSMutableArray arrayWithArray:dataAry];
                [tempAry addObjectsFromArray:weakSelf.dataAry];
                [weakSelf.dataAry removeAllObjects];
                [weakSelf.dataAry addObjectsFromArray:tempAry];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView headerEndRefreshing];
            }
        }];
        [self addListFooderView];
    }else{
        [self.tableView addFooterWithCallback:^{
            [weakSelf getdatAction];
        }];
    }
    self.supplyBW.constant=kWidth/4;
    self.searchTextField.enabled=NO;
    CGRect frame=self.moveView.frame;
    frame.size.width=kWidth/4;
    self.moveView.frame=frame;
    [self getdatAction];
    // Do any additional setup after loading the view from its nib.
}
-(void)addListFooderView
{
    __weak typeof(self) weakSelf=self;
    [self.tableView removeFooter];
    [self.tableView addFooterWithCallback:^{
        weakSelf.pageCount++;
        NSInteger xx=weakSelf.pageCount*pageSize;
        [weakSelf.tableView footerEndRefreshing];
        NSInteger dataCount=self.dataAry.count;
        
        if (xx<=dataCount) {
            [weakSelf.tableView reloadData];
        }else
        {
            [self.tableView removeFooter];
            UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
            [footerView setBackgroundColor: BGColor];
            UILabel *footer=[[UILabel alloc]initWithFrame:footerView.bounds];
            [footer setTextColor:kRGB(102, 102, 102, 1)];
            [footer setFont:[UIFont systemFontOfSize:13]];
            [footer setTextAlignment:NSTextAlignmentCenter];
            [footer setText:@"我也是有底线的"];
            [footerView addSubview:footer];
            weakSelf.tableView.tableFooterView=footerView;
        }
    }];
}
- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)goSearchViewBtnAction:(UIButton *)sender {
    YLDSearchActionViewController *vc=[[YLDSearchActionViewController alloc]init];
    vc.searchType=self.searchType;
    vc.searchStr=self.searchStr;
    vc.delegate=self;
    [self presentViewController:vc animated:NO completion:^{
        
    }];
}

-(void)searchActionWithType:(NSInteger)searchType searchString:(NSString *)searchStr{
    if (self.typeView.hidden==YES) {
        self.typeView.hidden=NO;
        self.typeViewH.constant=50;
    }
    self.searchStr=searchStr;
    self.searchType=searchType;
    self.searchTextField.text=searchStr;
    self.lastTime=nil;
    UIButton *sender=[self.typeView viewWithTag:searchType];
    self.nowtypeBtn.selected=NO;
    [self.tableView removeFooter];
    [self.tableView removeHeader];
    __weak typeof(self)weakSelf=self;
    [self.tableView addFooterWithCallback:^{
        [weakSelf getdatAction];
    }];
    [self typeBtnAction:sender];
}
- (IBAction)typeBtnAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.lastTime=nil;
    self.nowtypeBtn.selected=NO;
    sender.selected=YES;
    self.nowtypeBtn=sender;
    self.searchType=sender.tag;
    CGRect frame=self.moveView.frame;
    frame.origin.x=(sender.tag-1)*kWidth/4;
    [UIView animateWithDuration:0.3 animations:^{
        self.moveView.frame=frame;
    }];
    [self getdatAction];
}
-(void)getdatAction
{
    if (self.searchType==1) {

        if (self.searchStr==nil) {
        
            NSArray *cocheAry=self.dataCache.cacheAry[0];
            YLDFSupplyModel *model=[cocheAry lastObject];
            self.lastTime=model.lastTime;
        }
        [HTTPCLIENT SupplynewLsitWithQuery:self.searchStr WithlastTime:self.lastTime Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *data=[responseObject objectForKey:@"data"];
                NSArray *supplysAry=data[@"supplys"];
                if (supplysAry.count==0) {
                    if (self.searchStr!=nil)
                    {
                        [ToastView showTopToast:@"已无更多数据"];
                        if (!_lastTime) {
                            [self.dataAry removeAllObjects];
                        }
                    }
                    
                }else{
                    NSArray *supplyDataAry=[YLDFSupplyModel YLDFSupplyModelAryWithAry:supplysAry];
                    if (self.searchStr==nil) {
                        [self.dataCache replaceDataWithDataAry:supplyDataAry WithIndex:0];
                        NSArray *modelAry=[self.dataCache getDataAryWithIndex:0 withPage:self.pageCount WithPageSize:pageSize];
                        
                        NSMutableArray *tempAry=[NSMutableArray arrayWithArray:modelAry];
                        [tempAry addObjectsFromArray:self.dataAry];
                        [self.dataAry removeAllObjects];
                        [self.dataAry addObjectsFromArray:tempAry];
                    }else{
                        if (!_lastTime) {
                            [self.dataAry removeAllObjects];
                        }
                        YLDFSupplyModel *model=[supplyDataAry lastObject];
                        self.lastTime=model.lastTime;
                        [self.dataAry addObjectsFromArray:supplyDataAry];
                    }
                    
                    
                }
                [self.tableView reloadData];
                
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            if ([self.tableView isHeaderRefreshing]) {
               [self.tableView headerEndRefreshing];
            }
            if ([self.tableView isFooterRefreshing]) {
                [self.tableView footerEndRefreshing];
            }
        } failure:^(NSError *error) {
            if ([self.tableView isHeaderRefreshing]) {
                [self.tableView headerEndRefreshing];
            }
            if ([self.tableView isFooterRefreshing]) {
                [self.tableView footerEndRefreshing];
            }
        }];
    }
    if (self.searchType==2) {

        if (self.searchStr==nil) {
          
        
            NSArray *cocheAry=self.dataCache.cacheAry[1];
            YLDFBuyModel *model=[cocheAry lastObject];
            self.lastTime=model.lastTime;
        }
        [HTTPCLIENT BuysNewLsitWithQuery:self.searchStr WithlastTime:self.lastTime Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *data=[responseObject objectForKey:@"data"];
                NSArray *buys=data[@"buys"];
                NSArray *buysModelAry=[YLDFBuyModel YLDFBuyModelAryWithAry:buys];
                if (buys.count>1) {
                    
                    if (self.searchStr==nil) {
                        [self.dataCache replaceDataWithDataAry:buysModelAry WithIndex:1];
                        NSArray *modelAry=[self.dataCache getDataAryWithIndex:1 withPage:self.cacheIndex WithPageSize:pageSize];
                        
                        NSMutableArray *tempAry=[NSMutableArray arrayWithArray:modelAry];
                        [tempAry addObjectsFromArray:self.dataAry];
                        [self.dataAry removeAllObjects];
                        [self.dataAry addObjectsFromArray:tempAry];
                    }else
                    {
                        if (!_lastTime) {
                            [self.dataAry removeAllObjects];
                        }
                        YLDFBuyModel *model=[buysModelAry lastObject];
                        self.lastTime=model.lastTime;
                        [self.dataAry addObjectsFromArray:buysModelAry];
                    }
                }else{
                    if (self.searchStr!=nil)
                    {
                        [ToastView showTopToast:@"已无更多数据"];
                        if (!_lastTime) {
                            [self.dataAry removeAllObjects];
                        }
                    }
                }
                [self.tableView reloadData];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            if ([self.tableView isHeaderRefreshing]) {
                [self.tableView headerEndRefreshing];
            }
            if ([self.tableView isFooterRefreshing]) {
                [self.tableView footerEndRefreshing];
            }
        } failure:^(NSError *error) {
            if ([self.tableView isHeaderRefreshing]) {
                [self.tableView headerEndRefreshing];
            }
            if ([self.tableView isFooterRefreshing]) {
                [self.tableView footerEndRefreshing];
            }
        }];
    }
    if (self.searchType==3) {

        if (self.searchStr==nil) {
            
            NSArray *cocheAry=self.dataCache.cacheAry[2];
            YLDFEOrderModel *model=[cocheAry lastObject];
            self.lastTime=model.lastTime;
        }

        [HTTPCLIENT getEOrderListWithLastTime:self.lastTime Withkeyword:self.searchStr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSArray *order=[responseObject objectForKey:@"data"];
                
                if (order.count>0) {
                    NSArray *orderModelAry=[YLDFEOrderModel creatModeByAry:order];
                    
                    if (self.searchStr==nil) {
                        [self.dataCache replaceDataWithDataAry:orderModelAry WithIndex:2];
                        NSArray *modelAry=[self.dataCache getDataAryWithIndex:2 withPage:self.cacheIndex WithPageSize:pageSize];
                        
                        NSMutableArray *tempAry=[NSMutableArray arrayWithArray:modelAry];
                        [tempAry addObjectsFromArray:self.dataAry];
                        [self.dataAry removeAllObjects];
                        [self.dataAry addObjectsFromArray:tempAry];
                        [self.tableView reloadData];
                    }else{
                        if (!_lastTime) {
                            [self.dataAry removeAllObjects];
                        }
                        YLDFEOrderModel *model=[orderModelAry lastObject];
                        self.lastTime=model.lastTime;
                        [self.dataAry addObjectsFromArray:orderModelAry];
                    }
                }else{
                    if (self.searchStr!=nil)
                    {
                        [ToastView showTopToast:@"已无更多数据"];
                        if (!_lastTime) {
                            [self.dataAry removeAllObjects];
                        }
                    }
                }
                [self.tableView reloadData];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            if ([self.tableView isHeaderRefreshing]) {
                [self.tableView headerEndRefreshing];
            }
            if ([self.tableView isFooterRefreshing]) {
                [self.tableView footerEndRefreshing];
            }
        } failure:^(NSError *error) {
            if ([self.tableView isHeaderRefreshing]) {
                [self.tableView headerEndRefreshing];
            }
            if ([self.tableView isFooterRefreshing]) {
                [self.tableView footerEndRefreshing];
            }
        }];
    }
    if (self.searchType==4) {
        [HTTPCLIENT shopSearchWithLastTime:self.lastTime Withkeyword:self.searchStr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSArray *shop=[responseObject objectForKey:@"data"];
                if (!self.lastTime) {
                    [self.dataAry removeAllObjects];
                }
                if (shop.count>0) {
                    NSArray *modelAry=[YLDFShopModel creatAryByAry:shop];
                    [self.dataAry addObjectsFromArray:modelAry];
                }else{
                    [ToastView showTopToast:@"暂无更多数据"];
                }
               
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            [self.tableView reloadData];
            if ([self.tableView isHeaderRefreshing]) {
                [self.tableView headerEndRefreshing];
            }
            if ([self.tableView isFooterRefreshing]) {
                [self.tableView footerEndRefreshing];
            }
        } failure:^(NSError *error) {
            if ([self.tableView isHeaderRefreshing]) {
                [self.tableView headerEndRefreshing];
            }
            if ([self.tableView isFooterRefreshing]) {
                [self.tableView footerEndRefreshing];
            }
        }];
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchStr==nil) {
        NSInteger xx=pageSize*self.pageCount;
        if (self.dataAry.count>xx) {
            return xx;
        }else
        {
            return self.dataAry.count;
        }
    }else
    {
        return self.dataAry.count;
    }
    
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    if ([model isKindOfClass:[YLDFShopModel class]]) {
        tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
        tableView.estimatedRowHeight = 96;
        return tableView.rowHeight;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model=self.dataAry[indexPath.row];
    if ([model isKindOfClass:[YLDFSupplyModel class]]) {
        YLFMySupplyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLFMySupplyTableViewCell"];
        if (!cell) {
            cell=[YLFMySupplyTableViewCell yldFListSupplyTableViewCell];
        }
        cell.model=self.dataAry[indexPath.row];
        return cell;
    }
    if ([model isKindOfClass:[YLDFBuyModel class]]) {
        YLDFMyBuyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDFMyBuyTableViewCell"];
        if (!cell) {
            cell=[YLDFMyBuyTableViewCell yldFListBuyTableViewCell];
        }
        cell.model=self.dataAry[indexPath.row];
        return cell;
    }
    if ([model isKindOfClass:[YLDFEOrderModel class]]) {
        YLDEngineeringOrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDEngineeringOrderTableViewCell"];
        if (!cell) {
            cell=[YLDEngineeringOrderTableViewCell yldEngineeringOrderTableViewCell];
            cell.delegate=self;
        }
        cell.model=self.dataAry[indexPath.row];
        return cell;
    }
    if ([model isKindOfClass:[YLDFShopModel class]]) {
        YLDShopListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDShopListTableViewCell"];
        if (!cell) {
            cell=[YLDShopListTableViewCell yldShopListTableViewCell];
            cell.delegate=self;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.model=self.dataAry[indexPath.row];
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
-(void)goShopDetialWithModel:(YLDFShopModel *)model
{
    YLDFShopDeitalViewController *vc=[YLDFShopDeitalViewController new];
    vc.model=model;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)shopCellChackBtnAction:(UIButton *)sender withCell:(YLDShopListTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)cellOpenBtnActionWithCell:(YLDEngineeringOrderTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id model=self.dataAry[indexPath.row];
    if ([model  isKindOfClass:[YLDFEOrderModel class]])
    {
        YLDFEOrderModel *modelz=(YLDFEOrderModel *)model;
        YLDFEOrderDetialViewController *vc=[YLDFEOrderDetialViewController new];
     
        vc.orderId=modelz.engineeringProcurementId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if([model isKindOfClass:[YLDFSupplyModel class]])
    {
        YLDFSupplyModel *modelz=(YLDFSupplyModel *)model;
        YLDFSupplyViewController *vc=[YLDFSupplyViewController new];
        vc.model=modelz;

        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([model isKindOfClass:[YLDFBuyModel class]]) {
        YLDFBuyModel *modelz=(YLDFBuyModel *)model;
        YLDFBuyDetialViewController *vc=[YLDFBuyDetialViewController new];
        vc.model=modelz;
     
        [self.navigationController pushViewController:vc animated:YES];
        
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
