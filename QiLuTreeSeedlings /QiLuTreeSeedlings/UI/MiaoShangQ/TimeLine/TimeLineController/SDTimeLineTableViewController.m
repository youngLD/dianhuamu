//
//  SDTimeLineTableViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDTimeLineTableViewController.h"

#import "SDRefresh.h"

#import "SDTimeLineTableHeaderView.h"
#import "SDTimeLineRefreshHeader.h"
#import "SDTimeLineRefreshFooter.h"
#import "SDTimeLineCell.h"
#import "SDTimeLineCellModel.h"

#import "UITableView+SDAutoTableViewCellHeight.h"

#import "UIView+SDAutoLayout.h"
#import "LEETheme.h"
#import "GlobalDefines.h"
#import "UIDefines.h"
#import "YLDWMSFBViewController.h"
#import "ChangyanSDK.h"
#import "YLDLoginViewController.h"
#import "UINavController.h"
#import "KMJRefresh.h"
//#import "IQKeyboardManager.h"
#define kTimeLineTableViewCellId @"SDTimeLineCell"

static CGFloat textFieldH = 40;

@interface SDTimeLineTableViewController () <SDTimeLineCellDelegate, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
@property (nonatomic, copy) NSString *commentToUser;
@property (nonatomic, copy)NSString * lastTime;
@property (nonatomic, assign)BOOL isfreach;
@end

@implementation SDTimeLineTableViewController

{
    SDTimeLineRefreshFooter *_refreshFooter;
    SDTimeLineRefreshHeader *_refreshHeader;
    CGFloat _lastScrollViewOffsetY;
    CGFloat _totalKeybordHeight;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_textField resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    

    UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"miaoshangqufabu"] style:UIBarButtonItemStylePlain target:self action:@selector(fabuBtnAction)];
    rightButtonItem.tintColor=[UIColor blackColor];
    self.navigationItem.rightBarButtonItem=rightButtonItem;
    //LEETheme 分为两种模式 , 独立设置模式 JSON设置模式 , 朋友圈demo展示的是独立设置模式的使用 , 微信聊天demo 展示的是JSON模式的使用

//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"日间" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
//    
//    rightBarButtonItem.lee_theme
//    .LeeAddCustomConfig(DAY , ^(UIBarButtonItem *item){
//        
//        item.title = @"夜间";
//        
//    }).LeeAddCustomConfig(NIGHT , ^(UIBarButtonItem *item){
//        
//        item.title = @"日间";
//    });
    
    //为self.view 添加背景颜色设置
    
    self.view.lee_theme
    .LeeAddBackgroundColor(DAY , [UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT , [UIColor blackColor]);
    
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    __weak typeof(self) weakSelf=self;
   [self.tableView addHeaderWithCallback:^{
       weakSelf.lastTime=nil;
       
       [weakSelf creatModelsWithCount:nil];
   }];
    
    
    // 上拉加载

    
    [self.tableView addFooterWithCallback:^{
       
        [weakSelf creatModelsWithCount:nil];
    }];
    [self.tableView headerBeginRefreshing];
    SDTimeLineTableHeaderView *headerView = [SDTimeLineTableHeaderView new];
    headerView.frame = CGRectMake(0, 0, 0, 64);
    [self.view addSubview:headerView];
//    self.tableView.tableHeaderView = headerView;
    
    //添加分隔线颜色设置
    
    self.tableView.lee_theme
    .LeeAddSeparatorColor(DAY , [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f])
    .LeeAddSeparatorColor(NIGHT , [[UIColor grayColor] colorWithAlphaComponent:0.5f]);
    
    [self.tableView registerClass:[SDTimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    
    [self setupTextField];
    _textField.inputAccessoryView=[UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [LEETheme startTheme:DAY];
    
   
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isfreach) {
        [self.tableView headerBeginRefreshing];
        self.isfreach=NO;
    }
    
}


- (void)dealloc
{
    [_refreshHeader removeFromSuperview];
    [_refreshFooter removeFromSuperview];
    
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)fabuBtnAction
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
            YLDWMSFBViewController *sdsd=[YLDWMSFBViewController new];
            self.isfreach=YES;
            sdsd.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:sdsd animated:YES];
}
- (void)setupTextField
{
    _textField = [UITextField new];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    _textField.layer.borderWidth = 1;
    [_textField setBackgroundColor:[UIColor whiteColor]];
    _textField.placeholder=@"说点什么吧...";
    //为textfield添加背景颜色 字体颜色的设置 还有block设置 , 在block中改变它的键盘样式 (当然背景颜色和字体颜色也可以直接在block中写)
    
    _textField.lee_theme
    .LeeAddBackgroundColor(DAY , [UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT , [UIColor blackColor])
    .LeeAddTextColor(DAY , [UIColor blackColor])
    .LeeAddTextColor(NIGHT , [UIColor grayColor])
    .LeeAddCustomConfig(DAY , ^(UITextField *item){
        
        item.keyboardAppearance = UIKeyboardAppearanceDefault;
        if ([item isFirstResponder]) {
            [item resignFirstResponder];
            [item becomeFirstResponder];
        }
    }).LeeAddCustomConfig(NIGHT , ^(UITextField *item){
        
        item.keyboardAppearance = UIKeyboardAppearanceDark;
        if ([item isFirstResponder]) {
            [item resignFirstResponder];
            [item becomeFirstResponder];
        }
    });
    
    _textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.width_sd, textFieldH);
    [[UIApplication sharedApplication].keyWindow addSubview:_textField];
    
//    [_textField becomeFirstResponder];
//    [_textField resignFirstResponder];
}

// 右栏目按钮点击事件

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender{
    
    if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
        
        [LEETheme startTheme:NIGHT];
        
    } else {
        [LEETheme startTheme:DAY];
    }
}

- (void)creatModelsWithCount:(NSInteger)count
{
    __weak typeof(self)weakself=self;
//    __weak typeof(_refreshFooter) weakRefreshFooter = _refreshFooter;
//    __weak typeof(_refreshHeader) weakRefreshHeader = _refreshHeader;
    [HTTPCLIENT weimiaoshangListWithPage:self.lastTime  Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]==1) {
            NSArray *qary=[responseObject objectForKey:@"data"];
            if (weakself.lastTime==nil) {
                [self.dataArray removeAllObjects];
            }else{
                if (qary.count==0) {
                    [ToastView showTopToast:@"已无更多数据"];
                }
            }
            
            for (int i=0; i<qary.count; i++) {
                SDTimeLineCellModel *model = [SDTimeLineCellModel new];
                NSDictionary *dic =qary[i];

                model.name=dic[@"nickname"];
                model.iconName=dic[@"headPortrait"];
                model.msgContent =dic[@"content"];
                NSArray *attas=dic[@"attas"];
                NSMutableArray *imageAry=[NSMutableArray array];
                for (NSDictionary *imageDic in attas) {
                    [imageAry addObject:imageDic[@"path"]];
                }
                model.picNamesArray=imageAry;
                model.memberUid=dic[@"partyId"];
                NSDate* date = [NSDate oss_dateFromString:dic[@"createdDate"]];
                model.timec = [ZIKFunction compareCurrentTime:date];
                model.uid=dic[@"circleId"];
                model.topic_id=[NSString stringWithFormat:@"%@",[dic[@"comments"] objectForKey:@"topic_id"]];
                NSArray *commentsAry=[dic[@"comments"] objectForKey:@"comments"];
                NSMutableArray *commentsAryss=[NSMutableArray array];
                for (int j = 0; j < commentsAry.count; j++) {
                    SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
                    NSDictionary *dic=[commentsAry[j] objectForKey:@"passport"];
                    
                    commentItemModel.firstUserName = dic[@"nickname"];
                    commentItemModel.firstUserId = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
                    commentItemModel.commentString=[commentsAry[j] objectForKey:@"content"];
                    commentItemModel.comment_id=[NSString stringWithFormat:@"%@",[commentsAry[j] objectForKey:@"comment_id"]];
                   NSString *metadata = [NSString stringWithFormat:@"%@",[commentsAry[j] objectForKey:@"metadata"]];
                    if (![metadata isEqualToString:@"metadata"]) {
                        commentItemModel.secondUserName=metadata;
                        commentItemModel.secondUserId=metadata;
                    }
                    
                    [commentsAryss addObject:commentItemModel];
                }
                model.commentItemsArray = [commentsAryss copy];
              [weakself.dataArray addObject:model];
            }
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([weakself.tableView isHeaderRefreshing]) {
                   [weakself.tableView headerEndRefreshing];
                    [weakself.tableView reloadData];
                }
                if ([weakself.tableView isFooterRefreshing]) {
                    [weakself.tableView footerEndRefreshing];
                    
                    [weakself.tableView reloadDataWithExistedHeightCache];
                }
          });

        }
    } failure:^(NSError *error) {
        
    }];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            SDTimeLineCellModel *model = weakSelf.dataArray[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        [cell setDidClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow, NSIndexPath *indexPath) {
            weakSelf.textField.placeholder = [NSString stringWithFormat:@"  回复：%@", commentId];
            weakSelf.currentEditingIndexthPath = indexPath;
            [weakSelf.textField becomeFirstResponder];
            weakSelf.isReplayingComment = YES;
            weakSelf.commentToUser = commentId;
            
            [weakSelf adjustTableViewToFitKeyboardWithRect:rectInWindow];
        }];
        
        cell.delegate = self;
    }
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    ///////////////////////////////////////////////////////////////////////
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)deleteClickActionWithModel:(SDTimeLineCellModel *)model{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除该信息？" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakself=self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull      action) {
        ShowActionV();
        [HTTPCLIENT MiaoshangquanShanChuWithUid:model.uid Success:^(id responseObject) {
            RemoveActionV();
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.dataArray removeObject:model];
                    [weakself.tableView reloadData];
                });
                
            }
        } failure:^(NSError *error) {
            
        }];

        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textField resignFirstResponder];
    _textField.placeholder = nil;
}



- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


#pragma mark - SDTimeLineCellDelegate

- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell
{
    [_textField becomeFirstResponder];
    _currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
    
    [self adjustTableViewToFitKeyboard];
    
}

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[index.row];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:model.likeItemsArray];
    
    if (!model.isLiked) {
        SDTimeLineCellLikeItemModel *likeModel = [SDTimeLineCellLikeItemModel new];
        likeModel.userName = @"GSD_iOS";
        likeModel.userId = @"gsdios";
        [temp addObject:likeModel];
        model.liked = YES;
    } else {
        SDTimeLineCellLikeItemModel *tempLikeModel = nil;
        for (SDTimeLineCellLikeItemModel *likeModel in model.likeItemsArray) {
            if ([likeModel.userId isEqualToString:@"gsdios"]) {
                tempLikeModel = likeModel;
                break;
            }
        }
        [temp removeObject:tempLikeModel];
        model.liked = NO;
    }
    model.likeItemsArray = [temp copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    });
}


- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tableView setContentOffset:offset animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [_textField resignFirstResponder];
        
       
        SDTimeLineCellModel *model = self.dataArray[_currentEditingIndexthPath.row];
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:model.commentItemsArray];
        SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
        if (self.isReplayingComment)
        {
            [ChangyanSDK submitComment:model.topic_id content:_textField.text replyID:nil score:@"5" appType:40 picUrls:nil metadata:self.commentToUser completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
                
            }];
        }else{
            [ChangyanSDK submitComment:model.topic_id content:_textField.text replyID:nil score:@"5" appType:40 picUrls:nil metadata:@"metadata" completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
                
            }];
        }
        
        
        if (self.isReplayingComment) {
            commentItemModel.firstUserName = APPDELEGATE.userModel.nickname;
            commentItemModel.firstUserId = APPDELEGATE.userModel.nickname;
            commentItemModel.secondUserName = self.commentToUser;
            commentItemModel.secondUserId = self.commentToUser;
            commentItemModel.commentString = textField.text;
            
            self.isReplayingComment = NO;
        } else {
            commentItemModel.firstUserName = APPDELEGATE.userModel.nickname;
            commentItemModel.commentString = textField.text;
            commentItemModel.firstUserId = APPDELEGATE.userModel.nickname;
        }
        [temp insertObject:commentItemModel atIndex:0];
        model.commentItemsArray = [temp copy];
        [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
        
        _textField.text = @"";
        _textField.placeholder =@"说点什么吧...";
        
        return YES;
    }
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.tableView.contentOffset.y>self.tableView.contentSize.height - self.tableView.bounds.size.height) {
        CGFloat offset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
        if (offset > 0)
        {
            [self.tableView setContentOffset:CGPointMake(0, offset) animated:YES];
        }
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(![APPDELEGATE isNeedLogin])
    {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        [textField resignFirstResponder];
        return;
    }
}
- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _textField.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + textFieldH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}

@end
