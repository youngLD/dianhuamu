//
//  YLDGongChengGongSiViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/1.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGongChengGongSiViewController.h"
#import "UIDefines.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "YLDZhanZhangGongYingViewController.h"
#import "WoDeDingDanViewController.h"
#import "GongChengZhongXinViewController.h"
#import "YLDBaoJiaGuanLiViewController.h"
#import "UINavController.h"
#import "LYDGCGSTiShiViewController.h"
#import "HttpClient.h"
#import "YLDGCGSZiZhiTiJiaoViewController.h"
#define kTABBARH 50

@interface YLDGongChengGongSiViewController ()
@property (nonatomic,strong)UIView *BTabBar;
@property BOOL TabBarHiden;
@property (nonatomic,strong)NSMutableArray *labAry;
@property (nonatomic,strong)UIButton *nowBtn;
@end

@implementation YLDGongChengGongSiViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.labAry=[NSMutableArray array];
            [HTTPCLIENT projectCompanyStatusSuccess:^(id responseObject) {
                if([[responseObject objectForKey:@"success"] integerValue])
                {
                 APPDELEGATE.userModel.projectCompanyStatus=[[[responseObject objectForKey:@"result"] objectForKey:@"projectCompanyStatus"] integerValue];
    
                }
                else
                {
                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                }
                RemoveActionV();
            } failure:^(NSError *error) {
                RemoveActionV();
            }];

    self.TabBarHiden=NO;
    [self MakeUI];
    
    YLDZhanZhangGongYingViewController *zzgyVC=[[YLDZhanZhangGongYingViewController alloc]init];
    UINavController *ZZNav=[[UINavController alloc]initWithRootViewController:zzgyVC];
     ZZNav.navigationBar.hidden=YES;
    WoDeDingDanViewController *wdDDVC=[[WoDeDingDanViewController alloc]init];
    UINavController *WDDDNav=[[UINavController alloc]initWithRootViewController:wdDDVC];
    WDDDNav.navigationBar.hidden=YES;
    YLDBaoJiaGuanLiViewController *baojiaGuanLiVC=[[YLDBaoJiaGuanLiViewController alloc]init];
     UINavController *bjGLNav=[[UINavController alloc]initWithRootViewController:baojiaGuanLiVC];
    bjGLNav.navigationBar.hidden=YES;
    GongChengZhongXinViewController *gcZXViewController=[[GongChengZhongXinViewController alloc]init];
    UINavController *gczxLNav=[[UINavController alloc]initWithRootViewController:gcZXViewController];
    gczxLNav.navigationBar.hidden=YES;
    self.viewControllers=@[ZZNav,WDDDNav,bjGLNav,gczxLNav];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fanhuimiaoxintong) name:@"YLDBackMiaoXinTong" object:nil];
    //添加隐藏和显示自定义标签栏的通知
    //添加隐藏和显示自定义标签栏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenTabBar) name:@"YLDGongchengHidenTabBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabBar) name:@"YLDGongchengshowTabBar" object:nil];
    // Do any additional setup after loading the view.
}
-(void)hidenTabBar
{
    self.BTabBar.hidden=YES;
    self.tabBar.hidden=YES;
}
-(void)showTabBar
{
    self.BTabBar.hidden=NO;
    self.tabBar.hidden=YES;
}
-(void)fanhuimiaoxintong
{
    [self.navigationController popViewControllerAnimated:YES];
}
//构建标签栏
- (void)MakeUI {
    //CGFloat [Height =[UIScreen mainScreen].bounds.size.height;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.BTabBar=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-kTABBARH, kWidth, kTABBARH)];
    [self.view addSubview:self.BTabBar];
    [self.BTabBar setBackgroundColor:[UIColor whiteColor]];
    self.tabBar.hidden=YES;
    UIImageView *tabMageV1=[[UIImageView alloc]initWithFrame:CGRectMake(0, -7, kWidth, 50)];
    [self.BTabBar addSubview:tabMageV1];
    [tabMageV1 setImage:[UIImage imageNamed:@"tabbarBackImage1"]];
    UIImageView *tabMageV2=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-55, -7, 110, 50)];
    [tabMageV2 setImage:[UIImage imageNamed:@"tabbarBackImage2"]];
    [self.BTabBar addSubview:tabMageV2];
    
    //
    UIButton *PageViewBtn=[[UIButton alloc]initWithFrame:CGRectMake((kWidth-34*5)/6, 3, 28, 28)];
    PageViewBtn.tag=1;
    self.nowBtn=PageViewBtn;
    [PageViewBtn setEnlargeEdgeWithTop:10 right:5 bottom:20 left:10];
    
    [PageViewBtn addTarget:self action:@selector(ButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [PageViewBtn setBackgroundImage:[UIImage imageNamed:@"zhanzhanggongyingoff"] forState:UIControlStateNormal];
    [PageViewBtn setBackgroundImage:[UIImage imageNamed:@"zhanzhanggongyingOn"] forState:UIControlStateSelected];
    PageViewBtn.selected=YES;
    [self.BTabBar addSubview:PageViewBtn];
    UILabel *hompageLab=[[UILabel alloc]initWithFrame:CGRectMake((kWidth-34*5)/6-10, 30, 50, 25)];
    [hompageLab setFont:[UIFont systemFontOfSize:14]];
    [hompageLab setTextAlignment:NSTextAlignmentCenter];
    [hompageLab setTextColor:yellowButtonColor];
    [hompageLab setText:@"站长供应"];
    [self.labAry addObject:hompageLab];
    //self.homePageLab=hompageLab;
    [self.BTabBar addSubview:hompageLab];
    //[self.BTabBar addSubview:pageActionBtn];
    
    UIButton *wodedingdanBtn=[[UIButton alloc]initWithFrame:CGRectMake((kWidth-34*5)/6*2+34, 3, 28, 28)];
    wodedingdanBtn.tag=2;
    [wodedingdanBtn setBackgroundImage:[UIImage imageNamed:@"wodedingdanoff"] forState:UIControlStateNormal];
    [wodedingdanBtn setBackgroundImage:[UIImage imageNamed:@"wodedingdanon"] forState:UIControlStateSelected];
[wodedingdanBtn setEnlargeEdgeWithTop:10 right:5 bottom:20 left:10];
    [self.BTabBar addSubview:wodedingdanBtn];
//    UIButton *wodedingdanBtnActionBtn=[[UIButton alloc]initWithFrame:CGRectMake((kWidth-34*5)/6*2+34, 0, 30, 50)];
//    wodedingdanBtnActionBtn.tag=2;
    
    [wodedingdanBtn addTarget:self action:@selector(ButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
        //[self.BTabBar addSubview:wodedingdanBtnActionBtn];
    
    UILabel *wodedingdanLab=[[UILabel alloc]initWithFrame:CGRectMake((kWidth-34*5)/6*2+34-10, 30, 50, 25)];
    [wodedingdanLab setFont:[UIFont systemFontOfSize:14]];
    [wodedingdanLab setTextAlignment:NSTextAlignmentCenter];
    [wodedingdanLab setTextColor:detialLabColor];
    [wodedingdanLab setText:@"我的订单"];
    [self.labAry addObject:wodedingdanLab];
    //self.homePageLab=hompageLab;
    [self.BTabBar addSubview:wodedingdanLab];

    
    
    UIButton *baojiaguanliBtn=[[UIButton alloc]initWithFrame:CGRectMake((kWidth-34*5)/6*4+34*3, 3, 28, 28)];
    baojiaguanliBtn.tag=3;
    [baojiaguanliBtn setEnlargeEdgeWithTop:10 right:5 bottom:20 left:10];
    [baojiaguanliBtn setBackgroundImage:[UIImage imageNamed:@"baojiaguanliOff"] forState:UIControlStateNormal];
    [baojiaguanliBtn setBackgroundImage:[UIImage imageNamed:@"baojiaguanliOn"] forState:UIControlStateSelected];
 
    [self.BTabBar addSubview:baojiaguanliBtn];
//    UIButton *baojiaguanliActionBtn=[[UIButton alloc]initWithFrame:CGRectMake((kWidth-34*5)/6*4+34*3, 0, 30, 50)];
//    baojiaguanliActionBtn.tag=3;
    
    [baojiaguanliBtn addTarget:self action:@selector(ButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
//    [self.BTabBar addSubview:baojiaguanliActionBtn];
    
    UILabel *baojiaguanliLab=[[UILabel alloc]initWithFrame:CGRectMake((kWidth-34*5)/6*4+34*3-10, 30, 50, 25)];
    [baojiaguanliLab setFont:[UIFont systemFontOfSize:14]];
    [baojiaguanliLab setTextAlignment:NSTextAlignmentCenter];
    [baojiaguanliLab setTextColor:detialLabColor];
    [baojiaguanliLab setText:@"报价管理"];
    //self.homePageLab=hompageLab;
    [self.BTabBar addSubview:baojiaguanliLab];
    [self.labAry addObject:baojiaguanliLab];
    
    UIButton *gongchengzhongxinBtn=[[UIButton alloc]initWithFrame:CGRectMake((kWidth-34*5)/6*5+34*4, 3, 28, 28)];
    gongchengzhongxinBtn.tag=4;
    [gongchengzhongxinBtn setEnlargeEdgeWithTop:10 right:5 bottom:20 left:10];
    [gongchengzhongxinBtn setBackgroundImage:[UIImage imageNamed:@"gongchengzhongxinoff"] forState:UIControlStateNormal];
    [gongchengzhongxinBtn setBackgroundImage:[UIImage imageNamed:@"gongchengzhongxinOn"] forState:UIControlStateSelected];
    
    [self.BTabBar addSubview:gongchengzhongxinBtn];

    
    [gongchengzhongxinBtn addTarget:self action:@selector(ButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *gongchengzhongxinLab=[[UILabel alloc]initWithFrame:CGRectMake((kWidth-34*5)/6*5+34*4-10, 30, 50, 25)];
    [gongchengzhongxinLab setFont:[UIFont systemFontOfSize:14]];
    [gongchengzhongxinLab setTextAlignment:NSTextAlignmentCenter];
    [gongchengzhongxinLab setTextColor:detialLabColor];
    [gongchengzhongxinLab setText:@"工程中心"];
    [self.BTabBar addSubview:gongchengzhongxinLab];
    [self.labAry addObject:gongchengzhongxinLab];
    UIButton *fabuBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-25, -5, 50, 50)];
    [fabuBtn setImage:[UIImage imageNamed:@"huangsefabu"] forState:UIControlStateNormal];
    [fabuBtn addTarget:self action:@selector(FaBuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.BTabBar addSubview:fabuBtn];
    
}
-(void)FaBuButtonAction:(UIButton *)sender
{
    
    if (APPDELEGATE.userModel.goldsupplierStatus==7||[APPDELEGATE.userModel.access_id isEqualToString:@"0F14ED77-78E2-4441-9F1A-8FE080C9A6C1"]) {
      [[NSNotificationCenter defaultCenter] postNotificationName:@"YLDGONGChengFabuAction" object:nil];
     
    }else{
        if (APPDELEGATE.userModel.projectCompanyStatus==-1) {
            [ToastView showTopToast:@"暂未审核，请耐心等待"];
            return;
        }
        
        if (APPDELEGATE.userModel.projectCompanyStatus==0) {
            [ToastView showTopToast:@"审核未通过"];
            YLDGCGSZiZhiTiJiaoViewController *yldsda=[[YLDGCGSZiZhiTiJiaoViewController alloc]initWithUid:@"xxxxxx"];
            
            [self.navigationController pushViewController:yldsda animated:YES];
            return;
        }
        LYDGCGSTiShiViewController *view=[[ LYDGCGSTiShiViewController  alloc]init];
        [self.navigationController pushViewController:view animated:YES];
        
    }
}
//标签栏的用户和首页的按钮点击
-(void)ButtonSelect:(UIButton *)sender
{
    if (sender==self.nowBtn) {
        return;
    }
    if (APPDELEGATE.userModel.goldsupplierStatus==7||[APPDELEGATE.userModel.access_id isEqualToString:@"0F14ED77-78E2-4441-9F1A-8FE080C9A6C1"]) {
        
        self.selectedIndex=sender.tag-1;
        self.nowBtn.selected=NO;
        sender.selected=YES;
        for (int i=0; i<self.labAry.count; i++) {
            if (i==sender.tag-1) {
                UILabel *lab=self.labAry[i];
                [lab setTextColor:yellowButtonColor];
            }else{
                UILabel *lab=self.labAry[i];
                [lab setTextColor:detialLabColor];
                
            }
        }
        self.nowBtn=sender;
    }else{
        if (APPDELEGATE.userModel.projectCompanyStatus==-1) {
            [ToastView showTopToast:@"暂未审核，请耐心等待"];
            return;
        }
        
        if (APPDELEGATE.userModel.projectCompanyStatus==0) {
            [ToastView showTopToast:@"审核未通过"];
            YLDGCGSZiZhiTiJiaoViewController *yldsda=[[YLDGCGSZiZhiTiJiaoViewController alloc]initWithUid:@"xxxxxx"];
            
            [self.navigationController pushViewController:yldsda animated:YES];
            return;
        }
        LYDGCGSTiShiViewController *view=[[ LYDGCGSTiShiViewController  alloc]init];
        [self.navigationController pushViewController:view animated:YES];
//        [HTTPCLIENT projectCompanyStatusSuccess:^(id responseObject) {
//            if([[responseObject objectForKey:@"success"] integerValue])
//            {
//                APPDELEGATE.userModel.projectCompanyStatus=[[[responseObject objectForKey:@"result"] objectForKey:@"projectCompanyStatus"] integerValue];
//                if (APPDELEGATE.userModel.projectCompanyStatus==-1) {
//                    [ToastView showTopToast:@"暂未审核，请耐心等待"];
//                    return;
//                }
//                
//                if (APPDELEGATE.userModel.projectCompanyStatus==0) {
//                    [ToastView showTopToast:@"审核未通过"];
//                    YLDGCGSZiZhiTiJiaoViewController *yldsda=[[YLDGCGSZiZhiTiJiaoViewController alloc]initWithUid:@"xxxxxx"];
//                    
//                    [self hiddingSelfTabBar];
//                    [self.navigationController pushViewController:yldsda animated:YES];
//                    return;
//                }
//                
//                [self hiddingSelfTabBar];

//            }
//            else
//            {
//                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
//            }
//            RemoveActionV();
//        } failure:^(NSError *error) {
//            RemoveActionV();
//        }];
        
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
