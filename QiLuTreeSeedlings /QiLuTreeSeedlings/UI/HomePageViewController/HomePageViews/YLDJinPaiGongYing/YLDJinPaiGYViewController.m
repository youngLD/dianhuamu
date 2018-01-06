//
//  YLDJinPaiGYViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/30.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJinPaiGYViewController.h"
#import "SellSearchTableViewCell.h"
#import "SellDetialViewController.h"
#import "HotSellModel.h"
#import "HttpClient.h"
#import "KMJRefresh.h"
#import "ZIKFunction.h"
#import "YLDSsupplyBaseCell.h"
#import "YLDSadvertisementModel.h"
#import "ZIKMyShopViewController.h"
#import "YLDSADViewController.h"
#import "YLDSBigImageVadCell.h"
#import "YLDStextAdCell.h"
#import "YLDTADThreePicCell.h"
#import "YLDTLeftTextAdCell.h"
#import "YLDTMoreBigImageADCell.h"
@interface YLDJinPaiGYViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UIView *moveView;
@property (nonatomic,weak)UIButton *nowBtn;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic)NSInteger pageNum;
@property (nonatomic)NSInteger goldsupplier;
@end

@implementation YLDJinPaiGYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"金牌供应";
    self.dataAry=[NSMutableArray array];
    self.pageNum=1;
    self.goldsupplier=0;
    
    //[self.navBackView setBackgroundColor:NavYellowColor];
    [self topActionView];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 116, kWidth, kHeight-164)];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [self.view setBackgroundColor:BGColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    __weak typeof(self) weakSelf=self;
    [tableView addHeaderWithCallback:^{
        ShowActionV();
        weakSelf.pageNum=1;
        [weakSelf getDataLists];
    }];
    [tableView addFooterWithCallback:^{
        ShowActionV();
        weakSelf.pageNum+=1;
        [weakSelf getDataLists];
    }];
    [tableView headerBeginRefreshing];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model=self.dataAry[indexPath.row];
    if ([model isKindOfClass:[YLDSadvertisementModel class]])
    {
        YLDSadvertisementModel* model=self.dataAry[indexPath.row];
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
        YLDSadvertisementModel* model=self.dataAry[indexPath.row];
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
-(void)getDataLists
{
    [HTTPCLIENT GoldSupplrWithPageSize:@"10" WithPage:[NSString stringWithFormat:@"%ld",(long)(self.pageNum)] Withgoldsupplier:[NSString stringWithFormat:@"%ld",(long)(self.goldsupplier)]  Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSArray *ary=[HotSellModel hotSellAryByAry:[[responseObject objectForKey:@"result"] objectForKey:@"supplys"]];
            NSString *advertisementsStr=[[responseObject objectForKey:@"result"] objectForKey:@"advertisements"];
            NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
            NSArray *adAry=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];

           
            if (self.pageNum==1) {
                [self.dataAry removeAllObjects];
            }
            if (ary.count<=0) {
                self.pageNum--;
                [ToastView showTopToast:@"已无更多数据"];
            }else
            {
                NSArray *dataAAA=[ZIKFunction aryWithMessageAry:ary withADAry:adAry];;
                [self.dataAry addObjectsFromArray:dataAAA];
                
            }
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        RemoveActionV();
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } failure:^(NSError *error) {
        RemoveActionV();
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }];
}
- (void)topActionView {
    NSArray *ary=@[@"全部",@"金牌",@"银牌",@"铜牌"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.shadowColor   = [UIColor grayColor].CGColor;///shadowColor阴影颜色
    view.layer.shadowOpacity = 0.6;////阴影透明度，默认0
    view.layer.shadowOffset  = CGSizeMake(0, 3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    
    view.layer.shadowRadius  = 3;//阴影半径，默认3
    CGFloat btnWith=kWidth/4;
    UIView *moveView=[[UIView alloc]initWithFrame:CGRectMake(0, 47, btnWith, 3)];
    [moveView setBackgroundColor:NavColor];
    self.moveView=moveView;
    [view addSubview:moveView];
    for (int i=0; i<ary.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(btnWith*i, 0, btnWith, 47)];
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        [btn setTitle:ary[i] forState:UIControlStateSelected];
        [btn setTitleColor:titleLabColor forState:UIControlStateNormal];
        [btn setTitleColor:NavColor forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        btn.tag=i;
        if (i==0) {
            btn.selected=YES;
            _nowBtn=btn;
        }
        [btn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
    }
    [self.view addSubview:view];
}
-(void)topBtnAction:(UIButton *)sender
{
    if (sender==_nowBtn) {
        return;
    }
    
    sender.selected=YES;
    _nowBtn.selected=NO;
    _nowBtn=sender;
    
    self.goldsupplier=sender.tag;
    self.pageNum=1;
    [self.tableView headerBeginRefreshing];
    
    CGRect frame=_moveView.frame;
    frame.origin.x=kWidth/4*(sender.tag);
    [UIView animateWithDuration:0.3 animations:^{
        _moveView.frame=frame;
    }];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id model=self.dataAry[indexPath.row];
    if ([model isKindOfClass:[HotSellModel class]]) {
        HotSellModel *model=self.dataAry[indexPath.row];
        
        SellDetialViewController *sellDetialViewC=[[SellDetialViewController alloc]initWithUid:model];
        sellDetialViewC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:sellDetialViewC animated:YES];
    }else if([model isKindOfClass:[YLDSadvertisementModel class]])
    {
        YLDSadvertisementModel *model=self.dataAry[indexPath.row];
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
