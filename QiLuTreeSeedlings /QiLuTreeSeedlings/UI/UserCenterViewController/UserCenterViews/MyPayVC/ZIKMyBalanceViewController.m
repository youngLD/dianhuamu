//
//  ZIKMyBalanceViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/30.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKMyBalanceViewController.h"
#import "ZIKMyBalanceFirstTableViewCell.h"
#import "ZIKPayViewController.h"
#import "ZIKPayRecordViewController.h"
#import "YLDSUnbalanceViewController.h"
@interface ZIKMyBalanceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray     *titlesArray;
@property (nonatomic, strong) UITableView *myTalbeView;
@property (nonatomic, strong) NSString *moneyPrice;

@end

@implementation ZIKMyBalanceViewController
@synthesize myTalbeView;
@synthesize titlesArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"我的余额";
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self getprice];
}

- (void)getprice {
    [HTTPCLIENT getAmountInfo:nil Success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 1) {
            self.moneyPrice = [responseObject[@"result"] objectForKey:@"money"];
            APPDELEGATE.userModel.balance = self.moneyPrice;

            [self.myTalbeView reloadData];
        }
        else {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:250 withSuperView:self.view];
        }

    } failure:^(NSError *error) {

    }];
}

- (void)initUI {
    myTalbeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStylePlain];
    myTalbeView.delegate   = self;
    myTalbeView.dataSource = self;
    [self.view addSubview:myTalbeView];
    myTalbeView.scrollEnabled  = NO; //设置tableview 不能滚动
    myTalbeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [ZIKFunction setExtraCellLineHidden:myTalbeView];
    __weak typeof(self) weakSelf = self;
    self.rightBarBtnBlock = ^{
        [weakSelf mingxiBtnAction];
    };
    [myTalbeView setBackgroundColor:BGColor];
    self.rightBarBtnTitleString=@"明细";
    [self.view setBackgroundColor:BGColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0) {
        
        ZIKMyBalanceFirstTableViewCell *firstCell = [ZIKMyBalanceFirstTableViewCell cellWithTableView:tableView];
        if (self.moneyPrice) {
            [firstCell configureCell:self.moneyPrice];
        }
        [firstCell.keyongBtn addTarget:self action:@selector(mingxiBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [firstCell.bukeyongBtn addTarget:self action:@selector(bukeyongyueAction) forControlEvents:UIControlEventTouchUpInside];
        firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return firstCell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)mingxiBtnAction
{
    ZIKPayRecordViewController *payRecordVC = [[ZIKPayRecordViewController alloc] init];
    [self.navigationController pushViewController:payRecordVC animated:YES];
}
-(void)bukeyongyueAction
{
    if (APPDELEGATE.userModel.creditMargin>0) {
        YLDSUnbalanceViewController *vc=[[YLDSUnbalanceViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 64;
    }
    else{
        return 0.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = self.view.backgroundColor;
    if (0 == section)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [footView addSubview:btn];
        btn.frame = CGRectMake(40, 10, Width-80, 44);
        [btn setBackgroundColor:yellowButtonColor];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn setTitle:@"在线充值" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn addTarget:self action:@selector(sureButtonPress) forControlEvents:UIControlEventTouchUpInside];
    }

    return footView;
 
}

- (void)sureButtonPress {
    ZIKPayViewController *payVC  = [[ZIKPayViewController alloc] init];
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
