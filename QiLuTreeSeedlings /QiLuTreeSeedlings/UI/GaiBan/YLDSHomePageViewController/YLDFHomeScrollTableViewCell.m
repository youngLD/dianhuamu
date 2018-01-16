//
//  YLDFHomeScrollTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/16.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFHomeScrollTableViewCell.h"
#import "UIDefines.h"
#import "YLDDataCacheHelp.h"
#import "KMJRefresh.h"
#import "HttpClient.h"
#import "YLDFBuyModel.h"
#import "YLDFSupplyModel.h"
#import "YLDFEOrderModel.h"
#import "YLFMySupplyTableViewCell.h"
#import "YLDFMyBuyTableViewCell.h"
#import "YLDEngineeringOrderTableViewCell.h"
#import "MJRefreshGifHeader.h"
#define pageSize 5
@interface YLDFHomeScrollTableViewCell ()<UITableViewDelegate,UITableViewDataSource,YLDEngineeringOrderTableViewCellDelegate>
@property (nonatomic,assign)NSInteger supplyPage;
@property (nonatomic,assign)NSInteger buyPage;
@property (nonatomic,assign)NSInteger orderPage;
@property (nonatomic,strong)YLDDataCacheHelp *dataCache;
@property (nonatomic,strong)UIView *footerView;
@property (nonatomic,assign)BOOL topBtnChange;
@property (nonatomic,copy) NSMutableArray *sellAry;
@property (nonatomic,copy) NSMutableArray *buyAry;
@property (nonatomic,copy) NSMutableArray *orderAry;
@property (nonatomic,strong)UITableView *tableView;
@end
@implementation YLDFHomeScrollTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.tableViewAry=[NSMutableArray array];
        self.frame=CGRectMake(0, 0, kWidth, kHeight-64-50-44);
        UIScrollView *backScrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
        backScrollView.pagingEnabled=YES;
        backScrollView.bounces=NO;
        self.scrollView=backScrollView;
        [self.contentView addSubview:backScrollView];
        for (int i=0; i<4; i++) {
            UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(i*kWidth, 0, kWidth, kHeight-64-50-44)];
            [tableView setBackgroundColor:kRGB((arc4random()%256), (arc4random()%256), (arc4random()%256), 1)];
            [backScrollView addSubview:tableView];
            tableView.bounces=NO;
            tableView.tag=i+1;
            tableView.delegate=self;
            tableView.dataSource=self;
            [self.tableViewAry addObject:tableView];
        }
        [backScrollView setContentSize:CGSizeMake(kWidth*4, 0)];
//        self.footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
//        UILabel *footer=[[UILabel alloc]initWithFrame:self.footerView.bounds];
//        [footer setTextColor:kRGB(102, 102, 102, 1)];
//        [footer setFont:[UIFont systemFontOfSize:13]];
//        [footer setTextAlignment:NSTextAlignmentCenter];
//        [footer setText:@"我是有底线的"];
//        [self.footerView addSubview:footer];
        
    }
    return self;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (tableView.tag==1) {
        if (self.sellAry.count>indexPath.row) {
            id model=self.sellAry[indexPath.row];
            if ([model isKindOfClass:[YLDFSupplyModel class]]) {
                YLFMySupplyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLFMySupplyTableViewCell"];
                if (!cell) {
                    cell=[YLFMySupplyTableViewCell yldFListSupplyTableViewCell];
                }
                cell.model=self.sellAry[indexPath.row];
                return cell;
            }
          }
        }
        if (tableView.tag==2) {
            if (self.buyAry.count>indexPath.row) {
                id model=self.buyAry[indexPath.row];
                if ([model isKindOfClass:[YLDFBuyModel class]]) {
                    YLDFMyBuyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDFMyBuyTableViewCell"];
                    if (!cell) {
                        cell=[YLDFMyBuyTableViewCell yldFMyBuyTableViewCell];
                    }
                    cell.model=self.buyAry[indexPath.row];
                    return cell;
                }
            }
        }
    if (tableView.tag==3) {
        if (self.orderAry.count>indexPath.row) {
            id model=self.orderAry[indexPath.row];
            if ([model  isKindOfClass:[YLDFEOrderModel class]]) {
                YLDEngineeringOrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDEngineeringOrderTableViewCell"];
                if (!cell) {
                    cell=[YLDEngineeringOrderTableViewCell yldEngineeringOrderTableViewCell];
                    cell.delegate=self;
                }
                cell.model=self.orderAry[indexPath.row];
                return cell;
            }
        }
    }
  
    
    UITableViewCell *cell=[UITableViewCell new];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag==1) {
        return self.sellAry.count;
    }
    if (tableView.tag==2) {
        return self.buyAry.count;
    }
    if (tableView.tag==3) {
        return self.buyAry.count;
    }
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    if (indexPath.section==0) {
    //        id model=self.dataAry[indexPath.row];
    //        if ([model  isKindOfClass:[YLDFEOrderModel class]])
    //        {
    //            YLDFEOrderModel *modelz=self.dataAry[indexPath.row];
    //            YLDFEOrderDetialViewController *vc=[YLDFEOrderDetialViewController new];
    //            vc.hidesBottomBarWhenPushed=YES;
    //            vc.orderId=modelz.engineeringProcurementId;
    //            [self.navigationController pushViewController:vc animated:YES];
    //        }
    //        if([model isKindOfClass:[YLDFSupplyModel class]])
    //        {
    //            YLDFSupplyModel *modelz=self.dataAry[indexPath.row];
    //            YLDFSupplyViewController *vc=[YLDFSupplyViewController new];
    //            vc.model=modelz;
    //            vc.hidesBottomBarWhenPushed=YES;
    //            [self.navigationController pushViewController:vc animated:YES];
    //        }
    //        if ([model isKindOfClass:[YLDFBuyModel class]]) {
    //            YLDFBuyModel *modelz=self.dataAry[indexPath.row];
    //            YLDFBuyDetialViewController *vc=[YLDFBuyDetialViewController new];
    //            vc.model=modelz;
    //            vc.hidesBottomBarWhenPushed=YES;
    //            [self.navigationController pushViewController:vc animated:YES];
    //
    //        }
    //
    //    }
}
#pragma mark ---------网络请求----------
-(void)reloadTableVVVWithLastType
{
    //供应
    if (_lastType==0) {
        NSArray *cocheAry=self.dataCache.cacheAry[_lastType];
        YLDFSupplyModel *model=[cocheAry lastObject];
        self.supplyPage=1;
        [HTTPCLIENT SupplynewLsitWithQuery:nil WithlastTime:model.lastTime Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *data=[responseObject objectForKey:@"data"];
                NSArray *supplysAry=data[@"supplys"];
                if (supplysAry.count==0) {
                    [ToastView showTopToast:@"已无更多数据"];
                }else{
                    NSArray *supplyDataAry=[YLDFSupplyModel YLDFSupplyModelAryWithAry:supplysAry];
                    YLDFSupplyModel *model=[supplyDataAry lastObject];
                    
                    [self.dataCache replaceDataWithDataAry:supplyDataAry WithIndex:0];
                    NSArray *modelAry=[self.dataCache getDataAryWithIndex:0 withPage:self.supplyPage WithPageSize:pageSize];
                    
                    //                    [self.dataAry addObjectsFromArray:modelAry];
                }
                //                [self.tableView reloadData];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            //            [self.tableView.mj_header endRefreshing];
            //            [self.tableView footerEndRefreshing];
        } failure:^(NSError *error) {
            //            [self.tableView footerEndRefreshing];
            //            [self.tableView.mj_header endRefreshing];
        }];
    }
    if (_lastType==1) {
        NSArray *cocheAry=self.dataCache.cacheAry[_lastType];
        YLDFSupplyModel *model=[cocheAry lastObject];
        self.buyPage=1;
        [HTTPCLIENT BuysNewLsitWithQuery:nil WithlastTime:model.lastTime Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                
                NSDictionary *data=[responseObject objectForKey:@"data"];
                NSArray *buys=data[@"buys"];
                if (buys.count>1) {
                    NSArray *buysModelAry=[YLDFBuyModel YLDFBuyModelAryWithAry:buys];
                    YLDFBuyModel *model=[buysModelAry lastObject];
                    
                    [self.dataCache replaceDataWithDataAry:buysModelAry WithIndex:1];
                    NSArray *modelAry=[self.dataCache getDataAryWithIndex:1 withPage:self.buyPage WithPageSize:pageSize];
                    
                    //                    [self.dataAry addObjectsFromArray:modelAry];
                    [self.tableView reloadData];
                }else{
                    [ToastView showTopToast:@"已无更多数据"];
                }
                
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            [self.tableView footerEndRefreshing];
            //            [self.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            
            [self.tableView footerEndRefreshing];
            //            [self.tableView.mj_header endRefreshing];
        }];
    }
    if (_lastType==2) {
        NSArray *cocheAry=self.dataCache.cacheAry[_lastType];
        YLDFSupplyModel *model=[cocheAry lastObject];
        self.orderPage=1;
        [HTTPCLIENT getEOrderListWithLastTime:model.lastTime Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                //                if (!_lastTime) {
                //                    [self.dataAry removeAllObjects];
                //                }
                NSArray *order=[responseObject objectForKey:@"data"];
                
                
                
                if (order.count>0) {
                    NSArray *orderModelAry=[YLDFEOrderModel creatModeByAry:order];
                    YLDFEOrderModel *model=[orderModelAry lastObject];
                    //                    self.lastTime=model.lastTime;
                    
                    [self.dataCache replaceDataWithDataAry:orderModelAry WithIndex:2];
                    NSArray *modelAry=[self.dataCache getDataAryWithIndex:1 withPage:self.orderPage WithPageSize:pageSize];
                    
                    //                    [self.dataAry addObjectsFromArray:modelAry];
                    [self.tableView reloadData];
                }else{
                    [ToastView showTopToast:@"暂无更多数据"];
                }
                
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            //            [self.tableView footerEndRefreshing];
            //            [self.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            //            [self.tableView footerEndRefreshing];
            //            [self.tableView.mj_header endRefreshing];
        }];
    }
    if (_lastType==2) {
        //        [self.tableView footerEndRefreshing];
        //        [self.tableView.mj_header endRefreshing];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        if (tableView.tag==1) {
            return 182;
        }
        if (tableView.tag==2) {
            return 141;
        }
        if (tableView.tag==3) {
            tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
            tableView.estimatedRowHeight = 185;
            return tableView.rowHeight;
        }
    }
    
    return 44;
}
-(void)cellOpenBtnActionWithCell:(YLDEngineeringOrderTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
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
//            weakSelf.PageCount=1;
//            [weakSelf getDataListWithPageNum:[NSString stringWithFormat:@"%ld",weakSelf.PageCount]];
        }else{
            
//            weakSelf.PageCount=1;
            NSInteger page=1;
            if (weakSelf.tableView.tableFooterView) {
                weakSelf.tableView.tableFooterView=nil;
                [weakSelf tianjiafooterAction];
            }
            if (weakSelf.lastType==0) {
                weakSelf.supplyPage++;
                page=weakSelf.supplyPage;
            }
            if (weakSelf.lastType==1) {
                weakSelf.buyPage++;
                page=weakSelf.buyPage;
            }
            if (weakSelf.lastType==2) {
                weakSelf.orderPage++;
                page=weakSelf.orderPage;
            }
            NSArray *dataAry = [weakSelf.dataCache getDataAryWithIndex:weakSelf.lastType withPage:page WithPageSize:pageSize];
            if (dataAry.count==0) {
                [weakSelf reloadTableVVVWithLastType];
            }else{
                
                NSMutableArray *tempAry=[NSMutableArray arrayWithArray:dataAry];
//                [tempAry addObjectsFromArray:self.dataAry];
//                [weakSelf.dataAry removeAllObjects];
//                [weakSelf.dataAry addObjectsFromArray:tempAry];
                //                if (weakSelf.topBtnChange) {
                //                    [weakSelf.dataAry removeAllObjects];
                //                    if (weakSelf.lastType==0) {
                //                        [weakSelf.dataAry addObjectsFromArray:weakSelf.sellAry];
                //                    }
                //                    if (weakSelf.lastType==1) {
                //                        [weakSelf.dataAry addObjectsFromArray:weakSelf.buyAry];
                //                    }
                //                    if (weakSelf.lastType==2) {
                //                        [weakSelf.dataAry addObjectsFromArray:weakSelf.orderAry];
                //                    }
                //                    weakSelf.topBtnChange=NO;
                //                }
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }
        
        
    }];
    
    //给MJRefreshStateIdle状态设置一组图片，可以是一张，idleImages为数组
    
    [header setImages:idleImages duration:1.2 forState:MJRefreshStateIdle];
    
    //[header setImages:idleImages forState:MJRefreshStatePulling];
    //
    [header setImages:idleImages duration:1.2 forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    [self tianjiafooterAction];
    
}
-(void)tianjiafooterAction
{
    __weak typeof(self) weakSelf=self;
    [self.tableView addFooterWithCallback:^{
//        weakSelf.PageCount++;
//        NSInteger xx=weakSelf.PageCount*pageSize;
//        [weakSelf.tableView footerEndRefreshing];
//        if (xx<=self.dataAry.count) {
//            [weakSelf.tableView reloadData];
//        }else
//        {
//            [weakSelf.tableView removeFooter];
//            weakSelf.tableView.tableFooterView=weakSelf.footerView;
//        }
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
