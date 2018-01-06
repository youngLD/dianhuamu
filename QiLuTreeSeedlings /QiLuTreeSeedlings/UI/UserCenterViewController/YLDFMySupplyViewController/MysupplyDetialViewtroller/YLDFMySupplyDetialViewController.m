//
//  YLDFMySupplyDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/3.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFMySupplyDetialViewController.h"
//友盟分享
#import "UMSocialControllerService.h"
#import "UMSocial.h"
#import "YLDFSupplyFabuViewController.h"
//end 友盟分享
@interface YLDFMySupplyDetialViewController ()<UMSocialUIDelegate,supplyFabuDelegate>

@property (nonatomic,copy) NSString *shareTitle;
@property (nonatomic,copy) NSString *shareUrl;
@end

@implementation YLDFMySupplyDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"供应详情";
    if ([_model.status isEqualToString:@"close"]) {
        [self.openOrCloseBtn setBackgroundColor:NavColor];
        self.openOrCloseBtn.selected=NO;
        self.back2Btn.hidden=YES;
    }else{
        [self.openOrCloseBtn setBackgroundColor:kChengColor];
        self.openOrCloseBtn.selected=YES;
        self.back2Btn.hidden=NO;
    }
    self.centerW.constant=kWidth/3;
    self.shareUrl=[NSString stringWithFormat:@"%@%@",_baseUrl,_model.htmlUrl];
    __weak typeof(self)weakself =self;
    self.rightBarBtnTitleString=@"刷新";
    self.rightBarBtnBlock = ^{
        [weakself refreashAction];
    };
    // Do any additional setup after loading the view from its nib.
}
-(void)refreashAction
{
    if ([_model.status isEqualToString:@"close"]) {
        return;
    }
    [HTTPCLIENT mySupplyRefreshWithSupplyIds:_model.supplyId Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"刷新成功"];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)shareBtnAction:(UIButton *)sender {
    [self umengShare];
}
- (IBAction)openOrCloseBtnAction:(UIButton *)sender {
    __weak typeof(self)weakself =self;
    //在这里呼出下方菜单按钮项
    if ([_model.status isEqualToString:@"open"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"下架供应" message:@"您确定要下架该供应，下架后可在已下架的供应中重新上架。" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ShowActionV();
            
            
            [HTTPCLIENT mySupplyCloseWithSupplyIds:_model.supplyId Success:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    [ToastView showTopToast:@"下架成功"];
                    weakself.model.status=@"close";
                    [weakself.openOrCloseBtn setBackgroundColor:NavColor];
                    weakself.openOrCloseBtn.selected=NO;
                    self.back2Btn.hidden=YES;
                    if (weakself.delegate) {
                        [weakself.delegate mySupplyDetialColseOrOpenWithModel:weakself.model];
                    }
                }else{
                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(NSError *error) {
                
            }];
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if ([_model.status isEqualToString:@"close"])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上架供应" message:@"您确定要上架该供应吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ShowActionV();
            
            [HTTPCLIENT mySupplyOpenWithSupplyIds:_model.supplyId
                                  Success:^(id responseObject) {
                                      if ([[responseObject objectForKey:@"success"] integerValue]) {
                                          [ToastView showTopToast:@"上架成功"];
                                          weakself.model.status=@"open";
                                          [weakself.openOrCloseBtn setBackgroundColor:kChengColor];
                                          weakself.openOrCloseBtn.selected=YES;
                                          self.back2Btn.hidden=NO;
                                          if (weakself.delegate) {
                                              [weakself.delegate mySupplyDetialColseOrOpenWithModel:weakself.model];
                                          }
                                      }else{
                                          [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                                      }
                                  } failure:^(NSError *error) {
                                      
                                  }];
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (IBAction)editBtnAction:(UIButton *)sender {
    YLDFSupplyFabuViewController *vc=[YLDFSupplyFabuViewController new];
    vc.supplyId=_model.supplyId;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)fabuSuccessWithSupplyId:(NSDictionary *)supplydic
{
    
}
- (void)umengShare {
    UIImage *image=[UIImage imageNamed:@"miaomu29"];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"56fde8aae0f55a1cd300047c"
                                      shareText:@"精品苗木供应推荐"
                                     shareImage:image
                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToQzone,UMShareToWechatSession,UMShareToQQ]
                                       delegate:self];
    
    
    NSString *urlString = self.shareUrl;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = urlString;
    
    //如果是朋友圈，则替换平台参数名即可
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlString;
    
    [UMSocialData defaultData].extConfig.qqData.url    = urlString;
    [UMSocialData defaultData].extConfig.qzoneData.url = urlString;
    //设置微信好友title方法为
    //    NSString *titleString = @"苗信通-苗木买卖神器";
    NSString *titleString = [NSString stringWithFormat:@"供应：%@",self.model.productName];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = titleString;
    
    //设置微信朋友圈title方法替换平台参数名即可
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = titleString;
    
    //QQ设置title方法为
    
    [UMSocialData defaultData].extConfig.qqData.title = titleString;
    
    //Qzone设置title方法将平台参数名替换即可
    
    [UMSocialData defaultData].extConfig.qzoneData.title = titleString;
    
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
        //得到分享到的微博平台名
        //NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
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
