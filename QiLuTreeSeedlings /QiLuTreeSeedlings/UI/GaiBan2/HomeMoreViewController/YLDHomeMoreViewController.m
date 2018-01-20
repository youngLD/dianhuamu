//
//  YLDHomeMoreViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/8/17.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDHomeMoreViewController.h"
#import "YLDHomeMoreView.h"
#import "YLDShengJiViewViewController.h"
#import "YLDJPGYSBaseTabBarController.h"
#import "ZIKStationTabBarViewController.h"
#import "YLDGongChengGongSiViewController.h"
//#import "ZIKMiaoQiTabBarViewController.h"
#import "YLDMXETabBarViewController.h"
#import "YLDJJRMyViewController.h"
#import "YLDLoginViewController.h"
#import "UINavController.h"
#import "SDTimeLineTableViewController.h"
#import "YLDZiCaiShangChengViewController.h"
#import "YLDZaoXingMMViewController.h"
#import "YLDPenJingMiMuViewController.h"
#import "YLDSMiaoShangNewsViewController.h"
@interface YLDHomeMoreViewController ()

@end

@implementation YLDHomeMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"更多";
    NSArray *titleAry=@[@"苗商头条",@"特权功能",@"微苗商",@"资材商城",@"地图找苗",@"造型苗木",@"盆景苗木"];
    NSArray *imageAry=@[@"moreMSTT",@"moreTQGN",@"moreWMS",@"moreZCSC",@"moreDTZM",@"moreZXMM",@"morePJMM"];
    for (int i=0; i<titleAry.count; i++) {
        int xx=i/3;
        int zz=i%3;
        YLDHomeMoreView *view=[[YLDHomeMoreView alloc]initWithFrame:CGRectMake(kWidth/3*zz+0.5, 120*xx+65, kWidth/3, 120)];
        [view setBackgroundColor:[UIColor whiteColor]];
        
        view.btn.tag=i;
        view.titleLab.text=titleAry[i];
        [view.ImagView setImage:[UIImage imageNamed:imageAry[i]]];
        
        
        [view.btn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:view];
        
    }

}
-(void)moreAction:(UIButton *)sender
{
    NSInteger index=sender.tag;
    if (index==0) {
        YLDSMiaoShangNewsViewController *newsVC=[[YLDSMiaoShangNewsViewController alloc]init];
        
        [self.navigationController pushViewController:newsVC animated:YES];
    }
    if (index==1) {
        if([APPDELEGATE isNeedLogin])
        {
            if (APPDELEGATE.userModel.goldsupplierStatus==0) {
                ShowActionV();
                [HTTPCLIENT jjrshenheStatueSuccess:^(id responseObject) {
                    if ([[responseObject objectForKey:@"success"] integerValue]) {
                        NSDictionary  *result=[responseObject objectForKey:@"result"];
                        NSInteger xx=[[result objectForKey:@"status"] integerValue];
                        if (xx==-1) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [ToastView showTopToast:@"特权介绍"];
                                YLDShengJiViewViewController *shengji=[[YLDShengJiViewViewController alloc]init];
                                
                                [self.navigationController pushViewController:shengji animated:YES];
                            });
                        }else{
                            [ToastView showTopToast:@"敬请期待"];
                        }
                       
                    }
                } failure:^(NSError *error) {
                    
                }];
                
                
            }
            if (APPDELEGATE.userModel.goldsupplierStatus==1||APPDELEGATE.userModel.goldsupplierStatus==2||APPDELEGATE.userModel.goldsupplierStatus==3) {
                
                YLDJPGYSBaseTabBarController *gongyingV=[[YLDJPGYSBaseTabBarController alloc]init];

                [self.navigationController pushViewController:gongyingV animated:YES];
            }
            
            if (APPDELEGATE.userModel.goldsupplierStatus == 5 || APPDELEGATE.userModel.goldsupplierStatus  == 6 ) {
                
                ZIKStationTabBarViewController *stationtab = [[ZIKStationTabBarViewController alloc] init];

                [self.navigationController pushViewController:stationtab animated:YES];
                
            }
            if (APPDELEGATE.userModel.goldsupplierStatus==7) {
                
                YLDGongChengGongSiViewController *tab=[[YLDGongChengGongSiViewController alloc]init];

                [self.navigationController pushViewController:tab animated:YES];
                
            }
            
            if (APPDELEGATE.userModel.goldsupplierStatus==8) {
                
//                ZIKMiaoQiTabBarViewController *hezuoTabBarVC = [[ZIKMiaoQiTabBarViewController alloc] init];
//     
//                [self.navigationController pushViewController:hezuoTabBarVC animated:YES];
            }
            if (APPDELEGATE.userModel.goldsupplierStatus==9) {
                
                YLDMXETabBarViewController *gongyingV=[[YLDMXETabBarViewController alloc]init];
              
                [self.navigationController pushViewController:gongyingV animated:YES];
            }
            if (APPDELEGATE.userModel.goldsupplierStatus==11) {
                YLDJJRMyViewController *vc=[YLDJJRMyViewController new];
               
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
            [ToastView showTopToast:@"请先登录"];
            UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
            
            [self presentViewController:navVC animated:YES completion:^{
                
            }];
        }
        
    }
    if (index==2) {

        SDTimeLineTableViewController *vc=[[SDTimeLineTableViewController alloc]init];
        vc.navigationController.navigationBar.hidden=NO;

 
        [self.navigationController pushViewController:vc animated:YES];
        

    }
    if (index==3) {
        YLDZiCaiShangChengViewController *yldZCVC=[[YLDZiCaiShangChengViewController alloc]init];

        [self.navigationController pushViewController:yldZCVC animated:YES];
    }
   
    if (index==4) {
        [ToastView showTopToast:@"暂无数据"];
        return;
    }
    if (index==5) {
        YLDZaoXingMMViewController *yldZxVC=[[YLDZaoXingMMViewController alloc]init];

        [self.navigationController pushViewController:yldZxVC animated:YES];
    }
    if (index==6) {
        YLDPenJingMiMuViewController *yldpjVC=[[YLDPenJingMiMuViewController alloc]init];

        [self.navigationController pushViewController:yldpjVC animated:YES];
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
