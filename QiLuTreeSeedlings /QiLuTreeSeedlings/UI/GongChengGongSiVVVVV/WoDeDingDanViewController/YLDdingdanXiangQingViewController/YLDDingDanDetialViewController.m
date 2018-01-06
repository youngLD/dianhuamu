//
//  YLDDingDanDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDDingDanDetialViewController.h"
#import "YLDDingDanJianJieView.h"
#import "YLDEditDingDanViewController.h"
#import "YLDDDDMMTableViewCell.h"
#import "YLDDingDanDetialModel.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "YLDSearchNavView.h"
#import "KMJRefresh.h"
#import "YLDBaoJiaDetialViewController.h"
#import "YLDHeZuoDetialViewController.h"
#import "YLDDingDanMMBianJiViewController.h"
@interface YLDDingDanDetialViewController ()<UITableViewDelegate,UITableViewDataSource,YLDSearchNavViewDelegate,YLDDDDMMTableViewCellDelegate,YLDDingDanMMBianJiViewCdelegate,YLDEditDingDanViewCdelegate>
@property (nonatomic,weak)UIView *moveView;
@property (nonatomic,weak)UIButton *nowBtn;
@property (nonatomic,weak)YLDDingDanJianJieView *jianjieView;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,copy)NSString *Uid;
@property (nonatomic,strong)YLDDingDanDetialModel *model;
@property (nonatomic,weak) UIButton *editingBtn;
@property (nonatomic,strong)UIButton *shenheBtn;
@property (nonatomic,weak) YLDSearchNavView *searchV;
@property (nonatomic,strong) UIButton *saerchBtn;
@property (nonatomic,strong) NSString *searchStr;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic)NSInteger pageNum;
@property (nonatomic)NSInteger type;
@property (nonatomic)NSInteger  selfType;
@property (nonatomic,strong)UIButton *opensBtn;
@end

@implementation YLDDingDanDetialViewController
-(id)initWithUid:(NSString *)uid andType:(NSInteger)type
{
    self=[super init];
    if (self) {
        self.Uid=uid;
        self.type=type;
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.selfType==5) {
        [self.tableView headerBeginRefreshing];
        self.selfType=0;
    }
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"订单详情";
    self.pageNum=1;
    self.dataAry=[NSMutableArray array];
    [self topActionView];
    YLDDingDanJianJieView *jianjieView=[YLDDingDanJianJieView yldDingDanJianJieView];
    CGRect tempFrame=jianjieView.frame;
    tempFrame.origin.y=115;
    jianjieView.frame=tempFrame;
    self.jianjieView=jianjieView;
    [self.view addSubview:jianjieView];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 115, kWidth, kHeight-115)];
    
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    __weak typeof(self) weakSelf=self;
    [tableView addHeaderWithCallback:^{
        weakSelf.pageNum=1;
        ShowActionV();
        [weakSelf getdataAction];
    }];
    [tableView addFooterWithCallback:^{
        weakSelf.pageNum+=1;
        ShowActionV();
        [weakSelf getdataAction];
    }];
    self.tableView=tableView;
    [self.view addSubview:tableView];
    tableView.hidden=YES;
    if (self.type==weishenhe) {
        UIButton *editingBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-46, 24, 30, 30)];
        [editingBtn setEnlargeEdgeWithTop:5 right:10 bottom:10 left:20];
        [self.navBackView addSubview:editingBtn];
        [editingBtn setImage:[UIImage imageNamed:@"edintBtn"] forState:UIControlStateNormal];
        [editingBtn addTarget: self action:@selector(editingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.editingBtn=editingBtn;
        
        UIButton *shenheBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-50, kWidth-80, 40)];
        [shenheBtn setBackgroundColor:NavColor];
        self.shenheBtn=shenheBtn;
        [shenheBtn addTarget: self action:@selector(shenhetongguo) forControlEvents:UIControlEventTouchUpInside];
        [shenheBtn setTitle:@"审核通过" forState:UIControlStateNormal];
        [self.view addSubview:shenheBtn];
        CGRect frame=tableView.frame;
        frame.size.height=kHeight-165;
        tableView.frame=frame;
        
    }
    UIButton *opensBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 24, 50, 30)];
    [opensBtn setEnlargeEdgeWithTop:5 right:10 bottom:10 left:20];
    
//    [opensBtn setImage:[UIImage imageNamed:@"edintBtn"] forState:UIControlStateNormal];
    [opensBtn setTitle:@"关闭" forState:UIControlStateNormal];
//    [opensBtn setTitle:@"打开" forState:UIControlStateSelected];
    [opensBtn addTarget: self action:@selector(opensAndColseAction:) forControlEvents:UIControlEventTouchUpInside];
//    opensBtn.hidden=YES;
    self.opensBtn=opensBtn;

    UIButton *searchShowBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-40, 23, 30, 30)];
//    [searchShowBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchShowBtn setEnlargeEdgeWithTop:5 right:10 bottom:10 left:20];
    [searchShowBtn setImage:[UIImage imageNamed:@"ico_顶部搜索"] forState:UIControlStateNormal];
    [searchShowBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.saerchBtn=searchShowBtn;
    //[self.navBackView addSubview:searchShowBtn];
    YLDSearchNavView *searchV =[[YLDSearchNavView alloc]init];
    self.searchV=searchV;
    searchV.delegate=self;
    searchV.hidden=YES;
    searchV.textfield.placeholder=@"请输入苗木名称";
    [self.navBackView addSubview:searchV];
    
    ShowActionV();
    [self getdataAction];

}
-(void)MMreload
{
    ShowActionV();
    [self getdataAction];
}
-(void)ddJJreload
{
    ShowActionV();
    [self getdataAction];
}
-(void)shenhetongguo
{
    [HTTPCLIENT shenhedingdanWithUid:self.model.uid WithauditStatus:YES Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"审核成功，即将返回"];
            if ([self.delegate respondsToSelector:@selector(shenheTongGuoAcion)]) {
                [self.delegate shenheTongGuoAcion];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)getdataAction
{
    
    [HTTPCLIENT myDingDanDetialWithUid:self.Uid WithPageSize:@"15" WithPageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] Withkeyword:self.searchStr Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]==1) {
            NSDictionary *dic=[[responseObject objectForKey:@"result"] objectForKey:@"orderDetail"];
            if (self.pageNum==1) {
                YLDDingDanDetialModel *model=[YLDDingDanDetialModel yldDingDanDetialModelWithDic:dic];
                if (self.type==weishenhe) {
                    model.auditStatus=0;
                }
                self.model=model;
                
                self.jianjieView.model=model;
                if ([model.status isEqualToString:@"报价中"]) {
//                    self.type=baojiaozhong;
                    if (model.auditStatus!=0&&_nowBtn.tag==0) {
                        [self.navBackView addSubview:self.opensBtn];
                        self.opensBtn.hidden=NO;
                        if ([model.status isEqualToString:@"报价中"]) {
                            self.opensBtn.selected=NO;
                        }else{
                            self.opensBtn.selected=YES;
                        }
                    }
                   
                }else{
                    [self.opensBtn removeFromSuperview];
                }
//                if (![self.model.status isEqualToString:@"可编辑"]) {
//                    [self.editingBtn removeFromSuperview];
//                    self.editingBtn=nil;
//                }
                if ([model.status isEqualToString:@"已结束"]&&self.shenheBtn)
                {
                    self.type=yijieshu;
                    [self.shenheBtn removeFromSuperview];
                    [self.editingBtn removeFromSuperview];
                }
                
                [self.dataAry removeAllObjects];

            }
            
            NSArray *itemAry=[dic objectForKey:@"itemList"];
            if (itemAry.count==0) {
                self.pageNum--;
            }else
            {
                [self.dataAry addObjectsFromArray:itemAry];
                
            }
            if (self.pageNum<1) {
                self.pageNum=1;
            }
            [self.tableView reloadData];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
        RemoveActionV();
    } failure:^(NSError *error) {
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
        RemoveActionV();
    }];
}
-(void)textFieldChangeVVWithStr:(NSString *)textStr
{
    self.searchStr=textStr;
    self.pageNum=1;
    [self getdataAction];
}
-(void)editingBtnAction:(UIButton *)sender
{
    YLDEditDingDanViewController *EditVC=[[YLDEditDingDanViewController alloc]initWithUid:self.model.uid];
    EditVC.delegate=self;
    [self.navigationController pushViewController:EditVC animated:YES];
}
-(void)searchBtnAction:(UIButton *)sender
{
    sender.selected=YES;
    [sender removeFromSuperview];
    self.searchV.hidden=NO;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLDDDDMMTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDDDDMMTableViewCell"];
    if (!cell) {
        cell=[YLDDDDMMTableViewCell yldDDDMMTableViewCell];
        cell.delegate=self;
    }
    NSDictionary *DIC=self.dataAry[indexPath.row];
    cell.messageDic=DIC;
    cell.bianhaoLab.text=[NSString stringWithFormat:@"%ld",(long)(indexPath.row+1)];
    NSString *sdsadsa=DIC[@"description"];

    CGFloat height=[self getHeightWithContent:[NSString stringWithFormat:@"规格要求:%@",sdsadsa] width:kWidth-50 font:15];
    CGRect frame=cell.frame;
    [cell.lineImgV setBackgroundColor:kLineColor];
     NSInteger stauts=[[DIC objectForKey:@"stauts"] integerValue];
    if (height>20) {
       frame.size.height=170+height;
    }else{
       
            frame.size.height=190;
    }
    cell.frame=frame;
   
   if (self.type!=weishenhe) {
      
       if (stauts==4) {
           if (cell.chakanBtn.enabled==YES) {
               cell.chakanBtn.enabled=NO;
               cell.chakanBtn.hidden=YES;
           }
       }
       
       cell.deleteBtn.hidden=YES;
       cell.deleteBtn.enabled=NO;
//       [cell.chakanBtn setBackgroundColor:detialLabColor];
//       [cell.chakanBtn setTitle:@"暂无报价" forState:UIControlStateNormal];
   }else{
       if (stauts!=4) {
           if (cell.chakanBtn.enabled==NO) {
               cell.chakanBtn.enabled=YES;
               cell.chakanBtn.hidden=NO;
           }
       }
       
       cell.deleteBtn.enabled=YES;
       cell.deleteBtn.hidden=NO;
      
   }
    if ([self.model.status isEqualToString:@"报价中"]) {
        if(self.model.auditStatus!=0&&self.model.opens==1){
            cell.deleteBtn.enabled=YES;
            cell.deleteBtn.hidden=NO;
            NSInteger open=[DIC[@"opens"] integerValue];
            if (open==1) {
                cell.deleteBtn.tag=6;
                [cell.deleteBtn setTitle:@"关闭" forState:UIControlStateNormal];
                [cell.deleteBtn setBackgroundColor:RedBtnColor];
            }else{
                cell.deleteBtn.tag=7;
                [cell.deleteBtn setTitle:@"开启" forState:UIControlStateNormal];
                 [cell.deleteBtn setBackgroundColor:NavColor ];
            }
        }
    }
    [cell.lineImgV setBackgroundColor:kLineColor];
    if ([self.model.status isEqualToString:@"已成交"]||[self.model.status isEqualToString:@"已结束"]) {
        
        if (stauts==4) {
            [cell.lineImgV setBackgroundColor:[UIColor clearColor]];
        }
    }
    return cell;
}
-(void)chakanActionWithTag:(NSInteger)tag andDic:(NSDictionary *)dic
{
    if (tag==1) {
        self.selfType=5;
        YLDBaoJiaDetialViewController *yldBaoJiaVC=[[YLDBaoJiaDetialViewController alloc] initWithUid:[dic objectForKey:@"uid"]];
        [self.navigationController pushViewController:yldBaoJiaVC animated:YES];
    }
    if (tag==3) {
        self.selfType=5;
        YLDHeZuoDetialViewController *hezuodeltai=[[YLDHeZuoDetialViewController alloc]initWithOrderUid:nil WithitemUid:[dic objectForKey:@"uid"]];
        [self.navigationController pushViewController:hezuodeltai animated:YES];
    }
    if (tag==4) {
        self.selfType=5;
        YLDDingDanMMBianJiViewController *MMBJVC=[[YLDDingDanMMBianJiViewController alloc]initWithUid:[dic objectForKey:@"uid"]];
        MMBJVC.delegate=self;
        [self.navigationController pushViewController:MMBJVC animated:YES];
    }
    if (tag==5) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"订单苗木删除" message:@"您确定删除该苗木信息？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        
        
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [HTTPCLIENT deleteOrderMMByUid:[dic objectForKey:@"uid"] Success:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"]integerValue]) {
                    [ToastView showTopToast:@"苗木信息删除成功"];
                    [self.dataAry removeObject:dic];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新，
                        
                        [self.tableView reloadData];
                    });
                }else{
                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(NSError *error) {
                
            }];
            
        }]];
        

        [self presentViewController:alertController animated:YES completion:nil];
    }
    if (tag==6) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"订单苗木关闭" message:@"您确定关闭该苗木信息？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        
        
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ShowActionV();
            [HTTPCLIENT GCGSOrderItemOpenWithUid:[dic objectForKey:@"uid"] andOrdeUid:self.model.uid Withstatus:@"0"   Success:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"]integerValue]) {
                    [ToastView showTopToast:@"苗木信息关闭成功"];
//                    [self.dataAry removeObject:dic];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新，
                        
                        [self.tableView headerBeginRefreshing];
                    });
                }else{
                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(NSError *error) {
                
            }];
            
        }]];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    if (tag==7) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"订单苗木开启" message:@"您确定开启该苗木信息？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        
        
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ShowActionV();
            [HTTPCLIENT GCGSOrderItemOpenWithUid:[dic objectForKey:@"uid"] andOrdeUid:self.model.uid Withstatus:@"1"   Success:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"]integerValue]) {
                    [ToastView showTopToast:@"苗木信息开启成功"];
//                    [self.dataAry removeObject:dic];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新，
                        
                        [self.tableView headerBeginRefreshing];
                    });
                }else{
                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(NSError *error) {
                
            }];
            
        }]];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *DIC=self.dataAry[indexPath.row];
    
    NSString *sdsadsa=DIC[@"description"];
    CGFloat height=[self getHeightWithContent:[NSString stringWithFormat:@"规格要求:%@",sdsadsa] width:kWidth-50 font:15];
    //    CGRect frame=cell.frame;
    NSInteger stauts=[[DIC objectForKey:@"stauts"] integerValue];

    if ([self.model.status isEqualToString:@"已成交"]||[self.model.status isEqualToString:@"已结束"]) {
        
        if (stauts==4) {
            if (height>20) {
                
                return 120+height;
            }else{
                
                return 140;
            }
        }
    }
    if (height>20) {
       
            return 170+height;
    }else{
       
            return 190;
    }
}
- (void)topActionView {
    NSArray *ary=@[@"订单简介",@"苗木详情"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
    view.layer.shadowOpacity = 0.2;////阴影透明度，默认0
    view.layer.shadowOffset  = CGSizeMake(0, 3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    
    view.layer.shadowRadius  = 3;//阴影半径，默认3
    CGFloat btnWith=kWidth/ary.count;
    UIView *moveView=[[UIView alloc]initWithFrame:CGRectMake(0, 47, btnWith, 3)];
    [moveView setBackgroundColor:NavYellowColor];
    self.moveView=moveView;
    [view addSubview:moveView];
    for (int i=0; i<ary.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(btnWith*i, 0, btnWith, 47)];
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        [btn setTitle:ary[i] forState:UIControlStateSelected];
        [btn setTitleColor:titleLabColor forState:UIControlStateNormal];
        [btn setTitleColor:NavYellowColor forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
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
    if (sender.tag==0) {
        self.jianjieView.hidden=NO;
        self.editingBtn.hidden=NO;
        self.tableView.hidden=YES;
        self.searchV.hidden=YES;
        [self.saerchBtn removeFromSuperview];
        if ([self.model.status isEqualToString:@"报价中"]) {
            if (self.model.auditStatus!=0) {
                [self.navBackView addSubview:self.opensBtn];
                self.opensBtn.hidden=NO;
            }
    }

    }
    if (sender.tag==1) {
        self.jianjieView.hidden=YES;
        self.tableView.hidden=NO;
         self.editingBtn.hidden=YES;
        if (self.saerchBtn.selected) {
             self.searchV.hidden=NO;
        }else{
          [self.navBackView addSubview:self.saerchBtn];  
        }
        [self.opensBtn removeFromSuperview];
        [self.tableView reloadData];
    }
    CGRect frame=_moveView.frame;
    frame.origin.x=kWidth/2*(sender.tag);
    [UIView animateWithDuration:0.3 animations:^{
        _moveView.frame=frame;
    }];
}
-(void)hidingAction
{
    [self.navBackView addSubview:self.saerchBtn];
    self.saerchBtn.selected=NO;
}
//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)opensAndColseAction:(UIButton *)sender
{
    NSString *title = NSLocalizedString(@"订单关闭", nil);
    NSString *message = NSLocalizedString(@"您确认关闭该订单，关闭后无法再打开！", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
        [HTTPCLIENT GCGSOrderOpenWithUid:self.model.uid Withstatus:@"0" Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"关闭成功"];
                ShowActionV();
                [self getdataAction];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
