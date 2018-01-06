//
//  YLDGroupListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/12/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGroupListViewController.h"
#import "YLDGroupTableViewCell.h"
//环信
#import "ChatViewController.h"
#import "UserProfileManager.h"
#import "UIDefines.h"
#import "HttpClient.h"
@interface YLDGroupListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *myGroups;
@property (nonatomic,copy)NSDictionary *groupsPersonDic;
@end

@implementation YLDGroupListViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatHuiHuaAction:) name:@"creatHuiHua" object:nil];
    self.title=@"群组";
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backActions) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];

    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,kWidth , kHeight) style:UITableViewStylePlain];
    [tableView setBackgroundColor:BGColor];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    EMError *error1 = nil;
    _myGroups = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error1];
    if (!error1) {
        [tableView reloadData];
    }else{
//        NSLog(@"%@",error1.errorDescription);
    }
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    for (EMGroup *group in _myGroups) {
        [[EMClient sharedClient].groupManager ignoreGroupPush:group.groupId ignore:NO];
        
        NSMutableArray *membersAry=[NSMutableArray array];
        [HTTPCLIENT getGroupmembersWithGroupUid:group.groupId Success:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    NSArray *result=[responseObject objectForKey:@"result"];
                    for (int i=0; i<result.count; i++) {
                        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:result[i]];
                        NSString *str=dic[@"no"];
                        if (str.length==0) {
                            [dic setObject:@"0" forKey:@"nos"];
                        }else{
                            [dic setObject:str forKey:@"nos"];
                        }
                        NSString *str2=dic[@"workstationName"];
                        if (str2.length==0) {
                            [dic setObject:@"" forKey:@"workstationName"];
                        }
                        [membersAry addObject:dic];
                    }
                    [dic setObject:membersAry forKey:group.groupId];
                    self.groupsPersonDic=dic;
                }
            } failure:^(NSError *error) {
                
            }];
    }
    
    

}
-(void)backActions
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDChatBack" object:nil];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myGroups.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDGroupTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGroupTableViewCell"];
    if (!cell) {
        cell=[YLDGroupTableViewCell yldGroupTableViewCell];
    }
    EMGroup *group = _myGroups[indexPath.row];
    cell.gooupTitle.text=group.subject;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EMGroup *group = _myGroups[indexPath.row];
    ChatViewController *chatController1 = [[ChatViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
    chatController1.hidesBottomBarWhenPushed=YES;
    chatController1.title=group.subject;
    NSArray *pesonAry =self.groupsPersonDic[group.groupId];
    chatController1.personAry=pesonAry;
    [self.navigationController pushViewController:chatController1 animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)creatHuiHuaAction:(NSNotification *)oo
{
    [self.navigationController popToRootViewControllerAnimated:NO];
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
