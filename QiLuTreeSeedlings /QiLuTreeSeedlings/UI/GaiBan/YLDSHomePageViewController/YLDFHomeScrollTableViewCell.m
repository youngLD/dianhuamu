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
@property (nonatomic,assign)NSInteger pageCount;
@property (nonatomic,strong)YLDDataCacheHelp *dataCache;
@property (nonatomic,strong) NSMutableArray *sellAry;
@property (nonatomic,strong) NSMutableArray *buyAry;
@property (nonatomic,strong) NSMutableArray *orderAry;
@property (nonatomic,strong)UITableView *tableView;
@end
@implementation YLDFHomeScrollTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.tableViewAry=[NSMutableArray array];
        self.sellAry=[NSMutableArray array];
        self.buyAry=[NSMutableArray array];
        self.orderAry=[NSMutableArray array];
        self.supplyPage=1;
        self.buyPage=1;
        self.orderPage=1;
        self.pageCount=1;
        self.dataCache=[[YLDDataCacheHelp alloc]initWithC:4];
        self.frame=CGRectMake(0, 0, kWidth, kHeight-64-50-44);
        UIScrollView *backScrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
        backScrollView.pagingEnabled=YES;
        backScrollView.bounces=NO;
        backScrollView.tag=111;
        backScrollView.delegate=self;
        self.scrollView=backScrollView;
        [self.contentView addSubview:backScrollView];
        for (int i=0; i<4; i++) {
            UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(i*kWidth, 0, kWidth, kHeight-64-50-44)];
//            [tableView setBackgroundColor:kRGB((arc4random()%256), (arc4random()%256), (arc4random()%256), 1)];
            [tableView setBackgroundColor:BGColor];
            [backScrollView addSubview:tableView];
            tableView.tag=i+1;
            tableView.delegate=self;
            tableView.dataSource=self;
            tableView.scrollEnabled=NO;
            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            if (i==0) {
                self.tableView=tableView;
            }
            [self talbeviewsetRefreshHeadWithTableView:tableView];
            [self.tableViewAry addObject:tableView];
        }
        [backScrollView setContentSize:CGSizeMake(kWidth*4, 0)];

        
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
                        cell=[YLDFMyBuyTableViewCell yldFListBuyTableViewCell];
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
    NSInteger xx=pageSize*self.pageCount;
    if (tableView.tag==1) {
        if (self.sellAry.count>xx) {
            return xx;
        }else
        {
           return self.sellAry.count;
        }
        
    }
    if (tableView.tag==2) {
        if (self.buyAry.count>xx) {
            return xx;
        }else
        {
            return self.buyAry.count;
        }
        
    }
    if (tableView.tag==3) {
        if (self.orderAry.count>xx) {
            return xx;
        }else
        {
            return self.orderAry.count;
        }

    }
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
//        id model=self.dataAry[indexPath.row];
        if (self.tableView.tag==1) {
            if (self.delegate) {
                [self.delegate scrollViewSelectWithModel:self.sellAry[indexPath.row]];
            }
        }
        if (self.tableView.tag==2) {
            if (self.delegate) {
                [self.delegate scrollViewSelectWithModel:self.buyAry[indexPath.row]];
            }
        }
        if (self.tableView.tag==3) {
            if (self.delegate) {
                [self.delegate scrollViewSelectWithModel:self.orderAry[indexPath.row]];
            }
        }
        

    }
}
#pragma mark ---------网络请求----------
-(void)reloadTableVVVWithLastType
{
    //供应
    if (self.tableView.tag==1) {
        NSArray *cocheAry=self.dataCache.cacheAry[0];
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
//                    YLDFSupplyModel *model=[supplyDataAry lastObject];
                    
                    [self.dataCache replaceDataWithDataAry:supplyDataAry WithIndex:0];
                    NSArray *modelAry=[self.dataCache getDataAryWithIndex:0 withPage:self.supplyPage WithPageSize:pageSize];
                    
                    NSMutableArray *tempAry=[NSMutableArray arrayWithArray:modelAry];
                    [tempAry addObjectsFromArray:self.sellAry];
                    [self.sellAry removeAllObjects];
                    [self.sellAry addObjectsFromArray:tempAry];
                    
                }
                 [self.tableView reloadData];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
                        [self.tableView.mj_header endRefreshing];
//                        [self.tableView footerEndRefreshing];
        } failure:^(NSError *error) {
//                        [self.tableView footerEndRefreshing];
                        [self.tableView.mj_header endRefreshing];
        }];
    }
    if (self.tableView.tag==2) {
        NSArray *cocheAry=self.dataCache.cacheAry[1];
        YLDFSupplyModel *model=[cocheAry lastObject];
        self.buyPage=1;
        [HTTPCLIENT BuysNewLsitWithQuery:nil WithlastTime:model.lastTime Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                
                NSDictionary *data=[responseObject objectForKey:@"data"];
                NSArray *buys=data[@"buys"];
                if (buys.count>1) {
                    NSArray *buysModelAry=[YLDFBuyModel YLDFBuyModelAryWithAry:buys];
//                    YLDFBuyModel *model=[buysModelAry lastObject];
                    
                    [self.dataCache replaceDataWithDataAry:buysModelAry WithIndex:1];
                    NSArray *modelAry=[self.dataCache getDataAryWithIndex:1 withPage:self.buyPage WithPageSize:pageSize];
                    
                    NSMutableArray *tempAry=[NSMutableArray arrayWithArray:modelAry];
                    [tempAry addObjectsFromArray:self.buyAry];
                    [self.buyAry removeAllObjects];
                    [self.buyAry addObjectsFromArray:tempAry];
                    [self.tableView reloadData];
                }else{
                    [ToastView showTopToast:@"已无更多数据"];
                }
                
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
//            [self.tableView footerEndRefreshing];
            [self.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            
//            [self.tableView footerEndRefreshing];
            [self.tableView.mj_header endRefreshing];
        }];
    }
    if (self.tableView.tag==3) {
        NSArray *cocheAry=self.dataCache.cacheAry[2];
        YLDFEOrderModel *model=[cocheAry lastObject];
        self.orderPage=1;
        [HTTPCLIENT getEOrderListWithLastTime:model.lastTime Withkeyword:nil Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSArray *order=[responseObject objectForKey:@"data"];
                
                if (order.count>0) {
                    NSArray *orderModelAry=[YLDFEOrderModel creatModeByAry:order];
//                    YLDFEOrderModel *model=[orderModelAry lastObject];
                    //                    self.lastTime=model.lastTime;
                    
                    [self.dataCache replaceDataWithDataAry:orderModelAry WithIndex:2];
                    NSArray *modelAry=[self.dataCache getDataAryWithIndex:2 withPage:self.orderPage WithPageSize:pageSize];
                    
                    NSMutableArray *tempAry=[NSMutableArray arrayWithArray:modelAry];
                    [tempAry addObjectsFromArray:self.orderAry];
                    [self.orderAry removeAllObjects];
                    [self.orderAry addObjectsFromArray:tempAry];
                    [self.tableView reloadData];
                }else{
                    [ToastView showTopToast:@"已无更多数据"];
                }
                
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
//                        [self.tableView footerEndRefreshing];
                        [self.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
//                        [self.tableView footerEndRefreshing];
                        [self.tableView.mj_header endRefreshing];
        }];
    }
//    if (_lastType==2) {
        //        [self.tableView footerEndRefreshing];
        //        [self.tableView.mj_header endRefreshing];
//    }
    
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
-(void)talbeviewsetRefreshHeadWithTableView:(UITableView *)tableView
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
            weakSelf.pageCount=1;
            NSInteger page=1;
            if (tableView.tableFooterView) {
                tableView.tableFooterView=nil;
                [weakSelf tianjiafooterActionWithTableView:tableView];
            }
            if (tableView.tag==1) {
                weakSelf.supplyPage++;
                page=weakSelf.supplyPage;
            }
            if (tableView.tag==2) {
                weakSelf.buyPage++;
                page=weakSelf.buyPage;
            }
            if (tableView.tag==3) {
                weakSelf.orderPage++;
                page=weakSelf.orderPage;
            }
            NSArray *dataAry = [weakSelf.dataCache getDataAryWithIndex:tableView.tag-1 withPage:page WithPageSize:pageSize];
            if (dataAry.count==0) {
                [weakSelf reloadTableVVVWithLastType];
            }else{
                
                NSMutableArray *tempAry=[NSMutableArray arrayWithArray:dataAry];
                if (tableView.tag==1) {
                    [tempAry addObjectsFromArray:weakSelf.sellAry];
                    [weakSelf.sellAry removeAllObjects];
                    [weakSelf.sellAry addObjectsFromArray:tempAry];
                }
                if (tableView.tag==2) {
                    [tempAry addObjectsFromArray:weakSelf.buyAry];
                    [weakSelf.buyAry removeAllObjects];
                    [weakSelf.buyAry addObjectsFromArray:tempAry];
                }
                if (tableView.tag==3) {
                    [tempAry addObjectsFromArray:weakSelf.orderAry];
                    [weakSelf.orderAry removeAllObjects];
                    [weakSelf.orderAry addObjectsFromArray:tempAry];
                }
                
                [tableView reloadData];
                [tableView.mj_header endRefreshing];
            }

        
        
    }];
    
    //给MJRefreshStateIdle状态设置一组图片，可以是一张，idleImages为数组
    
    [header setImages:idleImages duration:1.2 forState:MJRefreshStateIdle];
    
    //[header setImages:idleImages forState:MJRefreshStatePulling];
    //
    [header setImages:idleImages duration:1.2 forState:MJRefreshStateRefreshing];
    
    tableView.mj_header = header;
    
    [self tianjiafooterActionWithTableView:tableView];
    
}
-(void)tianjiafooterActionWithTableView:(UITableView *)tableView
{
    __weak typeof(self) weakSelf=self;
    
    [tableView addFooterWithCallback:^{
        weakSelf.pageCount++;
        NSInteger xx=weakSelf.pageCount*pageSize;
        [weakSelf.tableView footerEndRefreshing];
        NSInteger dataCount=0;
        if (tableView.tag==1) {
            dataCount=self.sellAry.count;
        }
        if (tableView.tag==2) {
            dataCount=self.buyAry.count;
        }
        if (tableView.tag==3) {
            dataCount=self.orderAry.count;
        }
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
-(void)setFirstAry:(NSArray *)firstAry{
    _firstAry=firstAry;
    NSArray *supplyDataAry=[YLDFSupplyModel YLDFSupplyModelAryWithAry:firstAry];
//    YLDFSupplyModel *model=[supplyDataAry lastObject];
    
    [self.dataCache replaceDataWithDataAry:supplyDataAry WithIndex:0];
    NSArray *modelAry=[self.dataCache getDataAryWithIndex:0 withPage:self.supplyPage WithPageSize:pageSize];
    [self.sellAry addObjectsFromArray:modelAry];
    UITableView *tableView=self.tableViewAry[0];
    self.tableView=tableView;
    [tableView reloadData];
}
-(void)setScrollEnable:(NSInteger)scrollEnable
{
    _scrollEnable=scrollEnable;
    if (scrollEnable==NO) {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    self.tableView.scrollEnabled=scrollEnable;
}
-(void)setActionIndex:(NSInteger)actionIndex
{
    _actionIndex=actionIndex;
    
    if (actionIndex<self.tableViewAry.count) {
        UITableView *tablView=self.tableViewAry[actionIndex];
        if (self.tableView!=tablView) {
            self.tableView=tablView;
            
            [self.scrollView setContentOffset:CGPointMake(kWidth*actionIndex, 0) animated:YES];
        }
//        else{
//             self.scrollEnable=YES;
//            [tablView.mj_header beginRefreshing];
//        }
        self.scrollEnable=YES;
        [tablView.mj_header beginRefreshing];
//
    }
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.tag==111) {
        NSInteger ccc=targetContentOffset->x/kWidth;
        if (ccc<self.tableViewAry.count) {
            if (self.tableView.tag-1!=ccc) {
                UITableView *tablView=self.tableViewAry[ccc];
                if (self.tableView!=tablView) {
                    self.tableView=tablView;
                    [tablView.mj_header beginRefreshing];
                    self.scrollEnable=YES;
                    if (self.delegate) {
                        [self.delegate scrollViewEndWithIndex:ccc];
                    }
                }
                
            }
        }
        
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   
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
