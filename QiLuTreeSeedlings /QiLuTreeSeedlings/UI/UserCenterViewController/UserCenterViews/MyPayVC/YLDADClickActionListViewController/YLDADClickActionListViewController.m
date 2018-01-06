//
//  YLDADClickActionListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/27.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDADClickActionListViewController.h"
#import "YLDADClickDetialViewController.h"
#import "YLDADClickCollectionViewCell.h"
#import "YLDSadvertisementModel.h"
#import "KMJRefresh.h"
#import "UIImageView+AFNetworking.h"
#import "ZIKMyShopViewController.h"
@interface YLDADClickActionListViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,assign)NSInteger page;
@end

@implementation YLDADClickActionListViewController
   // 注意const的位置
static NSString *const cellId = @"YLDADClickCollectionViewCell";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"我的广告";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.page=1;
    self.dataAry=[NSMutableArray array];
    [self loadCollectionView];
   
    [_collectionView headerBeginRefreshing];
    // Do any additional setup after loading the view.
}
-(void)getDataAryWithPage:(NSString *)page
{
//    HttpClient *tt=[HttpClient sharedADClient];
    [HTTPADCLIENT myADListWithUid:APPDELEGATE.userModel.access_id WithStart:nil WithEnd:nil WithPage_size:@"15" WithPage_index:page Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if ([page isEqualToString:@"1"]) {
                [self.dataAry removeAllObjects];
            }
            NSArray *ary=responseObject[@"result"];
            if (ary.count==0) {
                if ([page isEqualToString:@"1"]) {
                    [ToastView showTopToast:@"暂无广告信息"];
                }else{
                    [ToastView showTopToast:@"暂无更多广告信息"];
                }
            }else{
                NSArray *ssAry=[YLDSadvertisementModel lzlAryWithAry:ary];
                [self.dataAry addObjectsFromArray:ssAry];
                [_collectionView reloadData];
            }
        }
        [_collectionView headerEndRefreshing];
        [_collectionView footerEndRefreshing];
    } failure:^(NSError *error) {
        [_collectionView headerEndRefreshing];
        [_collectionView footerEndRefreshing];
    }];
}
- (void)loadCollectionView {
     // 自定义的布局对象
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize=CGSizeMake(kWidth, 0.05);
    

    flowLayout.itemSize =CGSizeMake((kWidth-30)/2,((kWidth-30)/2.f)/1.568+40);
   
    flowLayout.minimumLineSpacing=10;
    flowLayout.minimumInteritemSpacing=10;
    flowLayout.sectionInset=UIEdgeInsetsMake(10,10,10,10);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical=YES;
    // 注册cell、sectionHeader、sectionFooter
    
    [_collectionView registerClass:[YLDADClickCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId]; [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    [self.view addSubview:_collectionView];
    
    __weak typeof(self)weakself=self;
    [_collectionView addHeaderWithCallback:^{
        weakself.page=1;
        [weakself getDataAryWithPage:[NSString stringWithFormat:@"%ld",weakself.page]];
    }];
    [_collectionView addFooterWithCallback:^{
        weakself.page+=1;
        [weakself getDataAryWithPage:[NSString stringWithFormat:@"%ld",weakself.page]];
    }];
}



#pragma mark - UICollectionViewDataSource  
// 指定Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
// 指定section中的collectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataAry.count;
}
// 配置section中的collectionViewCell的显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib = [UINib nibWithNibName:@"YLDADClickCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:cellId];
 
    YLDADClickCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                                        forIndexPath:indexPath];
    cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    cell.layer.shadowRadius = 4.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    YLDSadvertisementModel *model=self.dataAry[indexPath.row];
    
    [cell.imageVV setImageWithURL:[NSURL URLWithString:[model.imageAry firstObject]] placeholderImage:[UIImage imageNamed:@"MoRentuLong"]];
    cell.titleLab.text=model.name;
    [cell.timeLab setText:[NSString stringWithFormat:@"%@ 发布",model.timeStr]];
    return cell;
}
#pragma mark - UICollectionViewDelegate  
// 允许选中时，高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 高亮完成后回调
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
// 由高亮转成非高亮完成时的回调
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
}
// 设置是否允许选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{  return YES;
}
// 设置是否允许取消选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 选中操作
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YLDSadvertisementModel *model=self.dataAry[indexPath.row];
    YLDADClickDetialViewController *vc=[[YLDADClickDetialViewController alloc]init];
    vc.uid=model.uid;
    vc.imageUrl=[model.imageAry firstObject];
    [self.navigationController pushViewController:vc animated:YES];
}
// 取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
