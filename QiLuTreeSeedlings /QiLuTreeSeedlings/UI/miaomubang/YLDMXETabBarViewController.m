//
//  YLDMXETabBarViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/10/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDMXETabBarViewController.h"
#import "YLDMMBSupplyViewController.h"
#import "YLDMMBBugViewController.h"
#import "YLDMMBzhongxinViewController.h"
#import "ZIKOrderViewController.h"
#import "ZIKMyOfferViewController.h"
#import "ZIKHelpfulHintsViewController.h"
#import "YLDJPZhongXinViewController.h"
#import "UINavController.h"
#import "YLDShengjiMMBViewController.h"
@interface YLDMXETabBarViewController ()<UITabBarControllerDelegate>
{
    BOOL _isTiao;
}
@property(readonly, nonatomic) NSUInteger lastSelectedIndex;
@end

@implementation YLDMXETabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHome) name:@"ZIKBackHome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHome) name:@"YLDBackMiaoXinTong" object:nil];
    self.delegate=self;
    //金牌供应商
    YLDMMBSupplyViewController *JPGYSListVC = [[YLDMMBSupplyViewController alloc] init];
    UINavigationController *JPGYSListNav = [[UINavigationController alloc] initWithRootViewController:JPGYSListVC];
    //JPGYSListNav.viewControllers = @[JPGYSListVC];
    //    JPGYSListNav.tabBarItem.enabled = YES;
    JPGYSListVC.vcTitle = @"苗帮供应";
    JPGYSListVC.tabBarItem.title = @"苗帮供应";
    JPGYSListVC.navigationController.navigationBar.hidden = YES;
    JPGYSListVC.tabBarItem.image = [[UIImage imageNamed:@"苗小二_底部菜单_供应off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    JPGYSListVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"苗小二_底部菜单_供应on"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //金牌供应
    YLDMMBBugViewController *jinpaigongyingVC=[[YLDMMBBugViewController alloc]init];
    
    UINavigationController *JPGYListNav = [[UINavigationController alloc] initWithRootViewController:jinpaigongyingVC];
    
    JPGYListNav.tabBarItem.enabled = YES;
    jinpaigongyingVC.vcTitle = @"苗帮求购";
    jinpaigongyingVC.tabBarItem.title = @"苗帮求购";
    jinpaigongyingVC.navigationController.navigationBar.hidden = YES;
    jinpaigongyingVC.tabBarItem.image = [[UIImage imageNamed:@"苗小二_底部菜单_求购off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    jinpaigongyingVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"苗小二_底部菜单_求购on"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //金牌订单
    ZIKOrderViewController *orderVC = [[ZIKOrderViewController alloc] init];
    UINavigationController *orderNav = [[UINavigationController alloc] initWithRootViewController:orderVC];
    orderVC.navigationController.navigationBar.hidden=YES;
    
    orderVC.title=@"苗帮订单";
 
    orderVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-我的订单off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    orderVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单-我的订单on"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //我的报价
    ZIKMyOfferViewController *offerVC = [[ZIKMyOfferViewController alloc] init];
    UINavigationController *offerNav = [[UINavigationController alloc] initWithRootViewController:offerVC];
    offerNav.viewControllers = @[offerVC];
    offerNav.tabBarItem.enabled = YES;
    offerVC.vcTitle = @"我的报价";
    offerVC.title = @"我的报价";
    
    offerVC.navigationController.navigationBar.hidden = YES;
    offerVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-报价管理Off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    offerVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单-报价管理On"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [offerVC.navView setBackgroundColor:NavYellowColor];
    //金牌中心
    YLDJPZhongXinViewController *jpzhongxinVC=[[YLDJPZhongXinViewController alloc]init];
    UINavController *jpzhongxinNav = [[UINavController alloc] initWithRootViewController:jpzhongxinVC];
    jpzhongxinVC.navigationController.navigationBar.hidden=YES;
    jpzhongxinVC.type=1;
    jpzhongxinVC.title=@"苗木帮中心";
    jpzhongxinVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-工程中心off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    jpzhongxinVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单-工程中心On"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    self.viewControllers = @[JPGYSListNav,JPGYListNav,offerNav,orderNav,jpzhongxinNav];
    UIColor *normalColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       normalColor,           NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:14.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = NavYellowColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:14.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateSelected];

    // Do any additional setup after loading the view.
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return _isTiao;
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    _isTiao = YES;
    //获得选中的item
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    if (tabIndex != self.selectedIndex) {
        //设置最近一次变更
        _lastSelectedIndex = self.selectedIndex;
        //        CLog(@"2 OLD:%lu , NEW:%lu",(unsigned long)self.lastSelectedIndex,(unsigned long)tabIndex);
    }
    if (tabIndex == 2||tabIndex == 3 ||tabIndex == 4) {
        if (APPDELEGATE.userModel.goldsupplierStatus ==9) {
            _isTiao = YES;//是苗企，可以进入苗企中心
        }else if(APPDELEGATE.userModel.goldsupplierStatus==0)
        {
            _isTiao = NO;//不是苗企，不可进入苗企中心
            
            YLDShengjiMMBViewController *helpfulVC = [[YLDShengjiMMBViewController alloc] init];
//            helpfulVC.qubie = @"苗小二";
//            helpfulVC.navcc = NavYellowColor;
            [self.navigationController pushViewController:helpfulVC animated:YES];

        }
        else {
            _isTiao = NO;//不是苗企，不可进入苗企中心
            
            ZIKHelpfulHintsViewController *helpfulVC = [[ZIKHelpfulHintsViewController alloc] initWithNibName:@"ZIKHelpfulHintsViewController" bundle:nil];
            helpfulVC.qubie = @"苗木帮";
            helpfulVC.navcc = NavYellowColor;
            [self.navigationController pushViewController:helpfulVC animated:YES];
            
        }
    }
}
- (void)backHome {

    UIColor *titleHighlightedColor = NavColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:14.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateSelected];
    [self.navigationController popViewControllerAnimated:YES];
}
//-(BOOL)
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZIKBackHome" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YLDBackMiaoXinTong" object:nil];
    
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
