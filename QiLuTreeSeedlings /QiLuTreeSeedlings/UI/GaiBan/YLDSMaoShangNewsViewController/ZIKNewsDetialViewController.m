//
//  ZIKNewsDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/26.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "ZIKNewsDetialViewController.h"
#import "YLDDaShangViewController.h"
#import "YLDSCommentAView.h"
#import "YLDSPingLunSrView.h"
//友盟
#import "UMSocialControllerService.h"
#import "UMSocial.h"
#import "YLDLoginViewController.h"
#import "UINavController.h"
#import "AFHTTPSessionManager.h"
#import "HttpDefines.h"
#import "YLDAuthorDetialViewController.h"
#import "ChangyanSDK.h"
#import "YLDCommentRepliesViewController.h"
#import "UIImageView+AFNetworking.h"
@interface ZIKNewsDetialViewController ()<UIWebViewDelegate,fabiaoDelgate,UMSocialUIDelegate>
@property (nonatomic,strong) UIWebView *newsWebView;
@property (nonatomic,strong)YLDSPingLunSrView *fabiaoV;
@property (nonatomic,strong)YLDSCommentAView *yldscommetnV;
@property (nonatomic,copy) NSString *oldStr;
@property (nonatomic,copy) NSString *topic_id;
@property (nonatomic,strong)UIImage *shareImage;

@end

@implementation ZIKNewsDetialViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self selfViewRreload];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.newsWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-50-64)];
    self.newsWebView.delegate=self;
    self.newsWebView.scalesPageToFit = YES;
    [self.view addSubview:self.newsWebView];
    
    [self.backBtn removeFromSuperview];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"backBtnBlack"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [self.navBackView addSubview:backBtn];
    self.backBtn=backBtn;
    [backBtn addTarget:self action:@selector(backbtnAcion:) forControlEvents:UIControlEventTouchUpInside];
    YLDSCommentAView *yldcommentAV=[[YLDSCommentAView alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth, 50)];
    self.yldscommetnV=yldcommentAV;
    [yldcommentAV.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [yldcommentAV.collectBtn addTarget:self action:@selector(collectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [yldcommentAV.commentBtn addTarget:self action:@selector(commentBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [yldcommentAV.fabiaoBtn addTarget:self action:@selector(fabiaoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yldcommentAV];
    YLDSPingLunSrView *VVVVZ=[[YLDSPingLunSrView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, kHeight)];
    VVVVZ.delegate=self;
    self.fabiaoV=VVVVZ;

    if (self.newstitle){
        self.vcTitle=self.newstitle;
    }else{
        self.vcTitle=@"新闻";
    }
    self.oldStr=self.urlString;
}
-(void)selfViewRreload
{
     NSString  *urlString=nil;
    if ([APPDELEGATE isNeedLogin]) {
        urlString = [NSString stringWithFormat:@"%@home/index?artid=%@&memberid=%@&type=1",NEWSBaseURLString,self.urlString,APPDELEGATE.userModel.access_id];
    }else{
        urlString = [NSString stringWithFormat:@"%@home/index?artid=%@&type=1",NEWSBaseURLString,self.urlString];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [self.newsWebView loadRequest:request];
        __weak typeof(self) weakSelf=self;
    [ChangyanSDK loadTopic:@"" topicTitle:nil topicSourceID:self.urlString topicCategoryID:nil pageSize:@"10" hotSize:@"3" orderBy:nil style:nil depth:nil subSize:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr)
     {
         if (statusCode==CYSuccess) {
             NSDictionary *dic=[ZIKFunction dictionaryWithJsonString:responseStr];
             weakSelf.topic_id=dic[@"topic_id"];
             APPDELEGATE.userModel.chanyanUser_id=[dic[@"user_id"] integerValue];

         }else{
             [ToastView showTopToast:responseStr];
         }
         
     }];

    if(![APPDELEGATE isNeedLogin])
    {
        return;
    }
    [self cheackCollect];
    [self getNewsDetial];
}
-(void)getNewsDetial
{
    AFHTTPSessionManager *_sharedClient = [[HttpClient alloc] initWithBaseURL:[NSURL URLWithString:NEWSBaseURLString]];
    _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [_sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _sharedClient.requestSerializer.timeoutInterval = 30.f;
    [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSString *postURL            =[NSString stringWithFormat:@"Home/ShareAritle"];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    
    parmers[@"adid"]        = self.urlString;
    [_sharedClient POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *result=[responseObject objectForKey:@"result"];
            self.newstitle =result[@"articleCategoryName"];
            self.newstext =result[@"articleTitle"];
            NSString *pic=result[@"articlePic"];
            if (pic.length > 0) {
                NSArray *picAry=[pic componentsSeparatedByString:@","];
                self.newsimageUrl=[NSString stringWithFormat:@"%@",[picAry firstObject]];
              NSString  *string=[self.newsimageUrl stringByReplacingOccurrencesOfString:@"?x-oss-process=style/news_list" withString:@"?x-oss-process=image/resize,w_100,h_100,limit_0"];
                self.newsimageUrl =string;
            }
            self.yldscommetnV.commentNum=[result[@"articleViewCount"] integerValue];
        }
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
-(void)cheackCollect
{
    [HTTPCLIENT newsCollectcheckArticle_uid:self.urlString Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSInteger iscollect=[[[responseObject objectForKey:@"result"] objectForKey:@"iscollect"] integerValue];
            if (iscollect==0) {
                self.yldscommetnV.collectBtn.selected=NO;
            }else{
                self.yldscommetnV.collectBtn.selected=YES;
            }
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];

}
-(void)shareBtnClick
{
    
 
    ShowActionV();
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        if (self.newsimageUrl.length>0) {
            NSData * data    = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.newsimageUrl]];
            _shareImage  = [[UIImage alloc] initWithData:data];

        }else{
    
            _shareImage  = [UIImage imageNamed:@"logV"];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            RemoveActionV();
            [self umengShare];
            
        });
        
    });
   
}
-(void)collectionBtn:(UIButton *)sender
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
    if (sender.selected==YES) {
        ShowActionV();
         [HTTPCLIENT newsUnCollectActionArticle_uid:self.urlString Success:^(id responseObject) {
             if ([[responseObject objectForKey:@"success"] integerValue]) {
                 [ToastView showTopToast:@"取消收藏成功"];
                 sender.selected=NO;
             }
         }failure:^(NSError *error) {
            
         }];
        return;
    }
    if (sender.selected==NO) {
        ShowActionV();
        [HTTPCLIENT newsCollectActionArticle_uid:self.urlString Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                sender.selected=YES;
                [ToastView showTopToast:@"收藏成功"];
            }
        } failure:^(NSError *error) {
              
        }];
        return;
    }
}
-(void)commentBtnAction
{
    CGFloat offset = self.newsWebView.scrollView.contentSize.height - self.newsWebView.scrollView.bounds.size.height;
    if (offset > 0)
    {
        [self.newsWebView.scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
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
        ;
        return;
    }
    [self.view addSubview:self.fabiaoV];
    [self.fabiaoV showAction];
}
-(void)fabiaoActionWithStr:(NSString *)comment
{
    __weak typeof(self) weakSelf=self;
    [ChangyanSDK submitComment:self.topic_id content:comment replyID:nil score:@"5" appType:40 picUrls:nil metadata:@"" completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        [weakSelf selfViewRreload];
        [weakSelf.fabiaoV clearAvtion];
    }];

}
-(void)backbtnAcion:(UIButton *)sender
{
    if ([self.newsWebView canGoBack]) {
        [self.newsWebView goBack];
    }else {
        [self cleanCacheAndCookie];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType

{
    NSString* strXXX = request.URL.resourceSpecifier;
    
    
    NSRange range = [strXXX rangeOfString:@"app_playreward="];
    if( range.location != NSNotFound)
    {
        //就在这里执行操作了！！！
        NSString *uid=[strXXX substringWithRange:NSMakeRange(range.location+range.length, strXXX.length-range.location-range.length)];
        if (uid.length<=0) {
            return NO;
        }
        if(![APPDELEGATE isNeedLogin])
        {
            YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
            [ToastView showTopToast:@"请先登录"];
            UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
            
            [self presentViewController:navVC animated:YES completion:^{
                
            }];
            
            return NO;
        }
        YLDDaShangViewController *dashangVC=[[YLDDaShangViewController alloc]init];
        dashangVC.infoType=5;
        dashangVC.uid=uid;
        [self.navigationController pushViewController:dashangVC animated:YES];
        return NO;//返回NO，表示取消对本次请求的导航
        
    }
    NSRange newsrange = [strXXX rangeOfString:@"app_reviewarticl="];
    if( newsrange.location != NSNotFound)
    {
        NSString *uid=[strXXX substringWithRange:NSMakeRange(newsrange.location+newsrange.length, strXXX.length-newsrange.location-newsrange.length)];
        if (uid.length<=0) {
            return NO;
        }
        self.urlString=uid;
        
        [self selfViewRreload];
        return NO;
    }
    NSRange newsrsange = [strXXX rangeOfString:@"artid="];
    if( newsrsange.location != NSNotFound)
    {
        CGRect r=self.newsWebView.frame;
        r.size.height=kHeight-64-50;
        self.newsWebView.frame=r;
        self.yldscommetnV.hidden=NO;
    }else{
        CGRect r=self.newsWebView.frame;
        r.size.height=kHeight-64;
        self.newsWebView.frame=r;
        self.yldscommetnV.hidden=YES;
    }
    NSRange authorsange = [strXXX rangeOfString:@"app_authorpage="];
    if( authorsange.location != NSNotFound)
    {
        NSString *uid=[strXXX substringWithRange:NSMakeRange(authorsange.location+authorsange.length, strXXX.length-authorsange.location-authorsange.length)];
        if (uid.length<=0) {
            return NO;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            YLDAuthorDetialViewController *vcc=[[YLDAuthorDetialViewController alloc]init];
            vcc.authorUid= uid;
            [self.navigationController pushViewController:vcc animated:YES];
        });
        return NO;

    }
    NSRange replysange = [strXXX rangeOfString:@"replysender="];
    if( replysange.location != NSNotFound)
    {
        NSString *uid=[strXXX substringWithRange:NSMakeRange(replysange.location+replysange.length, strXXX.length-replysange.location-replysange.length)];
        if (uid.length<=0) {
            return NO;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            YLDCommentRepliesViewController *vvbb=[[YLDCommentRepliesViewController alloc]init];
            vvbb.topic_id=self.topic_id;
            vvbb.comment_id=uid;
            
            vvbb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            vvbb.providesPresentationContextTransitionStyle = YES;
            
            vvbb.definesPresentationContext = YES;
            
            vvbb.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:vvbb animated:YES completion:^{
                [vvbb.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
                
            }];
        });
        return NO;
        
    }

    return YES;
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    ShowActionV();
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
     RemoveActionV();
    if (webView.canGoBack==NO) {
        self.yldscommetnV.hidden=NO;
        self.urlString=self.oldStr;
        [self getNewsDetial];
        if ([APPDELEGATE isNeedLogin]) {
           [self cheackCollect];
            
        }
       
        
    }
   
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error {
    [ToastView showTopToast:@"加载失败"];
    RemoveActionV();
    
}
#pragma mark - 友盟分享
- (void)umengShare {
  
    NSString *urlString = [NSString stringWithFormat:@"%@home/ShareIndex?artid=%@&type=0",NEWSBaseURLString,self.urlString];
    [UMSocialSnsService presentSnsIconSheetView:self
     //appKey:@"569c3c37e0f55a8e3b001658"
                                         appKey:@"56fde8aae0f55a1cd300047c"
                                      shareText:self.newstext
                                     shareImage:_shareImage
                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToQzone,UMShareToWechatSession,UMShareToQQ]
                                       delegate:self];
    
    //当分享消息类型为图文时，点击分享内容会跳转到预设的链接，设置方法如下
    //NSString *urlString = @"https://itunes.apple.com/cn/app/miao-xin-tong/id1104131374?mt=8";
    //NSString *urlString = [NSString stringWithFormat:@"http://www.miaoxintong.cn:8081/qlmm/invitation/create?muid=%@",APPDELEGATE.userModel.access_id];

    [UMSocialData defaultData].extConfig.wechatSessionData.url = urlString;
    
    //如果是朋友圈，则替换平台参数名即可
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlString;
    
    [UMSocialData defaultData].extConfig.qqData.url    = urlString;
    [UMSocialData defaultData].extConfig.qzoneData.url = urlString;
    //设置微信好友title方法为
    //NSString *titleString = @"苗信通-苗木买卖神器";
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.newstitle;
    
    //设置微信朋友圈title方法替换平台参数名即可
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.newstitle;
    
    //QQ设置title方法为
    
    [UMSocialData defaultData].extConfig.qqData.title = self.newstitle;
    
    //Qzone设置title方法将平台参数名替换即可
    
    [UMSocialData defaultData].extConfig.qzoneData.title = self.newstitle;
    
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    //NSLog(@"didClose is %d",fromViewControllerType);
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        
    }
    else {
        CLog(@"%@",response);
    }
}

-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response
{
    NSLog(@"finish share with response is %@",response);
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
