//
//  ZIKPurchaseRecordsViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/5.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKPurchaseRecordsViewController.h"
#import "BuySearchTableViewCell.h"
#import "HotBuyModel.h"
#import "KMJRefresh.h"
#import "BuyDetialInfoViewController.h"
#import "ZIKBottomDeleteTableViewCell.h"
#import "ZIKEmptyTableViewCell.h"
#import "ZIKNewsDetialViewController.h"
@interface ZIKPurchaseRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *recordsVC;
@property (nonatomic, strong) UITableView    *zbTableView;
@property (nonatomic, strong) NSMutableArray *recordMarr;
@property (nonatomic, strong) NSMutableArray *zbDataAry;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger      qgpage;//页数从1开始
@property (nonatomic, assign) NSInteger      zbpage;//页数从1开始
@property (nonatomic, strong) UIButton *gongyingBtn;
@property (nonatomic, strong) UIButton *qiugouBtn;
@property (nonatomic, strong) UIImageView *moveImageV;
@property (nonatomic ,strong) UIScrollView *backScrollView;
@end

@implementation ZIKPurchaseRecordsViewController
{
    UILongPressGestureRecognizer *_tapDeleteGR;//长按手势
    ZIKBottomDeleteTableViewCell *_bottomcell; //底部删除view

    NSMutableArray *_removeArray;
    NSArray *_deleteIndexArr;//选中的删除index
}

#pragma mark - 返回箭头按钮点击事件
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"购买记录";
    [self initData];
    [self initUI];
    [self.recordsVC headerBeginRefreshing];
}

- (void)requestDataWithPage:(NSString *)page {
    [HTTPCLIENT purchaseHistoryWithPage:page Withtype:[NSString stringWithFormat:@"%ld",self.type] Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSArray *result=[responseObject objectForKey:@"result"];
            if (self.type==0) {
             if (self.qgpage==1)
             {
                 [self.recordMarr removeAllObjects];
             }
                NSArray *qgAry=[HotBuyModel creathotBuyModelAryByAry:result];
                if (qgAry.count<=0) {
                    if (self.qgpage==1) {
                      [ToastView showTopToast:@"暂无数据"];
                    }else{
                       [ToastView showTopToast:@"已无更多数据"];
                    }
                    
                }else{
                    [self.recordMarr addObjectsFromArray:qgAry];
                }
                [self.recordsVC reloadData];
                [self.recordsVC headerEndRefreshing];
                [self.recordsVC footerEndRefreshing];
            }else if (self.type==1)
            {
                if (self.zbpage==1)
                {
                    [self.zbDataAry removeAllObjects];
                }
                NSArray *zbAry=[HotBuyModel creathotBuyModelAryByAry:result];
                if (zbAry.count<=0) {
                    if (self.zbpage==1) {
                        [ToastView showTopToast:@"暂无数据"];
                    }else{
                        [ToastView showTopToast:@"已无更多数据"];
                    }
                    
                }else{
                    [self.zbDataAry addObjectsFromArray:zbAry];
                }
                [self.zbTableView reloadData];
                [self.zbTableView headerEndRefreshing];
                [self.zbTableView footerEndRefreshing];
            }
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)initUI {

    UIButton *gongyingBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 64, kWidth/2+1, 44)];
    UIView *gongyingViw=[[UIView alloc]initWithFrame:gongyingBtn.frame];
    [gongyingViw setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:gongyingViw];
    [gongyingBtn setTitle:@"求购信息" forState:UIControlStateNormal];
    gongyingViw.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    gongyingViw.layer.shadowOffset = CGSizeMake(-3,3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    gongyingViw.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    gongyingViw.layer.shadowRadius = 3;//阴影半径，默认3
    [gongyingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [gongyingBtn setTitleColor:NavColor forState:UIControlStateSelected];
    gongyingBtn.tag=11;
    gongyingBtn.selected=YES;
    self.gongyingBtn=gongyingBtn;
    [gongyingBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gongyingBtn];
    
    
    UIButton *qiugouBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2, 64, kWidth/2, 44)];
    [qiugouBtn setTitle:@"招标信息" forState:UIControlStateNormal];
    [qiugouBtn setTitleColor:titleLabColor forState:UIControlStateNormal];
    [qiugouBtn setTitleColor:NavColor forState:UIControlStateSelected];
    qiugouBtn.tag=12;
    UIView *qiugouViw=[[UIView alloc]initWithFrame:qiugouBtn.frame];
    [qiugouViw setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:qiugouViw];
    qiugouViw.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    qiugouViw.layer.shadowOffset = CGSizeMake(3.5,3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    qiugouViw.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    qiugouViw.layer.shadowRadius = 3;//阴影半径，默认3
    [self.view addSubview:qiugouViw];
    self.qiugouBtn=qiugouBtn;
    [qiugouBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qiugouBtn];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(gongyingBtn.frame)-0.7, kWidth/2, 2.7)];
    self.moveImageV=imageV;
    [imageV setBackgroundColor:NavColor];
    [self.view addSubview:imageV];
    
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+50, kWidth, Height-64-50)];
    scrollV.tag=111;
    scrollV.delegate=self;
    scrollV.pagingEnabled=YES;
    [scrollV setContentSize:CGSizeMake(kWidth*2, 0)];
    self.backScrollView=scrollV;
    [self.view addSubview:scrollV];
    
     UITableView * recordsVC = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64-50) style:UITableViewStylePlain];
    self.recordsVC = recordsVC;
    recordsVC.delegate   = self;
    recordsVC.dataSource = self;
    recordsVC.tag=1;
    __weak typeof(self) weakSelf=self;
    [recordsVC addHeaderWithCallback:^{
        weakSelf.type=0;
        weakSelf.qgpage=1;
        [weakSelf requestDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.qgpage]];
    }];
    [recordsVC addFooterWithCallback:^{
        weakSelf.type=0;
        weakSelf.qgpage+=1;
        [weakSelf requestDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.qgpage]];
    }];
    [scrollV addSubview:recordsVC];
    recordsVC.backgroundColor = BGColor;
    [ZIKFunction setExtraCellLineHidden:recordsVC];
    self.zbTableView = [[UITableView alloc] initWithFrame:CGRectMake(Width, 0, Width, Height-64-50) style:UITableViewStylePlain];
    [self.zbTableView addHeaderWithCallback:^{
        weakSelf.type=1;
        weakSelf.zbpage=1;
        [weakSelf requestDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.zbpage]];
    }];
    [self.zbTableView addFooterWithCallback:^{
        weakSelf.type=1;
        weakSelf.zbpage+=1;
        [weakSelf requestDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.zbpage]];
    }];
    self.zbTableView.delegate   = self;
    self.zbTableView.dataSource = self;
    [scrollV addSubview:self.zbTableView];
    self.zbTableView.tag=2;
    self.zbTableView.backgroundColor = BGColor;
    [ZIKFunction setExtraCellLineHidden:self.zbTableView];

}
-(void)selectBtnAction:(UIButton *)sender
{
    if (sender.selected==YES) {
        return;
    }
    CGRect frame=self.moveImageV.frame;
    if (sender.tag==11) {
        frame.origin.x=0;
        sender.selected=YES;
        self.qiugouBtn.selected=NO;
        [self.backScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.type=0;
        [self.recordsVC headerBeginRefreshing];
    }else if (sender.tag==12)
    {
        frame.origin.x=kWidth/2;
        sender.selected=YES;
        self.gongyingBtn.selected=NO;
        [self.backScrollView setContentOffset:CGPointMake(kWidth, 0) animated:YES];
        self.type=1;
        [self.zbTableView headerBeginRefreshing];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.moveImageV.frame=frame;
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag==111) {
        if (scrollView.contentOffset.x>=kWidth-5) {
            if (self.gongyingBtn.selected==YES) {
                self.gongyingBtn.selected=NO;
                self.qiugouBtn.selected=YES;
                CGRect frame=self.moveImageV.frame;
                frame.origin.x=kWidth/2;
                [UIView animateWithDuration:0.3 animations:^{
                    self.moveImageV.frame=frame;
                }];
            }
        }
        if (scrollView.contentOffset.x<=5) {
            if (self.qiugouBtn.selected==YES) {
                self.qiugouBtn.selected=NO;
                self.gongyingBtn.selected=YES;
                CGRect frame=self.moveImageV.frame;
                frame.origin.x=0;
                [UIView animateWithDuration:0.3 animations:^{
                    self.moveImageV.frame=frame;
                }];
            }
        }
        
    }
    
}

- (void)initData {
    self.zbpage = 1;
    self.qgpage = 1;
    self.recordMarr = [NSMutableArray array];
    self.zbDataAry = [NSMutableArray array];
    _removeArray = [NSMutableArray array];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==1) {
        if (self.recordMarr.count == 0) {
            return 260;
        }
        return 65;
    }else if(tableView.tag==2){
        if (self.zbDataAry.count == 0) {
            return 260;
        }
 
        return 65;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag==1) {
        if (self.recordMarr.count == 0) {
            return 1;
        }
        return self.recordMarr.count;
    }else if(tableView.tag==2){
        if (self.zbDataAry.count == 0) {
            return 1;
        }
        return self.zbDataAry.count;
    }else{
        return 1;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==1) {
        if (self.recordMarr.count == 0) {
            ZIKEmptyTableViewCell *cell =  [[[NSBundle mainBundle] loadNibNamed:@"ZIKEmptyTableViewCell" owner:self options:nil] lastObject];
            return cell;
        }
        BuySearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BuySearchTableViewCell IDStr]];
        if (!cell) {
            cell = [[BuySearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BuySearchTableViewCell IDStr] WithFrame:CGRectMake(0, 0, kWidth, 65)];
        }
        HotBuyModel  *model = self.recordMarr[indexPath.row];
        cell.hotBuyModel = model;
        return cell;
    }
    
    if (tableView.tag==2) {
        if (self.zbDataAry.count == 0) {
            ZIKEmptyTableViewCell *cell =  [[[NSBundle mainBundle] loadNibNamed:@"ZIKEmptyTableViewCell" owner:self options:nil] lastObject];
            return cell;
        }
        BuySearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BuySearchTableViewCell IDStr]];
        if (!cell) {
            cell = [[BuySearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BuySearchTableViewCell IDStr] WithFrame:CGRectMake(0, 0, kWidth, 65)];
        }
        HotBuyModel  *model = self.zbDataAry[indexPath.row];
        cell.hotBuyModel = model;
        return cell;
    }else{
        UITableViewCell *cell=[UITableViewCell new];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag==2) {
        HotBuyModel *model = self.zbDataAry[indexPath.row];
        ZIKNewsDetialViewController *zikNDVC=[[ZIKNewsDetialViewController alloc]init];
        zikNDVC.urlString=model.supplybuyUid;
        zikNDVC.newstitle=@"招标新闻";
        zikNDVC.newstext=model.title;
        [self.navigationController pushViewController:zikNDVC animated:YES];
    }
    if (tableView.tag==1) {
        HotBuyModel *model = self.recordMarr[indexPath.row];
        BuyDetialInfoViewController *buyDetialVC=[[BuyDetialInfoViewController alloc]initWithSaercherInfo:model.supplybuyUid];
         [self.navigationController pushViewController:buyDetialVC animated:YES];
    }
}
#pragma mark - 更改底部删除视图( 过期编辑状态下  是否全选)
- (void)updateBottomDeleteCellView {
    (_deleteIndexArr.count == self.recordMarr.count) ? (_bottomcell.isAllSelect = YES) : (_bottomcell.isAllSelect = NO);
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    HotBuyModel *model = [self.recordMarr objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_removeArray containsObject:model]) {//删除反选数据
        [_removeArray removeObject:model];
    }
    NSArray *selectedRows = [self.recordsVC indexPathsForSelectedRows];
    _deleteIndexArr = selectedRows;
    _bottomcell.count = _removeArray.count;
    [self updateBottomDeleteCellView];
}

#pragma mark - 可选实现的协议方法
// 删除时的提示文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

// 开启某行是否可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 设置cell行编辑风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;

}

// 编辑时触发的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"commitEditingStyle");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
