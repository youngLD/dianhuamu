//
//  ZIKMySupplyVC.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/3.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKMySupplyVC.h"

/*****工具******/
#import "HttpClient.h"
#import "YYModel.h"//类型转换
#import "KMJRefresh.h"//MJ刷新
/*****工具******/

/*****Model******/
#import "ZIKSupplyModel.h"//供应model
/*****Model******/

/*****View******/
#import "ZIKMySupplyCellBackButton.h"//已退回状态，查看退回原因button
#import "ZIKMySupplyTableViewCell.h"//供应cell
#import "ZIKBottomDeleteTableViewCell.h"//底部删除view,在已过期状态并且可编辑状态下
#import "ZIKMySupplyBottomRefreshTableViewCell.h"//底部刷新view 在已通过并且可编辑状态下
#import "BuyMessageAlertView.h"//提示界面
/*****View******/

/*****Controller******/
#import "ZIKSupplyPublishVC.h"//发布供应
#import "ZIKMySupplyDetailViewController.h"//供应详情
#import "NuseryDetialViewController.h"//新增苗圃信息
/*****Controller******/

/*****宏定义******/
#define NAV_HEIGHT 64 //navgationview 高度
#define MENUVIEW_HEIGHT 43  //button 选择菜单高度
#define CELL_FOOTERVIEW_HEIGH 8 //cell的section footer
#define REFRESH_CELL_HEIGH 50 //底部刷新view视图高度
#define SUPPLY_STATE_BUTTON_FONT [UIFont systemFontOfSize:14.0f] //供应状态按钮字体大小
/*****宏定义******/

typedef NS_ENUM(NSInteger, SupplyState) {
    SupplyStateAll       = 0,//全部
    SupplyStateThrough   = 2,//已通过
    SupplyStateOverdue   = 3,//已退回
    SupplyStateNoThrough = 5 //过期
};

@interface ZIKMySupplyVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, assign) NSInteger      page;            //页数从1开始
@property (nonatomic, strong) NSMutableArray *supplyInfoMArr; //供应信息数组
@property (nonatomic, assign) BOOL           isCanPublish;    //是否能够发布
@property (nonatomic, assign) SupplyState    state;           //供应状态
@property (nonatomic, strong) UITableView    *supplyTableView;//供应列表
@property (nonatomic, strong) UIView         *menuView;       //状态按钮视图
@end

@implementation ZIKMySupplyVC
{

    @private
    UIView *_emptyUI;//没有发布供应信息时显示的空白view
    UIView *_lineView;//按钮下跟随滑动的lineview
    UIButton *_cuttentButton;  //指向目前状态（四种状态下）的按钮
    ZIKBottomDeleteTableViewCell *_bottomcell; //过期编辑状态下底部删除view
    UILongPressGestureRecognizer *_tapDeleteGR;//长按手势
    ZIKMySupplyBottomRefreshTableViewCell *_refreshCell;//已通过编辑状态下底部刷新view

    NSMutableArray *_refreshMarr;   //保存选中行数据(已通过状态下)
    NSArray *_throughSelectIndexArr;//已通过编辑状态下,选中的刷新index

    NSMutableArray *_removeArray;    // 保存选中行数据（过期状态下）
    NSArray *_deleteIndexArr;//过期编辑状态下,选中的删除index
}

#pragma mark - 视图cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestData];//请求我的供应列表信息
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//并行队列（并发执行）（发布限制信息不需要立即获取）
    dispatch_async(queue, ^{
        [weakSelf requestSupplyRestrict];//请求发布限制信息
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNav];//配置navigation标题按钮等
    [self initData];//初始化数据
    [self initUI];//初始化界面
}

#pragma mark - 返回箭头按钮点击事件
-(void)backBtnAction:(UIButton *)sender
{
    if (self.supplyTableView.editing) {
        self.supplyTableView.editing = NO;
        if (self.state == SupplyStateThrough) {//如果是已通过编辑状态
            if (_refreshMarr.count > 0) {
                [_refreshMarr removeAllObjects]; //选中的刷新model清空
            }
            if (_throughSelectIndexArr.count > 0) {//选中的刷新数组清空
                _throughSelectIndexArr = nil;
            }
            _refreshCell.hidden = YES;//隐藏底部刷新合计view
            _refreshCell.count  = 0;//底部刷新合计数为0
        }
        else if (self.state == SupplyStateNoThrough) {//如果是过期编辑状态
            if (_removeArray.count > 0) {//选中的删除model清空
                [_removeArray removeAllObjects];
            }
            if (_deleteIndexArr.count > 0) {//选中的删除cell 的 index清空
                _deleteIndexArr = nil;
            }
            _bottomcell.hidden = YES;
            _bottomcell.count  = 0;
        }
        self.supplyTableView.frame = CGRectMake(0, self.supplyTableView.frame.origin.y, Width, Height-64-50);//更改tableview 的frame
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        [self.supplyTableView addHeaderWithCallback:^{//添加刷新控件
            [weakSelf requestMySupplyList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
        }];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.supplyInfoMArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kZIKMySupplyTableViewCellID = @"kZIKMySupplyTableViewCellID";

    ZIKMySupplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKMySupplyTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMySupplyTableViewCell" owner:self options:nil] lastObject];
    }
    if (self.supplyInfoMArr.count > 0) {
        [cell configureCell:self.supplyInfoMArr[indexPath.section]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ZIKSupplyModel *model = self.supplyInfoMArr[section];
    if ([model.state isEqualToString:@"3"]) {
        return CELL_FOOTERVIEW_HEIGH+35;
    }
    return CELL_FOOTERVIEW_HEIGH;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = nil;
    ZIKSupplyModel *model = nil;
    if (self.supplyInfoMArr.count > 0) {
        model =   self.supplyInfoMArr[section];
    }
    if ([model.state isEqualToString:@"3"]) {
        view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, Width, 35+CELL_FOOTERVIEW_HEIGH);
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kWidth-30, 0.5)];
        lineView.backgroundColor = BGColor;
        [view addSubview:lineView];
        ZIKMySupplyCellBackButton *button = [[ZIKMySupplyCellBackButton alloc] initWithFrame:CGRectMake(0, 0.5, Width, 35)];
        button.backgroundColor = [UIColor whiteColor];
        [button setImage:[UIImage imageNamed:@"注意"] forState:UIControlStateNormal];
        [button setTitle:@"查看退回原因" forState:UIControlStateNormal];
        [view addSubview:button];
        button.tag = section;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return view;
}

#pragma mark - tableviw选中cell事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKSupplyModel *model = self.supplyInfoMArr[indexPath.section];
    if (self.supplyTableView.editing && self.state == SupplyStateThrough) {//刷新编辑状态
        if (!model.isCanRefresh) {//如果不可刷新
            [ToastView showTopToast:@"该条信息本次不能刷新"];
            [self.supplyTableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        if (model.isCanRefresh && _refreshMarr.count<5) {
            [_refreshMarr addObject:model];
            _refreshCell.count = _refreshMarr.count;
            NSArray *selectedRows = [self.supplyTableView indexPathsForSelectedRows];
            _throughSelectIndexArr = selectedRows;
            return;
        }
        else if (_refreshMarr.count >= 5) {
            [self.supplyTableView deselectRowAtIndexPath:indexPath animated:YES];
            [ToastView showTopToast:@"一次最多刷新5条"];
            return;
        }
        return;
    }
    else if (self.supplyTableView.editing && self.state == SupplyStateNoThrough) {//过期编辑状态
        [_removeArray addObject:model];
        _bottomcell.count = _removeArray.count;
        NSArray *selectedRows = [self.supplyTableView indexPathsForSelectedRows];
        _deleteIndexArr = selectedRows;

        [self updateBottomDeleteCellView];
        return;
    }
    ZIKMySupplyDetailViewController *detailVC = [[ZIKMySupplyDetailViewController alloc] initMySupplyDetialWithUid:model];
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 更改底部删除视图( 过期编辑状态下  是否全选)
- (void)updateBottomDeleteCellView {
    (_deleteIndexArr.count == self.supplyInfoMArr.count) ? (_bottomcell.isAllSelect = YES) : (_bottomcell.isAllSelect = NO);
}

#pragma mark - tableviw反选cell事件
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKSupplyModel *model = [self.supplyInfoMArr objectAtIndex:indexPath.section];
    if (self.supplyTableView.editing && self.state == SupplyStateThrough) {//刷新编辑状态
        // 删除反选数据
        if ([_refreshMarr containsObject:model])
        {
            [_refreshMarr removeObject:model];
        }
        NSArray *selectedRows = [self.supplyTableView indexPathsForSelectedRows];
        _throughSelectIndexArr = selectedRows;
        _refreshCell.count = _refreshMarr.count;
    }
    else if (self.supplyTableView.editing && self.state == SupplyStateNoThrough) {//过期编辑状态
        if ([_removeArray containsObject:model]) {//删除反选数据
            [_removeArray removeObject:model];
        }
        NSArray *selectedRows = [self.supplyTableView indexPathsForSelectedRows];
        _deleteIndexArr = selectedRows;
        _bottomcell.count = _removeArray.count;
        [self updateBottomDeleteCellView];
    }
}

#pragma mark - 退回原因按钮点击事件
- (void)btnClick:(ZIKMySupplyCellBackButton *)button {
    ZIKSupplyModel *model = self.supplyInfoMArr[button.tag];

    BuyMessageAlertView *buyMessageAlertV=[BuyMessageAlertView addActionVieWithReturnReason:model.reason];
    buyMessageAlertV.rightBtn.tag = button.tag;
    [buyMessageAlertV.rightBtn addTarget:self action:@selector(miaopudetialAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)miaopudetialAction:(UIButton *)btn {
    ZIKSupplyModel *model = self.supplyInfoMArr[btn.tag];
    [HTTPCLIENT getMySupplyDetailInfoWithAccessToken:nil accessId:nil clientId:nil clientSecret:nil deviceId:nil uid:model.uid Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            return ;
        }
        if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
            NSDictionary *dic        = [responseObject objectForKey:@"result"];
            SupplyDetialMode *model  = [SupplyDetialMode creatSupplyDetialModelByDic:[dic objectForKey:@"detail"]];
            model.supplybuyName      = APPDELEGATE.userModel.name;
            model.phone              = APPDELEGATE.userModel.phone;
            ZIKSupplyPublishVC *spvc = [[ZIKSupplyPublishVC alloc] initWithModel:model];
            [self.navigationController pushViewController:spvc animated:YES];
        }

    } failure:^(NSError *error) {
        ;
    }];

    [BuyMessageAlertView removeActionView];
}


#pragma mark - 请求数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.supplyTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMySupplyList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.supplyTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMySupplyList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.supplyTableView headerBeginRefreshing];

}

#pragma mark - 请求我的供应列表信息
- (void)requestMySupplyList:(NSString *)page {
    //我的供应列表
    NSString *searchTime;
    if (self.page > 1 && self.supplyInfoMArr.count > 0) {
        ZIKSupplyModel *model = [self.supplyInfoMArr lastObject];
        searchTime = model.searchTime;
    }

    [self.supplyTableView headerEndRefreshing];
    HttpClient *httpClient = [HttpClient sharedClient];
    [httpClient getMysupplyListWithToken:nil withAccessId:nil withClientId:nil withClientSecret:nil withDeviewId:nil withState:[NSString stringWithFormat:@"%ld",(long)self.state] withPage:page withPageSize:@"15" WithsearchTime:searchTime success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            return ;
        }
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSArray *array = dic[@"supplys"];
        if (array.count == 0 && self.page == 1) {
        [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
            if (self.state == SupplyStateAll) {
                self.menuView.hidden = YES;
                self.supplyTableView.hidden = YES;
                [self createEmptyUI];
                _emptyUI.hidden = NO;
            }
            if (self.supplyInfoMArr.count > 0) {
                [self.supplyInfoMArr removeAllObjects];
            }
            [self.supplyTableView footerEndRefreshing];
            [self.supplyTableView reloadData];
            return ;
        }
        else if (array.count == 0 && self.page > 1) {
            _emptyUI.hidden = YES;
            self.menuView.hidden = NO;
            self.supplyTableView.hidden = NO;

            self.page--;
            [self.supplyTableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
            return;
        }
        else {
            _emptyUI.hidden = YES;
            self.menuView.hidden = NO;
            self.supplyTableView.hidden = NO;

            if (self.page == 1) {
                [self.supplyInfoMArr removeAllObjects];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKSupplyModel *model = [ZIKSupplyModel yy_modelWithDictionary:dic];
                if (self.state == SupplyStateThrough && [model.shuaxin isEqualToString:@"1"]) {
                    model.isCanRefresh = NO;
                } else {
                    model.isCanRefresh = YES;
                }
                [self.supplyInfoMArr addObject:model];
            }];
            [self.supplyTableView reloadData];
            //已通过状态并且可编辑状态
            if (self.supplyTableView.editing && self.state == SupplyStateThrough) {
                if (_throughSelectIndexArr.count > 0) {
                    [_throughSelectIndexArr enumerateObjectsUsingBlock:^(NSIndexPath *selectIndex, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.supplyTableView selectRowAtIndexPath:selectIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
                    }];
                }
            }
            //已过期并且可编辑状态
            else if (self.supplyTableView.editing && self.state == SupplyStateNoThrough) {
                if (_deleteIndexArr.count > 0) {
                    [_deleteIndexArr enumerateObjectsUsingBlock:^(NSIndexPath *selectDeleteIndex, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.supplyTableView selectRowAtIndexPath:selectDeleteIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
                    }];
                }
                [self updateBottomDeleteCellView];
            }
            [self.supplyTableView footerEndRefreshing];
            
        }

    } failure:^(NSError *error) {

    }];
}


#pragma  mark - 初始化数据
- (void)initData {
    _state              = SupplyStateAll;//设置初始状态为全部
    self.page           = 1;//页面page从1开始
    self.supplyInfoMArr = [NSMutableArray array];
    _refreshMarr        = [[NSMutableArray alloc] init];
    _removeArray        = [[NSMutableArray alloc] init];
}

#pragma  mark - 初始化UI
- (void)initUI {
    //button bgview
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, Width, MENUVIEW_HEIGHT)];
    menuView.backgroundColor     = [UIColor whiteColor];
    menuView.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
    menuView.layer.shadowOpacity = 0.2;////阴影透明度，默认0
    menuView.layer.shadowOffset  = CGSizeMake(0, 3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    menuView.layer.shadowRadius  = 3;//阴影半径，默认3
    [self.view addSubview:menuView];
    self.menuView  = menuView;
    menuView.contentMode = UIViewContentModeScaleToFill;


    //button
    NSArray *titles = @[@"全部",@"已通过",@"已退回",@"已过期"];
    CGFloat padding = 0.0f;
    CGFloat split = Width / titles.count;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(padding, 5, split, 30)];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:titleLabColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(actionMenu:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        btn.titleLabel.font = SUPPLY_STATE_BUTTON_FONT;
        [menuView addSubview:btn];
        padding += split;
        if (i == 0) {
            _cuttentButton = btn;
            [btn setTitleColor:NavColor forState:UIControlStateNormal];
        }
    }
    //线
    _lineView = [[UIView alloc] init];
    _lineView.frame = CGRectMake(0, MENUVIEW_HEIGHT-3, split, 3);
    _lineView.backgroundColor = NavColor;
    [menuView addSubview:_lineView];

    //tableview
    self.supplyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(menuView.frame)+8, Width, Height-NAV_HEIGHT-MENUVIEW_HEIGHT-8) style:UITableViewStylePlain];
    self.supplyTableView.backgroundColor = [UIColor clearColor];
    self.supplyTableView.dataSource = self;
    self.supplyTableView.delegate   = self;
    [self.view addSubview:self.supplyTableView];
    //[ZIKFunction setExtraCellLineHidden:self.supplyTableView];
    self.supplyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.supplyTableView.allowsMultipleSelectionDuringEditing = YES;

    //添加长按手势
    _tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR)];
    [self.supplyTableView addGestureRecognizer:_tapDeleteGR];


    //底部刷新view（已通过状态下显示）
    _refreshCell = [ZIKMySupplyBottomRefreshTableViewCell cellWithTableView:nil];
    _refreshCell.count = 0;
    _refreshCell.frame = CGRectMake(0, Height-REFRESH_CELL_HEIGH, Width, REFRESH_CELL_HEIGH);
    [self.view addSubview:_refreshCell];
    [_refreshCell.refreshButton addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _refreshCell.hidden = YES;

    //底部删除view（过期状态下显示）
    _bottomcell = [ZIKBottomDeleteTableViewCell cellWithTableView:nil];
    _bottomcell.count = 0;
    _bottomcell.frame = CGRectMake(0, Height-REFRESH_CELL_HEIGH, Width, REFRESH_CELL_HEIGH);
    [self.view addSubview:_bottomcell];
    [_bottomcell.seleteImageButton addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomcell.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _bottomcell.hidden = YES;

}

#pragma mark - 长按触发事件
- (void)tapGR {
    if (self.supplyInfoMArr.count == 0) {
        return;
    }
    if (!self.supplyTableView.editing && self.state == SupplyStateThrough)
    {
         if (_refreshMarr.count > 0) {
            [_refreshMarr enumerateObjectsUsingBlock:^(ZIKSupplyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                model.isSelect = NO;
            }];
            [_refreshMarr removeAllObjects];
        }
        __weak typeof(self) weakSelf = self;//解决循环引用的问题

        if (self.supplyInfoMArr.count > 0) {
            [self.supplyInfoMArr enumerateObjectsUsingBlock:^(ZIKSupplyModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([myModel.shuaxin isEqualToString:@"0"]) {

                    weakSelf.supplyTableView.editing = YES;
                    _refreshCell.hidden = NO;
                    weakSelf.supplyTableView.frame = CGRectMake(0, self.supplyTableView.frame.origin.y, Width, Height-64-50-REFRESH_CELL_HEIGH);

                    [weakSelf.supplyTableView removeHeader];//编辑状态取消下拉刷新
                    *stop = YES;
                }
                else if ((idx == self.supplyInfoMArr.count -1) && [myModel.shuaxin isEqualToString:@"1"]) {
                    [ToastView showTopToast:@"暂时没有可以刷新的应用"];
                }
            }];
        }
     }
    else if (!self.supplyTableView.editing && self.state == SupplyStateNoThrough) {
        [self.supplyTableView removeHeader];//编辑状态取消下拉刷新
        self.supplyTableView.editing = YES;
        _bottomcell.hidden = NO;
        _bottomcell.isAllSelect = NO;
        self.supplyTableView.frame = CGRectMake(0, self.supplyTableView.frame.origin.y, Width, Height-64-50-REFRESH_CELL_HEIGH);
    }

}

#pragma mark - 底部刷新按钮点击事件
- (void)refreshBtnClick {
    if (_refreshMarr.count == 0) {
        [ToastView showTopToast:@"请选择刷新项"];
        return;
    }
    __weak __typeof(self) blockSelf = self;

    __block NSString *uidString = @"";
    [_refreshMarr enumerateObjectsUsingBlock:^(ZIKSupplyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        uidString = [uidString stringByAppendingString:[NSString stringWithFormat:@",%@",model.uid]];
    }];
    NSString *uids = [uidString substringFromIndex:1];
    [HTTPCLIENT sdsupplybuyrRefreshWithUid:uids Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 1) {
            [ToastView showToast:@"刷新成功" withOriginY:200 withSuperView:self.view];
            blockSelf.supplyTableView.editing = NO;
            blockSelf.supplyTableView.frame = CGRectMake(0, self.supplyTableView.frame.origin.y, Width, Height-64-50);
            _refreshCell.hidden = YES;
            blockSelf.page = 1;
            [blockSelf requestData];
        }
        else {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:200 withSuperView:self.view];
            return ;
        }
        _refreshCell.count = 0;
        if (_refreshMarr.count > 0) {
            [_refreshMarr removeAllObjects];
        }

    } failure:^(NSError *error) {

    }];
}

#pragma mark - 过期状态下——底部全选按钮点击事件
- (void)selectBtnClick {
    _bottomcell.isAllSelect ? (_bottomcell.isAllSelect = NO) : (_bottomcell.isAllSelect = YES);
    if (_bottomcell.isAllSelect) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        [self.supplyInfoMArr enumerateObjectsUsingBlock:^(ZIKSupplyModel *myModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [_removeArray addObject:myModel];
        }];
         NSMutableArray *tempMArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.supplyInfoMArr.count; i++) {
            [self.supplyTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [tempMArr addObject:[NSIndexPath indexPathForRow:0 inSection:i]];
        }
        _deleteIndexArr = (NSArray *)tempMArr;
     }
    else if (_bottomcell.isAllSelect == NO) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        _deleteIndexArr = nil;
        for (NSInteger i = 0; i < self.supplyInfoMArr.count; i++) {
            [self.supplyTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] animated:YES];
        }
    }
}

#pragma mark - 过期状态下——底部删除按钮点击事件
- (void)deleteButtonClick {
    if (_removeArray.count  == 0) {
        [ToastView showToast:@"请选择要删除的选项" withOriginY:200 withSuperView:self.view];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除所选内容？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert.tag = 300;
    alert.delegate = self;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%ld",(long)buttonIndex);
    if(alertView.tag == 300)//是否退出编辑
    {
        if (buttonIndex == 1) {
            __weak typeof(_removeArray) removeArr = _removeArray;
            __weak __typeof(self) blockSelf = self;

            __block NSString *uidString = @"";
            [_removeArray enumerateObjectsUsingBlock:^(ZIKSupplyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                uidString = [uidString stringByAppendingString:[NSString stringWithFormat:@",%@",model.uid]];
            }];
            NSString *uids = [uidString substringFromIndex:1];
            [HTTPCLIENT deleteMySupplyInfo:uids Success:^(id responseObject) {
                if ([responseObject[@"success"] integerValue] == 1) {

                    [removeArr enumerateObjectsUsingBlock:^(ZIKSupplyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([blockSelf.supplyInfoMArr containsObject:model]) {
                            [blockSelf.supplyInfoMArr removeObject:model];
                        }
                    }];
                    [blockSelf.supplyTableView reloadData];
                    if (blockSelf.supplyInfoMArr.count == 0) {
                        _bottomcell.hidden = YES;
                        self.supplyTableView.editing = NO;
                        self.supplyTableView.frame = CGRectMake(0, self.supplyTableView.frame.origin.y, Width, Height-64-50);
                        [self requestData];
                    }
                    if (_removeArray.count > 0) {
                        [_removeArray removeAllObjects];
                    }
                    if (_deleteIndexArr.count > 0) {
                        _deleteIndexArr = nil;
                    }
                    _bottomcell.count = 0;
                    [self updateBottomDeleteCellView];
                    [ToastView showToast:@"删除成功" withOriginY:200 withSuperView:self.view];
                }
                else {
                    [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"error"]] withOriginY:200 withSuperView:self.view];
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }
}


#pragma mark - 选择不同状态按钮事件
- (void)actionMenu:(UIButton *)button {
    if (self.supplyTableView.editing) {
        self.supplyTableView.editing = NO;
        _refreshCell.hidden = YES;
        _bottomcell.hidden = YES;
        self.supplyTableView.frame = CGRectMake(0, self.supplyTableView.frame.origin.y, Width, Height-64-50);
    }
    __weak typeof(self) weakSelf = self;//解决循环引用的问题


    if (_cuttentButton != button && !self.supplyTableView.isDecelerating) {
        [button setTitleColor:NavColor forState:UIControlStateNormal];
        [_cuttentButton setTitleColor:titleLabColor forState:UIControlStateNormal];
        _cuttentButton = button;
        [UIView animateWithDuration:0.3 animations:^{
            _lineView.frame = CGRectMake(button.frame.origin.x, _lineView.frame.origin.y, _lineView.frame.size.width, _lineView.frame.size.height);
        }];
        [self.supplyTableView addHeaderWithCallback:^{
            weakSelf.page = 1;
            [weakSelf requestMySupplyList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
        }];

        if (button.tag == 0) {
            self.state = SupplyStateAll;
        }
        else if (button.tag == 1) {
            self.state = SupplyStateThrough;
            _refreshCell.count = 0;
            if (_refreshMarr.count > 0) {
                [_refreshMarr removeAllObjects];
            }
        }
        else if (button.tag == 2) {
            self.state = SupplyStateOverdue;
        }
        else if (button.tag == 3) {
            self.state = SupplyStateNoThrough;
            _bottomcell.count = 0;
            if (_removeArray.count > 0) {
                [_removeArray removeAllObjects];
            }
        }
        if (self.supplyInfoMArr.count > 0) {
            [self.supplyInfoMArr removeAllObjects];
            [self.supplyTableView reloadData];
        }
        [self.supplyTableView headerBeginRefreshing];
    }
}

#pragma mark - 低内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置navgation
- (void)configNav {
    self.vcTitle = @"我的供应";
    self.rightBarBtnTitleString = @"发布";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        if (weakSelf.isCanPublish) {
            ZIKSupplyPublishVC *spVC = [[ZIKSupplyPublishVC alloc] init];
            [weakSelf.navigationController pushViewController:spVC animated:YES];
        }
        else {
            NuseryDetialViewController *ndvc = [[NuseryDetialViewController alloc] init];
            [weakSelf.navigationController pushViewController:ndvc animated:YES];
            [ToastView showTopToast:@"请先完善您的苗圃信息"];
        }
    };
}

#pragma mark - 发布限制
- (void)requestSupplyRestrict {
    HttpClient *httpClient=[HttpClient sharedClient];
    //供求发布限制
    [httpClient getSupplyRestrictWithToken:APPDELEGATE.userModel.access_token  withId:APPDELEGATE.userModel.access_id withClientId:nil withClientSecret:nil withDeviceId:nil withType:@"2" success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        if ( [dic[@"count"] integerValue] == 0 ) {// “count”: 1	--当数量大于0时，表示可发布；等于0时，不可发布
            self.isCanPublish = NO;
         }
        else {
            self.isCanPublish = YES;
        }
    } failure:^(NSError *error) {

    }];
}

#pragma mark - 可选方法实现
#pragma mark - 设置删除按钮标题
// 设置删除按钮标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

#pragma mark - 设置行是否可编辑
// 设置行是否可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.supplyTableView.editing && self.state == SupplyStateThrough) {
        ZIKSupplyModel *model = self.supplyInfoMArr[indexPath.section];
        if (!model.isCanRefresh) {
            return NO;
        }
    }
     return YES;
}

#pragma mark -  删除数据风格
// 删除数据风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"commitEditingStyle");
}

- (void)createEmptyUI {
    if (!_emptyUI) {
        _emptyUI  = [[UIView alloc] init];
        _emptyUI.frame = CGRectMake(0, 64, Width, 260);
        _emptyUI.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_emptyUI];

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(Width/2-50, 25, 100, 100);
        imageView.image = [UIImage imageNamed:@"我的供应（空）"];
        [_emptyUI addSubview:imageView];

        UILabel *label1 = [[UILabel alloc] init];
        label1.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame)+10, Width, 25);
        label1.text = @"您还没有发布任何的供应信息";
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor = detialLabColor;
        [_emptyUI addSubview:label1];

        UILabel *label2 = [[UILabel alloc] init];
        label2.frame = CGRectMake(0, CGRectGetMaxY(label1.frame), Width, label1.frame.size.height);
        label2.text = @"点击按钮发布";
        label2.textColor = detialLabColor;
        label2.textAlignment = NSTextAlignmentCenter;
        [_emptyUI addSubview:label2];

        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(Width/2-40, CGRectGetMaxY(label2.frame)+10, 80, 30);
        [button setTitleColor:detialLabColor forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4.0f;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [kLineColor CGColor];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];

        [button setTitle:@"发布供应" forState:UIControlStateNormal];
        [_emptyUI addSubview:button];
        [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)btnClick {
    if (self.isCanPublish) {//可以发布，进入发布界面
        ZIKSupplyPublishVC *spVC = [[ZIKSupplyPublishVC alloc] init];
        [self.navigationController pushViewController:spVC animated:YES];
    }
    else {//不可发布，进入苗圃信息界面完善
        NuseryDetialViewController *ndvc = [[NuseryDetialViewController alloc] init];
        [self.navigationController pushViewController:ndvc animated:YES];
        [ToastView showTopToast:@"请先完善您的苗圃信息"];
    }
}


@end
