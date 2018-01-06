//
//  YLDCommentRepliesViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/4/25.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDCommentRepliesViewController.h"
#import "ChangyanSDK.h"
#import "KMJRefresh.h"
#import "YLDSCommentAView.h"//评论框
#import "YLDSPingLunSrView.h"
#import "YLDSPingLunModel.h"
#import "YLDSPingLunCell.h"
#import "ZIKFunction.h"
#import "YLDLoginViewController.h"
#import "UINavController.h"
#import "UIDefines.h"
#import "KMJRefresh.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface YLDCommentRepliesViewController ()<fabiaoDelgate,YLDSPingLunCellDelgate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSInteger pageNum;
@property (nonatomic,strong)YLDSCommentAView *commentV;
@property (nonatomic,strong)YLDSPingLunSrView *fabiaoV;
@property (nonatomic,strong)UIButton *collectionBtn;
@property (nonatomic,strong)NSMutableArray *pinglunAry;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)YLDSPingLunModel *originModel;
//@property (nonatomic,strong)UILabel *commetnNumLab;
@end

@implementation YLDCommentRepliesViewController
-(void)fabiaoActionWithStr:(NSString *)comment
{
    __weak typeof(self) weakself=self;
    NSString *replyID=nil;
    if (self.fabiaoV.huifumodel) {
        replyID = [NSString stringWithFormat:@"%@",self.fabiaoV.huifumodel.uid];
    }else{
        replyID = [NSString stringWithFormat:@"%@",self.comment_id];
    }
    NSString *metadata=nil;
    if (self.fabiaoV.huifumodel) {
        metadata=[NSString stringWithFormat:@"//@%@ :%@",self.fabiaoV.huifumodel.memberName,self.fabiaoV.huifumodel.comment];
    }
    [ChangyanSDK submitComment:self.topic_id content:comment replyID:replyID score:@"5" appType:40 picUrls:nil metadata:metadata completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        weakself.pageNum=1;
        [weakself getcommentRepliyWithPageNum:[NSString stringWithFormat:@"%ld",weakself.pageNum]];
        [weakself.fabiaoV clearAvtion];
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pinglunAry=[NSMutableArray array];
    
    UIView *viewtop=[[UIView alloc]initWithFrame:CGRectMake(0, 20, kWidth, 55)];
//    UILabel *commentnumLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 55)];
//    [commentnumLab setTextColor:DarkTitleColor];
//    [commentnumLab setTextAlignment:NSTextAlignmentCenter];
//    self.commetnNumLab=commentnumLab;
//    [viewtop addSubview:commentnumLab];
    
    [viewtop setBackgroundColor:[UIColor whiteColor]];
    viewtop.layer.cornerRadius=8;
    [self.view addSubview:viewtop];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 8, 25,25)];
    [backBtn setEnlargeEdgeWithTop:10 right:60 bottom:15 left:10];
    [backBtn setImage:[UIImage imageNamed:@"xiala2"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [viewtop addSubview:backBtn];
    self.pageNum=1;
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-50) style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView=tableView;
    [self.view addSubview:tableView];
    __weak typeof(self)weakSelf=self;
    [tableView addFooterWithCallback:^{
        weakSelf.pageNum+=1;
        [weakSelf getcommentRepliyWithPageNum:[NSString stringWithFormat:@"%ld",weakSelf.pageNum]];
    }];
    YLDSCommentAView *yldcommentAV=[[YLDSCommentAView alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth, 50)];
    self.commentV=yldcommentAV;
    [yldcommentAV.shareBtn removeFromSuperview];
    [yldcommentAV.collectBtn removeFromSuperview];
    [yldcommentAV.commentBtn removeFromSuperview];
//    self.collectionBtn=yldcommentAV.collectBtn;
    CGRect tempframe=yldcommentAV.commentLab.frame;
    tempframe.size.width=kWidth-20;
    yldcommentAV.commentLab.frame=tempframe;
    yldcommentAV.fabiaoBtn.frame=tempframe;
    [yldcommentAV.fabiaoBtn addTarget:self action:@selector(fabiaoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yldcommentAV];
    YLDSPingLunSrView *VVVVZ=[[YLDSPingLunSrView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, kHeight)];
    VVVVZ.delegate=self;
    self.fabiaoV=VVVVZ;

    [self getcommentRepliyWithPageNum:[NSString stringWithFormat:@"%ld",self.pageNum]];
    [self.view addSubview:self.fabiaoV];
    [self.fabiaoV showAction];
    // Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
    self.tableView.estimatedRowHeight = 90;
    return tableView.rowHeight;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
       return self.pinglunAry.count;
    }else{
        return 1;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1)
    {
        YLDSPingLunCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSPingLunCell"];
        if (!cell) {
            cell=[YLDSPingLunCell yldSPingLunCell];
        }
        YLDSPingLunModel *model=self.pinglunAry[indexPath.row];
        cell.delgate=self;
        cell.model=model;
        return cell;
    }else{
        YLDSPingLunCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSPingLunCell"];
        if (!cell) {
            cell=[YLDSPingLunCell yldSPingLunCell];
            [cell.deleteBtn removeFromSuperview];
        }
//        YLDSPingLunModel *model=self.pinglunAry[indexPath.row];
        cell.delgate=self;
        cell.model=self.originModel;
        return cell;

    }

}
-(void)fabiaoAction
{
    if(![APPDELEGATE isNeedLogin])
    {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    [self.view addSubview:self.fabiaoV];
    [self.fabiaoV showAction];
    
}
-(void)deleteActionWithModel:(YLDSPingLunModel *)model{
    if(![APPDELEGATE isNeedLogin])
    {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    self.fabiaoV.huifumodel=model;
    [self.view addSubview:self.fabiaoV];
    [self.fabiaoV showAction];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if(![APPDELEGATE isNeedLogin])
        {
            YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
            [ToastView showTopToast:@"请先登录"];
            UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
            
            [self presentViewController:navVC animated:YES completion:^{
                
            }];
            return;
        }
        YLDSPingLunModel *model=self.pinglunAry[indexPath.row];
        self.fabiaoV.huifumodel=model;
        [self.view addSubview:self.fabiaoV];
        [self.fabiaoV showAction];

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 20;
    }else{
        return 0.5;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 20)];
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
        [imageV setBackgroundColor:BGColor];
        [view addSubview:imageV];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 120, 20)];
        [lab setFont:[UIFont systemFontOfSize:14]];
        [lab setTextColor:DarkTitleColor];
        if (self.pinglunAry.count==0) {
            [lab setText:@"抢先评论"];
        }else{
            [lab setText:@"全部评论"];
        }
        [view addSubview:lab];
        return view;
    }else{
       UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
        [view setBackgroundColor:BGColor];
        return view;

    }
}
-(void)getcommentRepliyWithPageNum:(NSString *)pageNum
{
    [ChangyanSDK getCommentReplies:[NSString stringWithFormat:@"%@",self.topic_id] commentID:[NSString stringWithFormat:@"%@",self.comment_id] pageSize:@"30" pageNo:pageNum completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        if (statusCode==CYSuccess) {
           NSDictionary *dic=[ZIKFunction dictionaryWithJsonString:responseStr];
            NSDictionary *originDic=dic[@"originCommentInfo"];
            self.originModel=[YLDSPingLunModel modelWithChangYanDic:originDic];
            NSArray *strAry=dic[@"comments"];
            if (strAry.count>0) {
                NSArray *ary=[YLDSPingLunModel aryWithChangYanAry:strAry];
                
                for (int i=0; i<ary.count; i++) {
                    YLDSPingLunModel *model=ary[i];
                    if(model.reply_id>0&&model.reply_id!=[self.comment_id integerValue])
                    {
                        NSDictionary *commentDic=strAry[i];
                        NSString *metadata=commentDic[@"metadata"];
                        model.reply_str=metadata;
                    }
                    
                }
                if (self.pageNum==1) {
                    [self.pinglunAry removeAllObjects];
                }
                [self.pinglunAry addObjectsFromArray:ary];
                [self.tableView reloadData];
            }else{
                if (self.pageNum==1) {
//                    [ToastView showTopToast:@"暂无评论"];
                }else{
                     [ToastView showTopToast:@"暂无更多评论"];
                }
                
            }
            
            [self.tableView footerEndRefreshing];
        }
        
    }];
}
-(void)backBtnAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)zanActionWith:(UIButton *)sender Uid:(YLDSPingLunModel *)model{
    if(![APPDELEGATE isNeedLogin])
    {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    [ChangyanSDK commentAction:1 topicID:[NSString stringWithFormat:@"%@",self.topic_id] commentID:[NSString stringWithFormat:@"%@",model.uid] completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        if (statusCode==CYSuccess) {
            //            sender.selected=YES;
            NSDictionary *dic=[ZIKFunction dictionaryWithJsonString:responseStr];
            [sender setTitle:[NSString stringWithFormat:@"%ld",[dic[@"count"] integerValue]] forState:UIControlStateNormal];
            [sender setTitle:[NSString stringWithFormat:@"%ld",[dic[@"count"] integerValue]] forState:UIControlStateSelected];
        }else{
            [ToastView showTopToast:responseStr];
        }
    }];

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
