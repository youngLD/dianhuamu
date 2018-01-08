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



        self.vcTitle = @"我的资质";
        [self.navBackView setBackgroundColor:NavSColor];
    


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
@end
