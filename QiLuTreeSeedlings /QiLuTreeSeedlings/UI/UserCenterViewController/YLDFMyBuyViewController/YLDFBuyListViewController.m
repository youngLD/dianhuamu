//
//  YLDFBuyListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/2.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFBuyListViewController.h"
#import "KMJRefresh.h"
#import "YLDFBuyModel.h"
#import "YLDFMyBuyTableViewCell.h"
#import "YLDFTopSearchView.h"
#import "YLDFDeleteOrRefreshView.h"
#import "YLDFOpenOrDeleteView.h"
#import "YLDFmyBuyDetialViewController.h"
#import "YLDFBuyFBViewController.h"
@interface YLDFBuyListViewController ()<UITableViewDelegate,UITableViewDataSource,YLDFMyBuyTableViewCellDelegate,YLDFTopSearchViewDelegate,YLDFmyBuyDetialViewControllerDelegate,buyFabuDelegate>
@property (nonatomic,strong)UIButton *nowBtn;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,copy) NSString *lastTime;
@property (nonatomic,strong)NSMutableArray *selectAry;
@property (nonatomic,strong)UILongPressGestureRecognizer *tapDeleteGR;
@property (nonatomic,strong)YLDFDeleteOrRefreshView *deleteView;
@property (nonatomic,strong)YLDFOpenOrDeleteView *openView;
@property (nonatomic,copy)NSString *keyWord;
@property (nonatomic,copy)NSString *baseUrl;
@end

@implementation YLDFBuyListViewController
-(void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"editing"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        _topC.constant=44.0;
    }
    self.vcTitle=@"我的求购";
    [self.yixiajiaBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.yishangjiBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn removeTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.yishangjiBtn.selected=YES;
    self.nowBtn=self.yishangjiBtn;
    CGRect frame=self.moveView.frame;
    frame.size.width=kWidth/2-40;
    frame.origin.x=20;
    self.moveView.frame=frame;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _selectAry=[NSMutableArray array];
    _dataAry=[NSMutableArray array];
    _tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressForSelectAction)];
    [_tableView addGestureRecognizer:_tapDeleteGR];
    [_tableView addObserver:self forKeyPath:@"editing" options:NSKeyValueObservingOptionNew context:NULL];
    __weak typeof(self) weakself =self;
    [self.tableView addHeaderWithCallback:^{
        weakself.lastTime=nil;
        [weakself getDataList];
    }];
    [self.tableView addFooterWithCallback:^{
        [weakself getDataList];
    }];
    [self getDataList];
    YLDFTopSearchView *searchV=[YLDFTopSearchView yldFTopSearchView];
    searchV.frame=CGRectMake(60, 25, kWidth-120, 33);
    searchV.delegate=self;
    [searchV setobss];
    [self.navBackView addSubview:searchV];
    self.deleteView=[YLDFDeleteOrRefreshView yldFDeleteOrRefreshView];
    
    [self.deleteView.colseBtn addTarget:self action:@selector(deleteViewColseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteView.deleteBtn addTarget:self action:@selector(deleteViewDelteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteView.refreshBtn addTarget:self action:@selector(deleteViewRefreshBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.openView=[YLDFOpenOrDeleteView yldFOpenOrDeleteView];
    [self.openView.openBtn addTarget:self action:@selector(openViewOpenBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.openView.deleteBtn addTarget:self action:@selector(openViewDeleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void)getDataList
{
    NSString *statusStr;
    if (self.nowBtn.tag==1) {
        statusStr=@"open";
    }else{
        statusStr=@"close";
    }
    [HTTPCLIENT myBuysnewLsitWithproductName:_keyWord Withstatus:statusStr Withpage:nil WithlastTime:_lastTime Success:^(id responseObject) {
        if([[responseObject objectForKey:@"success"] integerValue])
        {
            NSDictionary *data1=[responseObject objectForKey:@"data"];
            NSArray *data=data1[@"buys"];
            self.baseUrl=data1[@"url"];
            if (!_lastTime) {
                [self.dataAry removeAllObjects];
            }
            if (data.count==0) {
                [ToastView showTopToast:@"暂无更多数据"];
                [self.tableView reloadData];
            }else{
                
                NSArray *modelAry=[YLDFBuyModel YLDFBuyModelAryWithAry:data];
                [self.dataAry addObjectsFromArray:modelAry];
                YLDFBuyModel *model=[modelAry lastObject];
                self.lastTime=model.lastTime;
                [self.tableView reloadData];
            }
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } failure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}
-(void)longPressForSelectAction
{
    if (!self.tableView.editing)
    {
        self.tableView.editing = YES;
        
        self.tableViewB.constant=52;
        if (self.nowBtn.tag==1) {
            CGRect frame = self.deleteView.frame;
            frame.size.width=kWidth;
            frame.origin.y=kHeight-52;
            self.deleteView.frame=frame;
            [self.view addSubview:self.deleteView];
        }else{
            CGRect frame = self.openView.frame;
            frame.size.width=kWidth;
            frame.origin.y=kHeight-52;
            self.openView.frame=frame;
            [self.view addSubview:self.openView];
        }
        
        [self.tableView removeHeader];//编辑状态取消下拉刷新
        [self.tableView removeFooter];
        if (_selectAry.count > 0) {
            [_selectAry enumerateObjectsUsingBlock:^(YLDFBuyModel  *model, NSUInteger idx, BOOL * _Nonnull stop) {
                model.isSelect = NO;
            }];
            [_selectAry removeAllObjects];
        }
        
    }
    
}
-(void)deleteViewDelteBtnAction
{
    if (_selectAry.count==0) {
        [ToastView showTopToast:@"您还没有选择任何求购噢！"];
        return;
    }
    [self deleteViewAction];
    
}

-(void)deleteViewColseBtnAction:(UIButton *)sender
{
    if (_selectAry.count==0) {
        [ToastView showTopToast:@"您还没有选择任何求购噢！"];
        return;
    }
    __weak typeof(self)weakself =self;
    if (_nowBtn.tag==1) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"下架求购" message:@"您确定要下架该求购，下架后可在已下架的求购中重新上架。" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ShowActionV();
            NSMutableString *idstr=[NSMutableString string];
            for (YLDFBuyModel *model in _selectAry) {
                [idstr appendFormat:@"%@,",model.buyId];
            }
            [HTTPCLIENT buyCloseWithbuyIds:idstr Success:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    [ToastView showTopToast:@"下架成功"];
                    weakself.lastTime=nil;
                    [weakself.selectAry removeAllObjects];
                    [weakself getDataList];
                }else{
                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(NSError *error) {
                
            }];
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        
    }
}
-(void)deleteViewRefreshBtnAction
{
    if (_selectAry.count==0) {
        [ToastView showTopToast:@"您还没有选择任何求购噢！"];
        return;
    }
    __weak typeof(self)weakself =self;
    
    NSMutableString *idstr=[NSMutableString string];
    for (YLDFBuyModel *model in _selectAry) {
        [idstr appendFormat:@"%@,",model.buyId];
    }
    [HTTPCLIENT buyRefreshWithbuyIds:idstr Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {

            for (YLDFBuyModel *model in weakself.selectAry) {
                model.isSelect=NO;
            }
            [weakself.selectAry removeAllObjects];
            [weakself.tableView reloadData];
            [ToastView showTopToast:@"刷新成功"];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)openViewDeleteBtnAction
{
    if (_selectAry.count==0) {
        [ToastView showTopToast:@"您还没有选择任何求购噢！"];
        return;
    }
    [self deleteViewAction];
}
-(void)openViewOpenBtnAction
{
    if (_selectAry.count==0) {
        [ToastView showTopToast:@"您还没有选择任何求购噢！"];
        return;
    }
    __weak typeof(self)weakself =self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上架求购" message:@"您确定要上架该求购吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString *idstr=[NSMutableString string];
        for (YLDFBuyModel *model in _selectAry) {
            [idstr appendFormat:@"%@,",model.buyId];
        }
        ShowActionV();
        
        [HTTPCLIENT buyOpenWithbuyIds:idstr withPartyId:nil Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"上架成功"];
                weakself.lastTime=nil;
                [weakself.selectAry removeAllObjects];
                [weakself getDataList];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)deleteViewAction
{
    __weak typeof(self)weakself =self;
    //在这里呼出下方菜单按钮项
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除求购" message:@"您确定要删除该求购，删除后无法恢复。" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString *idstr=[NSMutableString string];
        for (YLDFBuyModel *model in _selectAry) {
            [idstr appendFormat:@"%@,",model.buyId];
        }
        
        ShowActionV();
        
        [HTTPCLIENT buyDeleteWithbuyIds:idstr withPartyId:nil  Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"删除成功"];
                weakself.lastTime=nil;
                [weakself.selectAry removeAllObjects];
                //                [weakself.dataAry removeObject:model];
                [weakself getDataList];
                //                [weakself.tableView reloadData];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)selectBtnAction:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    if (self.tableView.editing) {
        [ToastView showTopToast:@"请先按左上方的返回按钮，退出编辑状态"];
        return;
    }
    //    [self.dataAry removeAllObjects];
    self.lastTime=nil;
    if (sender.tag==1) {
        CGRect frame=self.moveView.frame;
        frame.size.width=kWidth/2-40;
        frame.origin.x=20;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.moveView.frame=frame;
        }];
    }else if(sender.tag==2)
    {
        CGRect frame=self.moveView.frame;
        frame.size.width=kWidth/2-40;
        frame.origin.x=kWidth/2+20;
        [UIView animateWithDuration:0.3 animations:^{
            self.moveView.frame=frame;
        }];
    }
    sender.selected=YES;
    self.nowBtn.selected=NO;
    self.nowBtn=sender;
    [self getDataList];
}
-(void)backBtnAction:(UIButton *)sender
{
    if (self.tableView.editing) {
        self.tableView.editing = NO;
        //        bottomcell.hidden = YES;
        self.tableViewB.constant=0;
        [_selectAry removeAllObjects];
        [self.deleteView removeFromSuperview];
        [self.openView removeFromSuperview];
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        [self.tableView addHeaderWithCallback:^{//添加刷新控件
            //            _pageCount=1;
            weakSelf.lastTime=nil;
            [weakSelf getDataList];
        }];
        [self.tableView addFooterWithCallback:^{
            [weakSelf getDataList];
        }];
        
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.estimatedRowHeight=190.0;
    tableView.rowHeight=UITableViewAutomaticDimension;
    return tableView.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDFMyBuyTableViewCell *cell=[tableView  dequeueReusableCellWithIdentifier:@"YLDFMyBuyTableViewCell"];
    if (!cell) {
        cell=[YLDFMyBuyTableViewCell yldFMyBuyTableViewCell];
        cell.deletgate=self;
    }
    YLDFBuyModel *model=self.dataAry[indexPath.row];
    cell.model=model;
    return cell;
}
-(void)textFieldChangeVVWithStr:(NSString *)textStr
{
    if (self.keyWord.length==0&&textStr.length==0) {
        return;
    }
    self.keyWord=textStr;
    self.lastTime=nil;
    [self getDataList];
}
-(void)myBuyColseOrOpenWithModel:(YLDFBuyModel *)model
{
    if (self.tableView.editing)
    {
        return;
    }
    __weak typeof(self)weakself =self;
    //在这里呼出下方菜单按钮项
    if ([model.status isEqualToString:@"open"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"下架求购" message:@"您确定要下架该求购，下架后可在已下架的求购中重新上架。" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ShowActionV();
            

            [HTTPCLIENT buyCloseWithbuyIds:model.buyId Success:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    [ToastView showTopToast:@"下架成功"];
                    [weakself.dataAry removeObject:model];
                    [weakself.tableView reloadData];
                }else{
                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(NSError *error) {
                
            }];
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if ([model.status isEqualToString:@"close"])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上架求购" message:@"您确定要上架该求购吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ShowActionV();
            
            [HTTPCLIENT buyOpenWithbuyIds:model.buyId withPartyId:model.partyId
                Success:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    [ToastView showTopToast:@"上架成功"];
                    [weakself.dataAry removeObject:model];
                    [weakself.tableView reloadData];
                }else{
                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(NSError *error) {
                
            }];
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(void)myBuyEditWithModel:(YLDFBuyModel *)model{
    if (self.tableView.editing)
    {
        return;
    }
    YLDFBuyFBViewController *vc=[YLDFBuyFBViewController new];
    vc.buyIdstr=model.buyId;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)myBuyDeleteWithModel:(YLDFBuyModel *)model
{
    if (self.tableView.editing)
    {
        return;
    }
    __weak typeof(self)weakself =self;
    //在这里呼出下方菜单按钮项
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除求购" message:@"您确定要删除该求购，删除后无法恢复。" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ShowActionV();

        [HTTPCLIENT buyDeleteWithbuyIds:model.buyId withPartyId:nil  Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"删除成功"];
                [weakself.dataAry removeObject:model];
                [weakself.tableView reloadData];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }]];

    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)myBuyRefreshWithModel:(YLDFBuyModel *)model{
    if (self.tableView.editing)
    {
        return;
    }

    [HTTPCLIENT buyRefreshWithbuyIds:model.buyId Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"刷新成功"];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.dataAry.count<=0)
    {
        return;
    }
    YLDFBuyModel *model = self.dataAry[indexPath.row];
    YLDFMyBuyTableViewCell *cell = (YLDFMyBuyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  
    // 判断编辑状态,必须要写
    if (self.tableView.editing)
    {
        
        
        if (model.isSelect == YES) {
            model.isSelect = NO;
            //            cell.isSelect = NO;
            cell.selected = NO;
            // 删除反选数据
            if ([_selectAry containsObject:model])
            {
                [_selectAry removeObject:model];
            }
            
            return;
        }else{
            // 添加到我们的删除数据源里面
            model.isSelect = YES;
            [_selectAry addObject:model];

        }
        
        
        return;
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (self.dataAry.count>0) {
            
            YLDFmyBuyDetialViewController *vc=[YLDFmyBuyDetialViewController new];
            YLDFBuyModel *model=self.dataAry[indexPath.row];
            vc.model=model;
            vc.delegate=self;
            vc.baseUrl=self.baseUrl;
            [self.navigationController pushViewController:vc animated:YES];
            //NSLog(@"%@",model.uid);
            
        }
    }
    
}
// 反选方法
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataAry.count<=0)
    {
        return;
    }
    // 判断编辑状态,必须要写
    if (self.tableView.editing)
    {
        // 获取当前反选显示数据
        YLDFBuyModel *model = [self.dataAry objectAtIndex:indexPath.row];
        model.isSelect = NO;
        // 删除反选数据
        if ([_selectAry containsObject:model])
        {
            [_selectAry removeObject:model];
        }
    }
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 可选方法实现
// 设置删除按钮标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}
// 设置行是否可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 删除数据风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:YES animated:animated];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"editing"]) {
        if ([[change valueForKey:NSKeyValueChangeNewKey] integerValue] == 1) {
            [self.tableView removeGestureRecognizer:_tapDeleteGR];
        }
        else {
            [self.tableView addGestureRecognizer:_tapDeleteGR];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)myBuyDetialColseOrOpenWithModel:(YLDFBuyModel *)model
{
    if ([model.status isEqualToString:@"open"]) {
        if (self.nowBtn.tag==1) {
            if (self.dataAry.count>0) {
                [self.dataAry insertObject:model atIndex:0];
            }else{
               [self.dataAry addObject:model];
            }
            
        }else{
            [self.dataAry removeObject:model];
        }
        [self.tableView reloadData];
    }else{
        if (self.nowBtn.tag==2) {
            if (self.dataAry.count>0) {
                [self.dataAry insertObject:model atIndex:0];
            }else{
                [self.dataAry addObject:model];
            }
            
        }else{
            [self.dataAry removeObject:model];
        }
        [self.tableView reloadData];
    }
}
- (IBAction)qiugouFabuAction:(UIButton *)sender {
    YLDFBuyFBViewController *vc=[YLDFBuyFBViewController new];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)fabuSuccessWithbuyId:(NSDictionary *)buydic
{
    self.lastTime=nil;
    [self getDataList];
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
