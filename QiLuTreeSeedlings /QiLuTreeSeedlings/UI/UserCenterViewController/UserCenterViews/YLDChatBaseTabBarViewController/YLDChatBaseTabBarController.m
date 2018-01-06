//
//  YLDChatBaseTabBarController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/12/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDChatBaseTabBarController.h"
#import "YLDGroupListViewController.h"
#import "ConversationListController.h"
#import "UIDefines.h"
@interface YLDChatBaseTabBarController ()

@end

@implementation YLDChatBaseTabBarController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHome) name:@"YLDChatBack" object:nil];
  
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
//    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    //会话
    ConversationListController *chatListVC = [[ConversationListController alloc] init];
    UINavigationController *orderNav = [[UINavigationController alloc] initWithRootViewController:chatListVC];

    orderNav.tabBarItem.enabled = YES;
    chatListVC.tabBarItem.title = @"会话列表";
    [chatListVC.navigationController.navigationBar setBarTintColor:NavColor];
    [chatListVC.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    chatListVC.tabBarItem.image = [[UIImage imageNamed:@"huihuaoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    chatListVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"huihuaon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //群组
    YLDGroupListViewController *goupListVC = [[YLDGroupListViewController alloc] init];
    UINavigationController *buyNav = [[UINavigationController alloc] initWithRootViewController:goupListVC];
 
    buyNav.tabBarItem.enabled = YES;

    goupListVC.tabBarItem.title = @"群组列表";
    goupListVC.tabBarItem.image = [[UIImage imageNamed:@"qunzuoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    goupListVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"qunzuon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [goupListVC.navigationController.navigationBar setBarTintColor:NavColor];
    [goupListVC.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    

    
    
    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:orderNav,buyNav,nil];
    self.viewControllers = list;
    UIColor *normalColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       normalColor,           NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:14.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = NavColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:14.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateSelected];
    // Do any additional setup after loading the view.
}
- (void)backHome {
    [self.navigationController popViewControllerAnimated:YES];
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
