//
//  ZIKMyHonorViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMyHonorViewController.h"
#import "ZIKMyHonorCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "YLDZiZhiAddViewController.h"
#import "YYModel.h"//类型转换
#import "KMJRefresh.h"//MJ刷新
#import "ZIKStationHonorListModel.h"
#import "ZIKAddHonorViewController.h"

#import "GCZZModel.h"

#import "ZIKStationShowHonorView.h"//
#import "ZIKBaseCertificateAdapter.h"
#import "ZIKCertificateAdapter.h"

NSString *kHonorCellID = @"honorcellID";
static NSString *uid = nil;

@interface ZIKMyHonorViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)    NSMutableArray     *honorData;

@property (weak, nonatomic) IBOutlet UICollectionView *honorCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *honorCollectionViewFlowLayout;

@property (nonatomic, assign) BOOL isEditState;
@property (nonatomic, assign) NSInteger      page;            //页数从1开始

@property (nonatomic, strong) ZIKStationShowHonorView *showHonorView;
@end

@implementation ZIKMyHonorViewController
{
    UILongPressGestureRecognizer *_tapDeleteGR;//长按手势
}

-(void)backBtnAction:(UIButton *)sender
{
    if (self.isEditState) {
        self.isEditState = NO;
        [self.honorCollectionView reloadData];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BGColor;
    self.page = 1;
    if (self.type == TypeHonor || (self.type == TypeMiaoQiHonor && [self.memberUid isEqualToString:APPDELEGATE.userModel.access_id])) {
        self.vcTitle = @"我的荣誉";
    }
    else if (self.type == TypeQualification) {
        self.vcTitle = @"我的资质";
        [self.navBackView setBackgroundColor:NavSColor];
    }
    if (self.type == TypeMyJPGYSHonorOther && [self.memberUid isEqualToString:APPDELEGATE.userModel.access_id]) {
        self.vcTitle = @"我的荣誉";
        [self.navBackView setBackgroundColor:NavSColor];
    }
    if (self.type == TypeHonorOther || (self.type == TypeMiaoQiHonor && ![self.memberUid isEqualToString:APPDELEGATE.userModel.access_id])|| self.type == TypeJPGYSHonorOther) {
        self.vcTitle = @"荣誉";
    }
    else{
        if (self.miaoqiOther) {

        }
        else
        {

            self.rightBarBtnTitleString = @"添加";
            __weak typeof(self) weakSelf = self;//解决循环引用的问题
            self.rightBarBtnBlock = ^{

                if (self.type == TypeQualification) {
                    YLDZiZhiAddViewController *vcss=[[YLDZiZhiAddViewController alloc] initWithType:2];
                    [weakSelf.navigationController pushViewController:vcss animated:YES];
                    return ;
                }
                if (self.type == TypeHonor) {
                    ZIKAddHonorViewController *addVC = [[ZIKAddHonorViewController alloc] initWithNibName:@"ZIKAddHonorViewController" bundle:nil];
                    addVC.workstationUid = weakSelf.workstationUid;
                    [weakSelf.navigationController pushViewController:addVC animated:YES];
                }
                if (self.type == TypeMiaoQiHonor) {
                    ZIKAddHonorViewController *addVC = [[ZIKAddHonorViewController alloc] initWithNibName:@"ZIKAddHonorViewController" bundle:nil];
                    addVC.miaoqiUid = weakSelf.memberUid;
                    [weakSelf.navigationController pushViewController:addVC animated:YES];
                }
                if (self.type == TypeMyJPGYSHonorOther) {
                    ZIKAddHonorViewController *addVC = [[ZIKAddHonorViewController alloc] initWithNibName:@"ZIKAddHonorViewController" bundle:nil];
                    addVC.type = 4;
                    [weakSelf.navigationController pushViewController:addVC animated:YES];
                }
            };
            //添加长按手势
            _tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR)];
            [self.honorCollectionView addGestureRecognizer:_tapDeleteGR];
        }
        
    }
    
    if (kWidth != 375) {
        CGFloat itemWidth  = (kWidth-10)/2;
        CGFloat itemHeight =  itemWidth * 8 / 9;
        _honorCollectionViewFlowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    }

    self.honorCollectionView.delegate   = self;
    self.honorCollectionView.dataSource = self;
    self.honorCollectionView.alwaysBounceVertical = YES;
    self.isEditState = NO;
   

    self.honorData = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.isEditState = NO;
    self.page = 1;

    if (self.type ==TypeQualification)
    {
        [self requestCompanyData];
    }

    if (self.type == TypeHonor) {
        [self requestData];
    }
    if (self.type == TypeHonorOther) {
        [self requestOtherWorkStaData];
    }
    if (self.type == TypeMiaoQiHonor) {
        [self requestOtherHonorData];
    }
    if (self.type == TypeJPGYSHonorOther||self.type == TypeMyJPGYSHonorOther) {
        [self requestOtherJPGYSRRListHonorData];
    }
    
}

#pragma mark - 请求自己工作站荣誉数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.honorCollectionView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestHonorListData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.honorCollectionView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestHonorListData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.honorCollectionView headerBeginRefreshing];
}

#pragma mark - 请求工程公司资质数据
- (void)requestCompanyData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.honorCollectionView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestCompanyZZListData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.honorCollectionView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestCompanyZZListData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.honorCollectionView headerBeginRefreshing];
}
#pragma mark - 请求其它工作站荣誉数据
- (void)requestOtherWorkStaData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.honorCollectionView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestHonorListData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];

    }];
    [self.honorCollectionView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestHonorListData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.honorCollectionView headerBeginRefreshing];
}
#pragma mark - 请求其他苗企荣誉数据
- (void)requestOtherHonorData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.honorCollectionView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestMiaoQiHonorListData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.honorCollectionView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestMiaoQiHonorListData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.honorCollectionView headerBeginRefreshing];

}
#pragma mark - 请求其他金牌供应商荣誉数据
- (void)requestOtherJPGYSRRListHonorData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.honorCollectionView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestOtherJPGYSRRListData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.honorCollectionView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestOtherJPGYSRRListData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.honorCollectionView headerBeginRefreshing];
    
}
-(void)requestOtherJPGYSRRListData:(NSString *)pageNumber
{
    [self.honorCollectionView headerEndRefreshing];
    [HTTPCLIENT goldSupplierHonorListWithMemberUid:_memberUid withPage:pageNumber withPageSize:@"10" Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else if ([responseObject[@"success"] integerValue] == 1) {
            NSArray *array  = responseObject[@"result"][@"list"];
            if (array.count == 0 && self.page == 1) {
                [ToastView showToast:@"暂无数据" withOriginY:Width/2 withSuperView:self.view];
                if (self.honorData.count > 0) {
                    [self.honorData removeAllObjects];
                }
                [self.honorCollectionView footerEndRefreshing];
                [self.honorCollectionView reloadData];
                return ;
            }
            else if (array.count == 0 && self.page > 1) {
                self.page--;
                [self.honorCollectionView footerEndRefreshing];
                //没有更多数据了
                [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
                return;
            }
            else {
                if (self.page == 1) {
                    [self.honorData removeAllObjects];
                }
                [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZIKStationHonorListModel *honorListModel = [ZIKStationHonorListModel yy_modelWithDictionary:dic];
                    [self.honorData addObject:honorListModel];
                }];
                [self.honorCollectionView reloadData];
                [self.honorCollectionView footerEndRefreshing];
                
            }
        }

    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 请求自己工程公司数据
- (void)requestCompanyZZListData:(NSString *)pageNumber
{
   [self.honorCollectionView headerEndRefreshing];
    [HTTPCLIENT GCZXwodezizhiWithuid:APPDELEGATE.GCGSModel.uid WithpageNumber:pageNumber WithpageSize:@"10" Success:^(id responseObject) {
        //CLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else if ([responseObject[@"success"] integerValue] == 1) {
            NSArray *array  = responseObject[@"result"][@"list"];
            if (array.count == 0 && self.page == 1) {
                [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
                if (self.honorData.count > 0) {
                    [self.honorData removeAllObjects];
                }
                [self.honorCollectionView footerEndRefreshing];
                [self.honorCollectionView reloadData];
                return ;
            }
            else if (array.count == 0 && self.page > 1) {
                self.page--;
                [self.honorCollectionView footerEndRefreshing];
                //没有更多数据了
                [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
                return;
            }
            else {
                if (self.page == 1) {
                    [self.honorData removeAllObjects];
                }
                [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    GCZZModel *ZZModel = [GCZZModel GCZZModelWithDic:dic];
                    [self.honorData addObject:ZZModel];
                  
                }];
                [self.honorCollectionView reloadData];
            
                [self.honorCollectionView footerEndRefreshing];
                
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 请求自己工作站荣誉数据
- (void)requestHonorListData:(NSString *)pageNumber {
    [self.honorCollectionView headerEndRefreshing];
    [HTTPCLIENT stationHonorListWithWorkstationUid:self.workstationUid pageNumber:pageNumber pageSize:@"10" Success:^(id responseObject) {
        //CLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else if ([responseObject[@"success"] integerValue] == 1) {
            NSArray *array  = responseObject[@"result"][@"list"];
            if (array.count == 0 && self.page == 1) {
                [ToastView showToast:@"暂无数据" withOriginY:Width/2 withSuperView:self.view];
                 if (self.honorData.count > 0) {
                    [self.honorData removeAllObjects];
                }
                [self.honorCollectionView footerEndRefreshing];
                [self.honorCollectionView reloadData];
                return ;
            }
            else if (array.count == 0 && self.page > 1) {
                 self.page--;
                [self.honorCollectionView footerEndRefreshing];
                //没有更多数据了
                [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
                return;
            }
            else {
                 if (self.page == 1) {
                    [self.honorData removeAllObjects];
                }
                [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZIKStationHonorListModel *honorListModel = [ZIKStationHonorListModel yy_modelWithDictionary:dic];
                    [self.honorData addObject:honorListModel];
                }];
                [self.honorCollectionView reloadData];
                [self.honorCollectionView footerEndRefreshing];
                
            }
        }
    } failure:^(NSError *error) {
    }];
}

- (void)requestMiaoQiHonorListData:(NSString *)pageNumber {
    [self.honorCollectionView headerEndRefreshing];
    [HTTPCLIENT cooperationCompanyHonorsWithMemberUid:self.memberUid type:nil page:pageNumber pageSize:@"10" Success:^(id responseObject) {
        CLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else if ([responseObject[@"success"] integerValue] == 1) {
            NSArray *array  = responseObject[@"result"][@"list"];
            if (array.count == 0 && self.page == 1) {
                [ToastView showToast:@"暂无数据" withOriginY:Width/2 withSuperView:self.view];
                if (self.honorData.count > 0) {
                    [self.honorData removeAllObjects];
                }
                [self.honorCollectionView footerEndRefreshing];
                [self.honorCollectionView reloadData];
                return ;
            }
            else if (array.count == 0 && self.page > 1) {
                self.page--;
                [self.honorCollectionView footerEndRefreshing];
                //没有更多数据了
                [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
                return;
            }
            else {
                if (self.page == 1) {
                    [self.honorData removeAllObjects];
                }
                [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZIKStationHonorListModel *honorListModel = [ZIKStationHonorListModel yy_modelWithDictionary:dic];
                    [self.honorData addObject:honorListModel];
                }];
                [self.honorCollectionView reloadData];
                [self.honorCollectionView footerEndRefreshing];

            }
        }
    } failure:^(NSError *error) {
    }];

}

- (void)tapGR {
    self.isEditState = YES;
    [self.honorCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return self.honorData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UINib *nib = [UINib nibWithNibName:@"ZIKMyHonorCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [cv registerNib:nib forCellWithReuseIdentifier:kHonorCellID];
    ZIKMyHonorCollectionViewCell * cell = [cv dequeueReusableCellWithReuseIdentifier:kHonorCellID
                                                                        forIndexPath:indexPath];
    cell.isEditState = self.isEditState;
    cell.indexPath = indexPath;
    if (self.honorData.count > 0) {

        if (self.type == TypeMiaoQiHonor) {
            __block  ZIKStationHonorListModel  *model = _honorData[indexPath.row];
            ZIKBaseCertificateAdapter *modelAdapter = [[ZIKCertificateAdapter alloc] initWithData:model];
            [cell loadData:modelAdapter];
            cell.type = model.type;//赋值type
            __weak typeof(self) weakSelf = self;//解决循环引用的问题
            cell.editButtonBlock = ^(NSIndexPath *indexPath) {
                ZIKAddHonorViewController *addhonorVC = [[ZIKAddHonorViewController alloc] initWithNibName:@"ZIKAddHonorViewController" bundle:nil];
                addhonorVC.miaoqiUid   = weakSelf.memberUid;
                addhonorVC.memberUid = model.uid;
                addhonorVC.miaoqiModel = model;
                [weakSelf.navigationController pushViewController:addhonorVC animated:YES];
            };
            cell.deleteButtonBlock = ^(NSIndexPath *indexPath) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除提示" message:@"确定删除所选内容？" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                alert.tag = 300;
                alert.delegate = weakSelf;
                //                [weakSelf deleteRequest:model.uid];
                uid = model.uid;
            };

        }
        else if (self.type==TypeHonor) {
            __block  ZIKStationHonorListModel  *model = _honorData[indexPath.row];
            ZIKBaseCertificateAdapter *modelAdapter = [[ZIKCertificateAdapter alloc] initWithData:model];
            [cell loadData:modelAdapter];
            cell.type = model.type;//赋值type

            __weak typeof(self) weakSelf = self;//解决循环引用的问题
            cell.editButtonBlock = ^(NSIndexPath *indexPath) {
                ZIKAddHonorViewController *addhonorVC = [[ZIKAddHonorViewController alloc] initWithNibName:@"ZIKAddHonorViewController" bundle:nil];
                addhonorVC.workstationUid = weakSelf.workstationUid;
                addhonorVC.uid = model.uid;
                addhonorVC.miaoqiModel =model;
                [weakSelf.navigationController pushViewController:addhonorVC animated:YES];
            };
            cell.deleteButtonBlock = ^(NSIndexPath *indexPath) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除提示" message:@"确定删除所选内容？" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                alert.tag = 300;
                alert.delegate = weakSelf;
//                [weakSelf deleteRequest:model.uid];
                uid = model.uid;
            };

        }else if (self.type==TypeMyJPGYSHonorOther) {
            __block  ZIKStationHonorListModel  *model = _honorData[indexPath.row];
            ZIKBaseCertificateAdapter *modelAdapter = [[ZIKCertificateAdapter alloc] initWithData:model];
            [cell loadData:modelAdapter];
            cell.type = model.type;//赋值type

            __weak typeof(self) weakSelf = self;//解决循环引用的问题
            cell.editButtonBlock = ^(NSIndexPath *indexPath) {
                ZIKAddHonorViewController *addhonorVC = [[ZIKAddHonorViewController alloc] initWithNibName:@"ZIKAddHonorViewController" bundle:nil];
                addhonorVC.jinpaiUid =model.uid;
                addhonorVC.type=5;
                addhonorVC.miaoqiModel=model;
                [weakSelf.navigationController pushViewController:addhonorVC animated:YES];
            };
            cell.deleteButtonBlock = ^(NSIndexPath *indexPath) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除提示" message:@"确定删除所选内容？" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                alert.tag = 300;
                alert.delegate = weakSelf;
                uid = model.uid;
            };
            
        }else{
            __block  GCZZModel  *model = _honorData[indexPath.row];
            ZIKBaseCertificateAdapter *modelAdapter = [[ZIKCertificateAdapter alloc] initWithData:model];
            [cell loadData:modelAdapter];
            cell.type = model.type;
           // cell.ZZmodel = model;
            __weak typeof(self) weakSelf = self;//解决循环引用的问题
            cell.editButtonBlock = ^(NSIndexPath *indexPath) {
                YLDZiZhiAddViewController *addhonorVC = [[YLDZiZhiAddViewController alloc] initWithModel:model andType:2];
                [weakSelf.navigationController pushViewController:addhonorVC animated:YES];
            };
            cell.deleteButtonBlock = ^(NSIndexPath *indexPath) {
//                [weakSelf deleteRequest:model.uid];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除提示" message:@"确定删除所选内容？" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                alert.tag = 300;
                alert.delegate = weakSelf;
                //                [weakSelf deleteRequest:model.uid];
                uid = model.uid;

            };

        }

    }
    return cell;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.showHonorView) {
        self.showHonorView = [ZIKStationShowHonorView instanceShowHonorView];
        self.showHonorView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
    }
    if (self.type == TypeHonor||self.type == TypeHonorOther || self.type == TypeMiaoQiHonor||self.type == TypeMyJPGYSHonorOther||self.type == TypeJPGYSHonorOther) {
        ZIKStationHonorListModel  *model = _honorData[indexPath.row];
        ZIKBaseCertificateAdapter *modelAdapter = [[ZIKCertificateAdapter alloc] initWithData:model];
        [self.showHonorView loadData:modelAdapter];
    } else if (self.type == TypeQualification) {
        GCZZModel *ZZModel = _honorData[indexPath.row];
        ZIKBaseCertificateAdapter *modelAdapter = [[ZIKCertificateAdapter alloc] initWithData:ZZModel];
        [self.showHonorView loadData:modelAdapter];
    }

    [self.view addSubview:self.showHonorView];
    [UIView animateWithDuration:.3 animations:^{
        self.showHonorView.frame = CGRectMake(0, 0, kWidth, kHeight);
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 300)//是否退出编辑
    {
        if (buttonIndex == 1) {
            [self deleteRequest:uid];
        }
    }

}

- (void)deleteRequest:(NSString *)uid {
    if (self.type == TypeMiaoQiHonor) {
        [HTTPCLIENT cooperationCompanyHonorDeleteWithUid:uid Success:^(id responseObject) {
            if ([responseObject[@"success"] integerValue] == 0) {
                [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                return ;
            }
            [ToastView showTopToast:@"删除成功"];
            self.isEditState = NO;
            self.page = 1;
            [self requestMiaoQiHonorListData:[NSString stringWithFormat:@"%ld",(long)self.page]];
        } failure:^(NSError *error) {
            ;
        }];
    }
   else if (self.type == TypeHonor)
    {
        [HTTPCLIENT stationHonorDeleteWithUid:uid Success:^(id responseObject) {
            if ([responseObject[@"success"] integerValue] == 0) {
                [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                return ;
            }
            [ToastView showTopToast:@"删除成功"];
            self.isEditState = NO;
            self.page = 1;
            [self requestHonorListData:[NSString stringWithFormat:@"%ld",(long)self.page]];
        } failure:^(NSError *error) {
            ;
        }];
    }else if (self.type == TypeMyJPGYSHonorOther)
    {
        [HTTPCLIENT deletegoldSupplierHonordetialUid:uid Success:^(id responseObject) {
            if ([responseObject[@"success"] integerValue] == 0) {
                [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                return ;
            }
            [ToastView showTopToast:@"删除成功"];
            self.isEditState = NO;
            self.page = 1;
            [self requestOtherJPGYSRRListData:[NSString stringWithFormat:@"%ld",(long)self.page]];
        } failure:^(NSError *error) {
            ;
        }];
    }else{
        [HTTPCLIENT GCZXDeleteRongYuWithuid:uid Success:^(id responseObject) {
            if ([responseObject[@"success"] integerValue] == 0) {
                [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                return ;
            }
            [ToastView showTopToast:@"删除成功"];
            self.isEditState = NO;
            self.page = 1;
            [self requestCompanyZZListData:[NSString stringWithFormat:@"%ld",(long)self.page]];
        } failure:^(NSError *error) {
            
        }];
    }
}
@end
