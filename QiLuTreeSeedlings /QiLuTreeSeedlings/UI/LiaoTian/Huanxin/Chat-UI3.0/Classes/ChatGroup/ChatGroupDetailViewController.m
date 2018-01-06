/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "ChatGroupDetailViewController.h"

#import "ContactSelectionViewController.h"
#import "GroupSettingViewController.h"
#import "EMGroup.h"
#import "ContactView.h"
#import "GroupBansViewController.h"
#import "GroupSubjectChangingViewController.h"
#import "SearchMessageViewController.h"
#import "HttpClient.h"
#import "UIImageView+AFNetworking.h"
#import "YLDPersonMessageViewController.h"
#import "UIDefines.h"
#pragma mark - ChatGroupDetailViewController


#define kContactSize 75

@interface ChatGroupDetailViewController ()<EMGroupManagerDelegate, EMChooseViewDelegate,UIActionSheetDelegate,UISearchResultsUpdating,UISearchControllerDelegate>

- (void)unregisterNotifications;
- (void)registerNotifications;

@property (nonatomic) GroupOccupantType occupantType;
@property (strong, nonatomic) EMGroup *chatGroup;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *searchSource;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *addButton;

@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIButton *clearButton;
@property (strong, nonatomic) UIButton *exitButton;
@property (strong, nonatomic) UIButton *dissolveButton;
@property (strong, nonatomic) UIButton *configureButton;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
@property (strong, nonatomic) ContactView *selectedContact;
@property (strong, nonatomic) UISearchController *searchVC;
- (void)dissolveAction;
- (void)clearAction;
- (void)exitAction;
- (void)configureAction;

@end

@implementation ChatGroupDetailViewController

- (void)registerNotifications {
    [self unregisterNotifications];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications {
    [[EMClient sharedClient].groupManager removeDelegate:self];
}

- (void)dealloc {
    [self unregisterNotifications];
}

- (instancetype)initWithGroup:(EMGroup *)chatGroup
{
    self = [super init];
    if (self) {
        // Custom initialization
        _chatGroup = chatGroup;
        _dataSource = [NSMutableArray array];
        _occupantType = GroupOccupantTypeMember;
        [self registerNotifications];
        
    }
    return self;
}

- (instancetype)initWithGroupId:(NSString *)chatGroupId
{
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:chatGroupId]) {
            chatGroup = group;
            break;
        }
    }
    
    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:chatGroupId];
    }
    
    self = [self initWithGroup:chatGroup];
    if (self) {
        //
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"群信息";
    [self searchVC];
    CGRect frame=self.tableView.frame;
    frame.origin.y=35;
    self.tableView.frame=frame;
    [self.view addSubview:self.searchVC.searchBar];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popViewControllerzz) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.tableView.tableFooterView = self.footerView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupBansChanged) name:@"GroupBansChanged" object:nil];
    
    [self fetchGroupInfo];
}
-(void)popViewControllerzz
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated
{
    self.searchVC.searchBar.alpha=0;
    [self.searchVC setActive:NO];
    [super viewWillDisappear:animated];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchVC.searchBar.alpha=1;
}
#pragma mark - getter

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, kContactSize)];
        _scrollView.tag = 0;
        
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kContactSize - 10, kContactSize - 10)];
        [_addButton setImage:[UIImage imageNamed:@"group_participant_add"] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"group_participant_addHL"] forState:UIControlStateHighlighted];
        [_addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
        
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteContactBegin:)];
        _longPress.minimumPressDuration = 0.5;
    }
    
    return _scrollView;
}
-(void)searchWithStr:(NSString *)str
{
    NSString *phone =[NSString stringWithFormat:@"member CONTAINS[cd] '%@' OR nickName CONTAINS[cd] '%@' OR nos CONTAINS '%@' OR workstationName CONTAINS '%@'",str,str,str,str];
//    workstationName
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:phone];
    NSArray *arrayPre=[self.dataSource filteredArrayUsingPredicate: phonePredicate];
    self.searchSource=(NSMutableArray *)arrayPre;
    [self refreshScrollView];
}
- (UIButton *)clearButton
{
    if (_clearButton == nil) {
        _clearButton = [[UIButton alloc] init];
        [_clearButton setTitle:@"清除聊天信息" forState:UIControlStateNormal];
        [_clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
        [_clearButton setBackgroundColor:[UIColor colorWithRed:87 / 255.0 green:186 / 255.0 blue:205 / 255.0 alpha:1.0]];
    }
    
    return _clearButton;
}

- (UIButton *)dissolveButton
{
    if (_dissolveButton == nil) {
        _dissolveButton = [[UIButton alloc] init];
        [_dissolveButton setTitle:@"解散群" forState:UIControlStateNormal];
        [_dissolveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dissolveButton addTarget:self action:@selector(dissolveAction) forControlEvents:UIControlEventTouchUpInside];
        [_dissolveButton setBackgroundColor: [UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];
    }
    
    return _dissolveButton;
}

- (UIButton *)exitButton
{
    if (_exitButton == nil) {
        _exitButton = [[UIButton alloc] init];
        [_exitButton setTitle:@"退出群" forState:UIControlStateNormal];
        [_exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
        [_exitButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];
    }
    
    return _exitButton;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 160)];
        _footerView.backgroundColor = [UIColor clearColor];
        
        self.clearButton.frame = CGRectMake(20, 40, _footerView.frame.size.width - 40, 35);
        [_footerView addSubview:self.clearButton];
        
//        self.dissolveButton.frame = CGRectMake(20, CGRectGetMaxY(self.clearButton.frame) + 30, _footerView.frame.size.width - 40, 35);
//        
//        self.exitButton.frame = CGRectMake(20, CGRectGetMaxY(self.clearButton.frame) + 30, _footerView.frame.size.width - 40, 35);
    }
    
    return _footerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.occupantType == GroupOccupantTypeOwner)
    {
        return 3;
    }
    else
    {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell.contentView addSubview:self.scrollView];
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"群编号";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = _chatGroup.groupId;
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"群成员数量";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", (int)[_chatGroup.occupants count]];
    }
//    else if (indexPath.row == 3)
//    {
//        cell.textLabel.text = NSLocalizedString(@"title.groupSetting", @"Group Setting");
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    else if (indexPath.row == 4)
//    {
//        cell.textLabel.text = NSLocalizedString(@"title.groupSubjectChanging", @"Change group name");
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    else if (indexPath.row == 5)
//    {
//        cell.textLabel.text = NSLocalizedString(@"title.groupSearchMessage", @"Search Message from History");
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    else if (indexPath.row == 6)
//    {
//        cell.textLabel.text = NSLocalizedString(@"title.groupBlackList", @"Group black list");
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)indexPath.row;
    if (row == 0) {
        return self.scrollView.frame.size.height + 40;
    }
    else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3) {
        GroupSettingViewController *settingController = [[GroupSettingViewController alloc] initWithGroup:_chatGroup];
        [self.navigationController pushViewController:settingController animated:YES];
    }
    else if (indexPath.row == 4)
    {
        GroupSubjectChangingViewController *changingController = [[GroupSubjectChangingViewController alloc] initWithGroup:_chatGroup];
        [self.navigationController pushViewController:changingController animated:YES];
    }
    else if (indexPath.row == 5) {
        SearchMessageViewController *bansController = [[SearchMessageViewController alloc] initWithConversationId:_chatGroup.groupId conversationType:EMConversationTypeGroupChat];
        [self.navigationController pushViewController:bansController animated:YES];
    }
    else if (indexPath.row == 6) {
        GroupBansViewController *bansController = [[GroupBansViewController alloc] initWithGroup:_chatGroup];
        [self.navigationController pushViewController:bansController animated:YES];
    }
}

#pragma mark - EMChooseViewDelegate
- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    NSInteger maxUsersCount = _chatGroup.setting.maxUsersCount;
    if (([selectedSources count] + _chatGroup.membersCount) > maxUsersCount) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"group.maxUserCount", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
        
        return NO;
    }
    
    [self showHudInView:self.view hint:@"添加一位新的群成员"];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *source = [NSMutableArray array];
        for (NSString *username in selectedSources) {
            [source addObject:username];
        }
        
        NSString *username = [[EMClient sharedClient] currentUsername];
        NSString *messageStr = [NSString stringWithFormat:NSLocalizedString(@"group.somebodyInvite", @"%@ invite you to join group \'%@\'"), username, weakSelf.chatGroup.subject];
        EMError *error = nil;
        weakSelf.chatGroup = [[EMClient sharedClient].groupManager addOccupants:source toGroup:weakSelf.chatGroup.groupId welcomeMessage:messageStr error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [weakSelf reloadDataSource];
            }
            else
            {
                [weakSelf hideHud];
                [weakSelf showHint:error.errorDescription];
            }
        
        });
    });
    
    return YES;
}

- (void)groupBansChanged
{
    [self.searchSource removeAllObjects];
    [self.searchSource addObjectsFromArray:self.chatGroup.occupants];
    [self refreshScrollView];
}

#pragma mark - EMGroupManagerDelegate

- (void)didReceiveAcceptedGroupInvitation:(EMGroup *)aGroup
                                  invitee:(NSString *)aInvitee
{
    if ([aGroup.groupId isEqualToString:self.chatGroup.groupId]) {
        [self fetchGroupInfo];
    }
}

#pragma mark - data

- (void)fetchGroupInfo
{
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:@"加载中"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:weakSelf.chatGroup.groupId includeMembersList:YES error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
        });
        if (!error) {
            weakSelf.chatGroup = group;
            EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:group.groupId type:EMConversationTypeGroupChat createIfNotExist:YES];
            if ([group.groupId isEqualToString:conversation.conversationId]) {
                NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                [ext setObject:group.subject forKey:@"subject"];
                [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                conversation.ext = ext;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reloadDataSource];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showHint:NSLocalizedString(@"group.fetchInfoFail", @"failed to get the group details, please try again later")];
            });
        }
    });
}

- (void)reloadDataSource
{
    [self.searchSource removeAllObjects];
    [self.dataSource removeAllObjects];
    self.occupantType = GroupOccupantTypeMember;
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    if ([self.chatGroup.owner isEqualToString:loginUsername]) {
        self.occupantType = GroupOccupantTypeOwner;
    }
    
    if (self.occupantType != GroupOccupantTypeOwner) {
        for (NSString *str in self.chatGroup.members) {
            if ([str isEqualToString:loginUsername]) {
                self.occupantType = GroupOccupantTypeMember;
                break;
            }
        }
    }
    [HTTPCLIENT getGroupmembersWithGroupUid:_chatGroup.groupId Success:^(id responseObject) {
//
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
                [self.dataSource addObject:dic];
            }
        }
        self.searchSource=self.dataSource;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshScrollView];
            [self refreshFooterView];
            [self hideHud];
        });
    } failure:^(NSError *error) {
        
    }];
    
   
}

- (void)refreshScrollView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.scrollView removeGestureRecognizer:_longPress];
    [self.addButton removeFromSuperview];
    
    BOOL showAddButton = NO;
    if (self.occupantType == GroupOccupantTypeOwner) {
        [self.scrollView addGestureRecognizer:_longPress];
        [self.scrollView addSubview:self.addButton];
        showAddButton = YES;
    }
    else if (self.chatGroup.setting.style == EMGroupStylePrivateMemberCanInvite && self.occupantType == GroupOccupantTypeMember) {
        [self.scrollView addSubview:self.addButton];
        showAddButton = YES;
    }
    int kColOfRow = 4;
    kColOfRow = (kWidth-20)/75;
    int tmp = ([self.searchSource count] + 1) % kColOfRow;
    int row = (int)([self.searchSource count] + 1) / kColOfRow;
    row += tmp == 0 ? 0 : 1;
    self.scrollView.tag = row;
    self.scrollView.frame = CGRectMake(10, 35, self.tableView.frame.size.width-20, row * kContactSize);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, row * kContactSize);
    int i = 0;
    int j = 0;
     BOOL isEditing =  YES;
    BOOL isEnd = NO;
    for (i = 0; i < row; i++) {
        for (j = 0; j < kColOfRow; j++) {
            NSInteger index = i * kColOfRow + j;
            if (index < [self.searchSource count]) {
                NSDictionary *dic=[self.searchSource objectAtIndex:index];
                NSString *username = dic[@"nickName"];
                NSInteger type=[dic[@"type"] integerValue];
               
                NSString *strs = nil;
                switch (type) {
                 
                    case 5:
                        strs=[NSString stringWithFormat:@"%@%@",dic[@"nos"],dic[@"workstationName"]];
                        break;
                    case 6:
                        strs=[NSString stringWithFormat:@"%@%@",dic[@"nos"],dic[@"workstationName"]];
                        break;

                    default:
                        break;
                }

                ContactView *contactView = [[ContactView alloc] initWithFrame:CGRectMake(j * kContactSize, i * kContactSize, kContactSize, kContactSize)];
                contactView.index = i * kColOfRow + j;
                if (strs) {
                   contactView.remark = strs;
                }else if (username) {
                    contactView.remark = username;
                }else{
                    contactView.remark = @"管理员";
                }
                NSString *pic=dic[@"pic"];
                if (pic) {
                    [contactView.imageView setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"UserImageV"]];
                }else
                {
                 contactView.image = [UIImage imageNamed:@"UserImageV@2x.png"];
                }
               
                
//                if (![username isEqualToString:loginUsername]) {
//                    contactView.editing = isEditing;
//                }
                contactView.editing = isEditing;

                __weak typeof(self) weakSelf = self;
                [contactView setDeleteContact:^(NSInteger index) {
                    NSDictionary *occupants = [weakSelf.searchSource objectAtIndex:index];
                    NSInteger type=[occupants[@"type"] integerValue];
                    if(type==0)
                    {
                        return ;
                    }
                    NSString *str = nil;
                    switch (type) {
                        case 1:
                            str=@"金牌供应商";
                            break;
                        case 2:
                            str=@"银牌供应商";
                            break;
                        case 3:
                            str=@"铜牌供应商";
                            break;
                        case 4:
                            str=@"认证会员";
                            break;
                        case 5:
                            str=[NSString stringWithFormat:@"%@%@",occupants[@"nos"],occupants[@"workstationName"]];
                            break;
                        case 6:
                            str=[NSString stringWithFormat:@"%@%@",occupants[@"nos"],occupants[@"workstationName"]];
                            break;
                        case 7:
                            str=@"工程公司";
                            break;
                        case 8:
                            str=@"合作苗企";
                            break;
                        case 9:
                            str=@"苗小二";
                            break;
                        case 11:
                            str=@"经纪人-";
                            break;
                        case 999:
                            str=@"客服";
                            break;
                        default:
                            break;
                    }
                    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                    dic[@"nick"]=occupants[@"nickName"];
                    dic[@"avatar"]=occupants[@"pic"];
                    dic[@"phone"]=occupants[@"phone"];
                    dic[@"identity"]=str;
                   
                    YLDPersonMessageViewController *personvc=[[YLDPersonMessageViewController alloc]initWithFrom:1 withDic:dic];
                    NSString *senderID = occupants[@"member"];
                    if ([APPDELEGATE.userModel.phone isEqualToString:senderID]) {
                        personvc.isSender=YES;
                    }else{
                        personvc.isSender=NO;
                    }
                    personvc.senderID = senderID;
                    [self.navigationController pushViewController:personvc animated:YES];
                }];
                
                [self.scrollView addSubview:contactView];
            }
            else{
                if(showAddButton && index == self.searchSource.count)
                {
                    self.addButton.frame = CGRectMake(j * kContactSize + 5, i * kContactSize + 10, kContactSize - 10, kContactSize - 10);
                }
                
                isEnd = YES;
                break;
            }
        }
        
        if (isEnd) {
            break;
        }
    }
    
    [self.tableView reloadData];
}

- (void)refreshFooterView
{
//    if (self.occupantType == GroupOccupantTypeOwner) {
//        [_exitButton removeFromSuperview];
//        [_footerView addSubview:self.dissolveButton];
//    }
//    else{
        [_dissolveButton removeFromSuperview];
//        [_footerView addSubview:self.exitButton];
//    }
}

#pragma mark - action

- (void)tapView:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        if (self.addButton.hidden) {
            [self setScrollViewEditing:NO];
        }
    }
}

- (void)deleteContactBegin:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        for (ContactView *contactView in self.scrollView.subviews)
        {
            CGPoint locaton = [longPress locationInView:contactView];
            if (CGRectContainsPoint(contactView.bounds, locaton))
            {
                if ([contactView isKindOfClass:[ContactView class]]) {
                    if ([contactView.remark isEqualToString:loginUsername]) {
                        return;
                    }
                    _selectedContact = contactView;
                    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"delete", @"deleting member..."), NSLocalizedString(@"friend.block", @"add to black list"), nil];
                    [sheet showInView:self.view];
                }
            }
        }
    }
}

- (void)setScrollViewEditing:(BOOL)isEditing
{
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    
    for (ContactView *contactView in self.scrollView.subviews)
    {
        if ([contactView isKindOfClass:[ContactView class]]) {
            if ([contactView.remark isEqualToString:loginUsername]) {
                continue;
            }
            
            [contactView setEditing:isEditing];
        }
    }
    
    self.addButton.hidden = isEditing;
}

- (void)addContact:(id)sender
{
    ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] initWithBlockSelectedUsernames:_chatGroup.occupants];
    selectionController.delegate = self;
    [self.navigationController pushViewController:selectionController animated:YES];
}

//清空聊天记录
- (void)clearAction
{
    __weak typeof(self) weakSelf = self;
    [EMAlertView showAlertWithTitle:@"提示"
                            message:@"确定清空聊天信息？"
                    completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                        if (buttonIndex == 1) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAllMessages" object:weakSelf.chatGroup.groupId];
                        }
                    } cancelButtonTitle:@"取消"
                  otherButtonTitles:@"确定", nil];
    
}

//解散群组
- (void)dissolveAction
{
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"group.destroy", @"dissolution of the group")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        [[EMClient sharedClient].groupManager destroyGroup:weakSelf.chatGroup.groupId error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (error) {
                [weakSelf showHint:NSLocalizedString(@"group.destroyFail", @"dissolution of group failure")];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
            }
        });
    });
}

//设置群组
- (void)configureAction {
    // todo
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [[EMClient sharedClient].groupManager ignoreGroupPush:weakSelf.chatGroup.groupId ignore:weakSelf.chatGroup.isPushNotificationEnabled];
    });
}

//退出群组
- (void)exitAction
{
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"group.leave", @"quit the group")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        [[EMClient sharedClient].groupManager leaveGroup:weakSelf.chatGroup.groupId error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (error) {
                [weakSelf showHint:NSLocalizedString(@"group.leaveFail", @"exit the group failure")];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
            }
        });
    });
}

- (void)didIgnoreGroupPushNotification:(NSArray *)ignoredGroupList error:(EMError *)error {
    // todo
    NSLog(@"ignored group list:%@.", ignoredGroupList);
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger index = _selectedContact.index;
    if (buttonIndex == 0)
    {
        //delete
        _selectedContact.deleteContact(index);
    }
    else if (buttonIndex == 1)
    {
        //add to black list
        [self showHudInView:self.view hint:NSLocalizedString(@"group.ban.adding", @"Adding to black list..")];
        NSArray *occupants = [NSArray arrayWithObject:[self.searchSource objectAtIndex:_selectedContact.index]];
        __weak ChatGroupDetailViewController *weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
            EMError *error = nil;
            EMGroup *group = [[EMClient sharedClient].groupManager blockOccupants:occupants
                                                                       fromGroup:weakSelf.chatGroup.groupId
                                                                           error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                if (!error) {
                    weakSelf.chatGroup = group;
                    [weakSelf.searchSource removeObjectAtIndex:index];
                    [weakSelf refreshScrollView];
                }
                else{
                    [weakSelf showHint:error.errorDescription];
                }
            });
        });
    }
    _selectedContact = nil;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    _selectedContact = nil;
}
- (UISearchController *)searchVC
{
    if (!_searchVC) {
        
        _searchVC = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchVC.searchResultsUpdater = self;
        _searchVC.delegate = self;
        _searchVC.dimsBackgroundDuringPresentation = NO;
        
        _searchVC.hidesNavigationBarDuringPresentation = NO;
        
        _searchVC.searchBar.frame = CGRectMake(0, 0, kWidth, 44.0);
        

    }
    return _searchVC;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchVC.searchBar text];
    if (searchString.length>0) {
        [self searchWithStr:searchString];
    }else
    {
        self.searchSource=self.searchSource;
        [self refreshScrollView];
    }
   
}
- (void)willDismissSearchController:(UISearchController *)searchController
{
        self.searchSource=self.dataSource;
        [self refreshScrollView];
    
}
@end
