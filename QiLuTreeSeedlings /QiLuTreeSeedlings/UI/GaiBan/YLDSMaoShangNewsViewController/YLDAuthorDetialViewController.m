//
//  YLDAuthorDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/4/8.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDAuthorDetialViewController.h"
#import "HttpClient.h"
#import "UIDefines.h"
#import "YLDZXLmodel.h"
#import "YLDSAutherBigMessageCell.h"
#import "YLDSNewsListNoPicCell.h"
#import "YLDSNewsListOnePicCell.h"
#import "YLDSNewsListThreePicCell.h"
#import "YLDLoginViewController.h"
#import "UINavController.h"
#import "ZIKFunction.h"
#import "ZIKNewsDetialViewController.h"
#import "KMJRefresh.h"
//友盟
#import "UMSocialControllerService.h"
#import "UMSocial.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface YLDAuthorDetialViewController ()<UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *newsDataAry;
@property (nonatomic,strong)YLDSAuthorModel *model;
@property (nonatomic,assign)BOOL reload;
@property (nonatomic,strong)UIView *selectView;
@property (nonatomic,assign)NSInteger pageCount;
@property (nonatomic,strong)UIButton *followBtn;
@property (nonatomic,strong)UILabel *nameLab;
@end

@implementation YLDAuthorDetialViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([APPDELEGATE isNeedLogin]&&_reload) {
        [self reloadxxx];
        _reload=NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.newsDataAry=[NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.pageCount=1;
    UIView *view=[self navView];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 63, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorColor = kLineColor;
    tableView.separatorInset = UIEdgeInsetsMake(0,10, 0,10);        // 设置端距，tableViw表示separator离左边和右边均10像素
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.bounces=NO;
    [tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tableView];
    [self.view addSubview:view];
    self.tableView=tableView;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    __weak typeof(self) weakSelf=self;
    [tableView addFooterWithCallback:^{
        weakSelf.pageCount+=1;
        [weakSelf getmoreArticleWithPage:[NSString stringWithFormat:@"%ld",weakSelf.pageCount]];
    }];
    [self reloadxxx];
}
-(void)reloadxxx
{
    [HTTPCLIENT AuthorDetialWithUid:self.authorUid Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *result=[responseObject objectForKey:@"result"];
            self.model=[YLDSAuthorModel modelWithDic:result[@"author"]];
            self.model.followCount=[result[@"followCount"] integerValue];
            
            
                if (self.pageCount==1) {
                    [self.newsDataAry removeAllObjects];
                    NSArray *newsAry=[YLDZXLmodel yldZXLmodelbyAry:[[result objectForKey:@"article"] objectForKey:@"content"]];
                    [self.newsDataAry addObjectsFromArray:newsAry];
                    
                }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                self.nameLab.text=self.model.name;
                if (self.model.follow) {
                    self.followBtn.selected=YES;
                }else{
                    self.followBtn.selected=NO;
                }
            });
            
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];

}
-(void)getmoreArticleWithPage:(NSString *)page
{
    [HTTPCLIENT articleListWithAuthorUid:self.authorUid withKeyWord:nil WithSortType:nil WithPage:page WithPageSize:nil Success:^(id responseObject) {
        if([[responseObject objectForKey:@"success"] integerValue])
        {
            NSArray *newsAry=[[responseObject objectForKey:@"result"] objectForKey:@"content"];
            if (newsAry.count==0) {
                [ToastView showTopToast:@"已无更多信息"];
                [self.tableView footerEndRefreshing];
            }else{
                NSArray *aryx=[YLDZXLmodel yldZXLmodelbyAry:newsAry];
                [self.newsDataAry addObjectsFromArray:aryx];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView footerEndRefreshing];
                });
            }
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            [self.tableView footerEndRefreshing];
        }
        
    } failure:^(NSError *error) {
       [self.tableView footerEndRefreshing];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }
    if (section==1) {
        return self.newsDataAry.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 116;
        }
        if (indexPath.row==1) {
            if (_model.remark.length>0) {
                CGFloat h=[ZIKFunction getHeightWithContent:_model.remark width:kWidth-30 font:14];
                return h+30;
            }else{
                return 30;
            }

        }
        
    }
    if (indexPath.section==1) {
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

    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 60;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        [view setBackgroundColor:[UIColor whiteColor]];
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 50)];
        [btn setTitle:@"文章" forState:UIControlStateNormal];
        [btn setTitleColor:NavColor forState:UIControlStateNormal];
        UIImageView *iamgev=[[UIImageView alloc]initWithFrame:CGRectMake(0, 48, 90, 2)];
        [iamgev setBackgroundColor:NavColor];
        [view addSubview:iamgev];
        [view addSubview:btn];
        UIImageView *iiagvvv=[[UIImageView alloc]initWithFrame:CGRectMake(0, 50, kWidth, 10)];
        [iiagvvv setBackgroundColor:BGColor];
        [view addSubview:iiagvvv];
        return view;
    }
    UIView *view;
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            YLDSAutherBigMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSAutherBigMessageCell"];
            if (!cell) {
                cell=[YLDSAutherBigMessageCell YLDSAutherBigMessageCell];
                [cell.followBtn addTarget:self action:@selector(followActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;

            }
            cell.model=self.model;
            return cell;
        }
        if (indexPath.row==1) {
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"jianjiecell"];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jianjiecell"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;

                UILabel *labzz=[[UILabel alloc]init];
                labzz.tag=11;
                [labzz setFont:[UIFont systemFontOfSize:14]];
                [labzz setTextColor:titleLabColor];
                labzz.numberOfLines=0;
            
                [cell.contentView addSubview:labzz];
            }
            UILabel *labzz=[cell.contentView viewWithTag:11];
            labzz.text=self.model.remark;
            CGFloat h=[ZIKFunction getHeightWithContent:_model.remark width:kWidth-30 font:14];
            [labzz setFrame:CGRectMake(15,15, kWidth-30,h)];
            return cell;

        }
        
    }
    if (indexPath.section==1) {
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
    }
    UITableViewCell *cell=[UITableViewCell new];
    
    return cell;
}
-(void)followActionWithBtn:(UIButton *)sender
{
    if ([APPDELEGATE isNeedLogin]) {
        
        if (!sender.selected) {
            ShowActionV();
            [HTTPCLIENT followAuthorActionWithUid:self.authorUid type:0 Success:^(id responseObject) {
              if([[responseObject objectForKey:@"success"] integerValue])
              {
                  [ToastView showTopToast:@"关注成功"];
                  self.followBtn.selected=YES;
                  self.model.follow=YES;
                  self.model.followCount+=1;
                  [self.tableView reloadData];
              }
            } failure:^(NSError *error) {
                
            }];
        }else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要取消对该用户的关注吗？" preferredStyle:UIAlertControllerStyleAlert];
            
            // 添加按钮
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                ShowActionV();
                [HTTPCLIENT followAuthorActionWithUid:self.authorUid type:1 Success:^(id responseObject) {
                    if([[responseObject objectForKey:@"success"] integerValue])
                    {
                        [ToastView showTopToast:@"取消关注成功"];
                        
                        self.followBtn.selected=NO;
                        self.model.follow=NO;
                        self.model.followCount-=1;
                        [self.tableView reloadData];
                    }
                } failure:^(NSError *error) {
                    
                }];

            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
               
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{
        [ToastView showTopToast:@"请先登录"];
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
  
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            _reload=YES;
        }];

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        YLDZXLmodel *model=self.newsDataAry[indexPath.row];
        ZIKNewsDetialViewController *zikNDVC=[[ZIKNewsDetialViewController alloc]init];
        zikNDVC.urlString=model.uid;
        zikNDVC.newstitle=model.articleCategoryName;
        zikNDVC.newstext=model.title;
        zikNDVC.newsimageUrl=[model.picAry firstObject];
        _reload=YES;
        [self.navigationController pushViewController:zikNDVC animated:YES];
    }
}
-(UIView *)navView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 65)];
    UIImageView *iamgev=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64.5)];
    [view setBackgroundColor:[UIColor clearColor]];
    [iamgev setImage:[UIImage imageNamed:@"tou"]];
    [view addSubview:iamgev];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"backBtnBlack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backbtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setEnlargeEdgeWithTop:10 right:40 bottom:5 left:10];
    [view addSubview:backBtn];
    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-42, 26, 30, 30)];
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:[UIImage imageNamed:@"shareaciotn"] forState:UIControlStateNormal];
    [view addSubview:shareBtn];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(105, 26, kWidth-210,30)];
    [nameLab setFont:[UIFont systemFontOfSize:17]];
    [nameLab setTextAlignment:NSTextAlignmentCenter];
    [nameLab setTextColor:[UIColor whiteColor]];
    nameLab.hidden=YES;
    [view addSubview:nameLab];
    self.nameLab=nameLab;
    UIButton *followBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-105, 27.5, 56, 27)];
    [followBtn setImage:[UIImage imageNamed:@"unfollowA"] forState:UIControlStateNormal];
    [followBtn setImage:[UIImage imageNamed:@"followA"] forState:UIControlStateSelected];
    [followBtn addTarget:self action:@selector(followActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.followBtn=followBtn;
    followBtn.hidden=YES;
    [view addSubview:followBtn];
    
    return view;
}
-(void)backbtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)shareBtnAction
{
    [self umengShare];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (scrollView.contentOffset.y <= 20 &&scrollView.bounces == YES) {
        scrollView.bounces = NO;

    }
    else if (scrollView.contentOffset.y >=30&&scrollView.bounces == NO){
            scrollView.bounces = YES;
     }
    
    if (scrollView.contentOffset.y <= 116 &&self.nameLab.hidden == NO) {
        self.nameLab.hidden=YES;
        self.followBtn.hidden=YES;
        
    }
    else if (scrollView.contentOffset.y >116&&self.nameLab.hidden == YES){
        self.nameLab.hidden=NO;
        self.followBtn.hidden=NO;
    }
}
#pragma mark - 友盟分享
- (void)umengShare {
    //    [self requestShareData];
    //    return;
    NSString *shareUrl=[NSString stringWithFormat:@"%@home/AuthorIndex?authorId=%@",NEWSBaseURLString,self.authorUid];
    [UMSocialSnsService presentSnsIconSheetView:self
     //appKey:@"569c3c37e0f55a8e3b001658"
                                         appKey:@"56fde8aae0f55a1cd300047c"
                                      shareText:self.model.remark
                                     shareImage:[UIImage imageNamed:@"logV"]
                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToQzone,UMShareToWechatSession,UMShareToQQ]
                                       delegate:self];
    
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
    
    //如果是朋友圈，则替换平台参数名即可
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
    
    [UMSocialData defaultData].extConfig.qqData.url    = shareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
    //设置微信好友title方法为
    //NSString *titleString = @"苗信通-苗木买卖神器";
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.model.name;
    
    //设置微信朋友圈title方法替换平台参数名即可
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.model.name;
    
    //QQ设置title方法为
    
    [UMSocialData defaultData].extConfig.qqData.title = self.model.name;
    
    //Qzone设置title方法将平台参数名替换即可
    
    [UMSocialData defaultData].extConfig.qzoneData.title = self.model.name;
    
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    //NSLog(@"didClose is %d",fromViewControllerType);
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        
    }
    else {
        CLog(@"%@",response);
    }
}

-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response
{
    //NSLog(@"finish share with response is %@",response);
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
