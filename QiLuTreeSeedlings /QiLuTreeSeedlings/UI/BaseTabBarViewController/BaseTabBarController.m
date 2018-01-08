//
//  BaseTabBarController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "BaseTabBarController.h"
#import "UINavController.h"
//#import "HomePageTViewController.h"
#import "YLDFUserCenterViewController.h"
#import "UIDefines.h"
#import "YLDLoginViewController.h"
#import "YLDSHomePageViewController.h"
#import "YLDFMessageViewController.h"
#import "YLDTabBar.h"
#import "SDTimeLineTableViewController.h"
#define kTABBARH 50
@interface BaseTabBarController ()<YLDTabBarViewDelegate>
@property UIView *BTabBar;
@property BOOL TabBarHiden;

@end

@implementation BaseTabBarController


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //tabBar是UITabBarController的只读成员变量（属性），是不让修改的
    //kvc 替换系统的tabbar
//      YLDTabBar *tabBar = [[YLDTabBar alloc] init];
//      [self setValue:tabBar forKeyPath:@"tabBar"];
//
//
//    //已经替换的UItabbar 设置代理为当前控制器
//    [self.tabBar setValue:self forKey:@"tabbarDelegate"];
//    [YLDTabBar appearance].translucent = NO;
    
    
    UITabBar *tabBar = [UITabBar appearance];
    [tabBar setBarTintColor:[UIColor whiteColor]];
    tabBar.translucent = NO;
    

    //    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    //    // 给自定义 View 设置颜色
    //    bgView.backgroundColor = [UIColor redColor];
    //    // 将自定义 View 添加到 tabBar 上
    //    [self.tabBar insertSubview:bgView atIndex:0];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showReadPoint) name:@"showReadPoint" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenReadPoint) name:@"hiddenReadPoint" object:nil];
//    [self.tabBarController.tabBar setBackgroundColor:[UIColor whiteColor]];
    //首页
    YLDSHomePageViewController *orderVC = [[YLDSHomePageViewController alloc] init];
    UINavigationController *orderNav = [[UINavigationController alloc] initWithRootViewController:orderVC];
    orderNav.viewControllers = @[orderVC];
//    orderNav.tabBarItem.enabled = YES;
//    orderVC.vcTitle = @"合作苗企";
    orderVC.tabBarItem.title = @"首页";
    orderVC.navigationController.navigationBar.hidden = YES;
    orderVC.tabBarItem.image = [[UIImage imageNamed:@"shouyeoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    orderNav.interactivePopGestureRecognizer.enabled = NO;
    orderVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"shouyeon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //发布
    SDTimeLineTableViewController *MQvc=[[SDTimeLineTableViewController alloc]init];
    MQvc.navigationController.navigationBar.hidden=NO;
    
    UINavigationController *fbNav = [[UINavigationController alloc] initWithRootViewController:MQvc];
    fbNav.interactivePopGestureRecognizer.enabled = NO;
    MQvc.title=@"微苗商";
//    MQvc.hidesBottomBarWhenPushed=YES;
    MQvc.tabBarItem.title = @"微苗商";
//    fbVC.navigationController.navigationBar.hidden = YES;
    MQvc.tabBarItem.image = [[UIImage imageNamed:@"quanoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MQvc.tabBarItem.selectedImage =[[UIImage imageNamed:@"quanon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
  
    //消息中心
    YLDFMessageViewController *messageVC = [[YLDFMessageViewController alloc] init];
    UINavController *messageNav = [[UINavController alloc] initWithRootViewController:messageVC];
    messageNav.interactivePopGestureRecognizer.enabled = NO;
    messageVC.tabBarItem.title = @"消息";
    messageVC.navigationController.navigationBar.hidden = YES;
    messageVC.tabBarItem.image = [[UIImage imageNamed:@"xiaoxioff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"xiaoxion"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //个人中心
    YLDFUserCenterViewController *userVC = [[YLDFUserCenterViewController alloc] init];
    UINavigationController *userNav = [[UINavigationController alloc] initWithRootViewController:userVC];
    userNav.interactivePopGestureRecognizer.enabled = NO;
    userVC.tabBarItem.title = @"我的";
    userVC.navigationController.navigationBar.hidden = YES;
    userVC.tabBarItem.image = [[UIImage imageNamed:@"useroff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    userVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"useron"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:orderNav,fbNav,messageNav,userNav,nil];
    self.viewControllers = list;
//    self.delegate = self;
    UIColor *normalColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       normalColor,           NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:14.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = NgreenColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:14.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateSelected];
    [self showBadgeOnItemIndex:2];
}


- (void)showBadgeOnItemIndex:(int)index{
    
    //新建小红点
    UILabel *badgeView = [[UILabel alloc]init];
    badgeView.tag = 888;
    
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.tabBar.frame;
    [badgeView setTextColor:[UIColor whiteColor]];
    [badgeView setFont:[UIFont systemFontOfSize:11]];
    [badgeView setTextAlignment:NSTextAlignmentCenter];
    //确定小红点的位置
//    float percentX = (index +0.6) / (self.viewControllers.count+1);
   
//        UIView *view = self.tabBar.subviews[index];
   
    CGFloat x = kWidth*0.7+6;
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 16, 16);
    [self.tabBar addSubview:badgeView];
    badgeView.layer.masksToBounds=YES;
    badgeView.layer.cornerRadius = 8;
    badgeView.hidden=YES;
}
-(void)showReadPoint
{
    UILabel *view=[self.tabBar viewWithTag:888];
    view.hidden=NO;
    NSInteger miaoshangquanNum=[APPDELEGATE setupUnreadMessageCount];
    
    [HTTPCLIENT getunReadSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic =[responseObject objectForKey:@"result"];
           
        NSInteger unread=[dic[@"SystemMessageCount"] integerValue]+[dic[@"CustomCount"] integerValue];
            NSInteger sumNum=miaoshangquanNum + unread;
            if (sumNum>=99) {
                view.text=@"99";
            }else if (sumNum>0){
                view.text=[NSString stringWithFormat:@"%ld",sumNum];
            }else if (sumNum>0){
                view.hidden=YES;
            }
            [UIApplication sharedApplication].applicationIconBadgeNumber=sumNum;
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)hiddenReadPoint
{
    UILabel *view=[self.tabBar viewWithTag:888];
    view.hidden=YES;
}
//代理方法 ，自定义按钮点击
-(void)mainTabBarViewDidClick:(YLDTabBar *)hBTabBarView{
    
  
    UINavigationController* nav = [self.viewControllers objectAtIndex:self.selectedIndex];
    
    UIViewController *rootview = [nav.viewControllers objectAtIndex:0];
    
    SDTimeLineTableViewController *vc=[[SDTimeLineTableViewController alloc]init];
    vc.navigationController.navigationBar.hidden=NO;
    vc.hidesBottomBarWhenPushed=YES;
    
    
    [rootview.navigationController pushViewController:vc animated:YES];

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
