//
//  ZIKHeZuoMiaoQiViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKHeZuoMiaoQiViewController.h"
#import "HttpClient.h"
#import "YYModel.h"//类型转换
#import "ZIKFunction.h"
#import "ZIKHeZuoMiaoQiModel.h"
#import "ZIKOrderSingleTableViewCell.h"
#import "ZIKHeZuoMiaoQiTableViewCell.h"
#import "ZIKHeZuoMiaoQiHeaderFooterView.h"

#import "ZIKMiaoQiDetailTableViewController.h"
#import "ZIKMiaoQiListViewController.h"
#import "AdvertView.h"

#import "BigImageViewShowView.h"
#import "YLDSadvertisementModel.h"
#import "ZIKMyShopViewController.h"
#import "YLDSADViewController.h"
static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@interface ZIKHeZuoMiaoQiViewController ()<UITableViewDelegate,UITableViewDataSource,AdvertDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mqTableView;

@property (nonatomic, strong) NSMutableArray *fiveStarMArr;
@property (nonatomic, strong) NSMutableArray *fourStarMArr;
@property (nonatomic, strong) NSMutableArray *threeStarMArr;
@property (nonatomic, strong) NSArray *luoboAry;

@property (nonatomic,strong) BigImageViewShowView *bigImageViewShowView;


@end

@implementation ZIKHeZuoMiaoQiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initUI];
    [self requestData];
}

- (void)initData {
    self.fiveStarMArr  = [NSMutableArray array];
    self.fourStarMArr  = [NSMutableArray array];
    self.threeStarMArr = [NSMutableArray array];
    self.bigImageViewShowView =[[BigImageViewShowView alloc]initWithNomalImageAry:@[@"bangde1.jpg",@"bangde2.jpg",@"bangde3.jpg",@"bangde4.jpg",@"bangde5.png"]];

}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.leftBarBtnTitleString = @"点花木";
    self.leftBarBtnBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKMiaoQiBackHome" object:nil];
    };

    self.mqTableView.delegate = self;
    self.mqTableView.dataSource = self;
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ZIKHeZuoMiaoQiHeaderFooterView" bundle:nil];
    [self.mqTableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];

    [ZIKFunction setExtraCellLineHidden:self.mqTableView];
}

- (void)requestData {
    [HTTPCLIENT cooperationCompanyIndexSuccess:^(id responseObject) {
        //CLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        NSDictionary *resultDic = responseObject[@"result"];
        NSDictionary *companyInfos = resultDic[@"companyInfos"];
        NSArray *fiveArray  = companyInfos[@"five"];
        NSArray *fourArray  = companyInfos[@"four"];
        NSArray *threeArray = companyInfos[@"three"];
        self.luoboAry =[YLDSadvertisementModel aryWithAry:resultDic[@"carousels"]];

        if (fiveArray.count>0) {
            [fiveArray enumerateObjectsUsingBlock:^(NSDictionary *fiveDic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKHeZuoMiaoQiModel *fiveModel = [ZIKHeZuoMiaoQiModel yy_modelWithDictionary:fiveDic];
                [self.fiveStarMArr addObject:fiveModel];
            }];
        }
        if (fourArray.count > 0) {
            [fourArray enumerateObjectsUsingBlock:^(NSDictionary *fourDic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKHeZuoMiaoQiModel *fourModel = [ZIKHeZuoMiaoQiModel yy_modelWithDictionary:fourDic];
                [self.fourStarMArr addObject:fourModel];
            }];
        }
        if (threeArray.count > 0) {
            [threeArray enumerateObjectsUsingBlock:^(NSDictionary *threeDic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKHeZuoMiaoQiModel *threeModel = [ZIKHeZuoMiaoQiModel yy_modelWithDictionary:threeDic];
                [self.threeStarMArr addObject:threeModel];
            }];
        }
        [self.mqTableView reloadData];

    } failure:^(NSError *error) {
        ;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.fiveStarMArr.count;
    } else if (section == 2) {
        return self.fourStarMArr.count;
    } else if (section == 3) {
        return self.threeStarMArr.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section  == 0) {
        return 0.01f;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0.368*kWidth;
    }
    return 88;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        ZIKHeZuoMiaoQiHeaderFooterView *headerView = [self.mqTableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
        headerView.starNum = 6-section;
        headerView.indexPath = section;
        //按钮点击展开隐藏

        __weak typeof(self) weakSelf = self;//解决循环引用的问题

        headerView.moreButtonBlock = ^(NSInteger indexPath){
            ZIKMiaoQiListViewController *listVC = [[ZIKMiaoQiListViewController alloc] initWithNibName:@"ZIKMiaoQiListViewController" bundle:nil];
            listVC.starLevel = indexPath;
            listVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:listVC animated:YES];
        };

        return headerView;

    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0)
    {
        if (indexPath.row==0) {
            AdvertView *adView=[[AdvertView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 0.368*kWidth)];
            adView.delegate=self;
            [adView setAdInfoWithAry:self.luoboAry];
            [adView adStart];
            return adView;
            
        }
    }
    else {
        ZIKHeZuoMiaoQiTableViewCell *cell = [ZIKHeZuoMiaoQiTableViewCell cellWithTableView:tableView];
        ZIKHeZuoMiaoQiModel *model = nil;
        if (indexPath.section == 1) {
            model = self.fiveStarMArr[indexPath.row];
        } else if (indexPath.section == 2) {
            model = self.fourStarMArr[indexPath.row];
        } else if (indexPath.section == 3) {
            model = self.threeStarMArr[indexPath.row];
        }
        cell.starNum = 6-indexPath.section;
        [cell configureCell:model];

        cell.indexPath = indexPath;
        __weak typeof(self) weakSelf = self;
        cell.phoneButtonBlock = ^(NSIndexPath *indexPath){
            // NSLog(@"拨打电话");
            NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",model.phone];
            //NSLog(@"%@",str);
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [weakSelf.view addSubview:callWebview];

        };

        return cell;
    };
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKHeZuoMiaoQiModel *model = nil;
    if (indexPath.section == 1) {
        model = self.fiveStarMArr[indexPath.row];
    } else if (indexPath.section == 2) {
        model = self.fourStarMArr[indexPath.row];
    } else if (indexPath.section == 3) {
        model = self.threeStarMArr[indexPath.row];
    }
    ZIKMiaoQiDetailTableViewController *mqdVC = [[ZIKMiaoQiDetailTableViewController alloc]initWithNibName:@"ZIKMiaoQiDetailTableViewController" bundle:nil];
    mqdVC.uid = model.uid;
    mqdVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mqdVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//广告页面点击
-(void)advertPush:(NSInteger)index
{
    if (index<self.luoboAry.count) {
        YLDSadvertisementModel *model = self.luoboAry[index];
        if (model.adType==0) {
            YLDSADViewController *advc=[[YLDSADViewController alloc]init];
            advc.urlString=model.content;
            advc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:advc animated:YES];
        }else if (model.adType==1)
        {
            YLDSADViewController *advc=[[YLDSADViewController alloc]init];
            advc.urlString=model.link;
            advc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:advc animated:YES];
        }else if (model.adType==2)
        {
            ZIKMyShopViewController *shopVC = [[ZIKMyShopViewController alloc] init];
            shopVC.memberUid = model.shop;
            shopVC.type = 1;
            shopVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shopVC animated:YES];
        }
    }
}
@end
