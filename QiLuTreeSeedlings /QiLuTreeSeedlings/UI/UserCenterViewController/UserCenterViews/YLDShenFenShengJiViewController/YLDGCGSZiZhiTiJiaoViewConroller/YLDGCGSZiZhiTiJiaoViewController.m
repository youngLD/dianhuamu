 //
//  YLDGCGSZiZhiTiJiaoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/23.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGCGSZiZhiTiJiaoViewController.h"
#import "ZIKMyHonorCollectionViewCell.h"
#import "YLDZiZhiAddViewController.h"
#import "UIImageView+AFNetworking.h"
#import "JSONKit.h"
#import "HttpClient.h"

@interface YLDGCGSZiZhiTiJiaoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YLDZiZhiAddDelegate>
@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *honorData;
@property (nonatomic,copy)NSString *kHonorCellID;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)NSString *uid;
@property (nonatomic,assign) BOOL isEditState;
@property (nonatomic,copy)NSString *roleApplyAuditId;
@end

@implementation YLDGCGSZiZhiTiJiaoViewController
{
    UILongPressGestureRecognizer *_tapDeleteGR;//长按手势
}
@synthesize kHonorCellID;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isEditState=NO;
    [self.collectionView reloadData];
}
-(id)initWithUid:(NSString *)uid
{
    self=[super init];
    if (self) {
        self.uid=uid;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"工程公司认证";
    self.honorData=[NSMutableArray array];

    
    kHonorCellID= @"honorcellID";
    static NSString *const HeaderIdentifier = @"HeaderIdentifier";
//    self.headerView=[self creatHeaderView];
    self.rightBarBtnTitleString=@"添加";
    self.rightBarBtnTitleColor=NavColor;
    __weak typeof(self) weakSelf=self;
    self.rightBarBtnBlock=^
    {
        [weakSelf addBtnAction];
    };
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize=CGSizeMake(kWidth, self.headerView.frame.size.height);
    flowLayout.itemSize=  CGSizeMake(182, 160);
    if (kWidth != 375) {
        CGFloat itemWidth  = (kWidth-10)/2;
        CGFloat itemHeight =  itemWidth * 8 / 9;
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    }
    flowLayout.minimumLineSpacing=10;
    flowLayout.minimumInteritemSpacing=10;
    flowLayout.sectionInset=UIEdgeInsetsMake(0,0,0,0);
    UICollectionView *collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-60) collectionViewLayout:flowLayout];
    [collectionView setBackgroundColor:BGColor];
    collectionView.delegate=self;
    collectionView.dataSource=self;
    self.collectionView=collectionView;
    [self.view addSubview:collectionView];
      [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
      [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    UIButton *tijiaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-50, kWidth-80, 40)];
    [tijiaoBtn setBackgroundColor:NavColor];
    [tijiaoBtn addTarget:self action:@selector(tijiaoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [tijiaoBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [self.view addSubview:tijiaoBtn];
    //添加长按手势
    _tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR)];
    [self.collectionView addGestureRecognizer:_tapDeleteGR];
    if (self.dic) {
        [self.honorData removeAllObjects];
        NSArray *ary = self.dic[@"engineeringCompanyApplies"];
        for (int i=0; i<ary.count; i++) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:ary[i]];
            [dic removeObjectForKey:@"roleApplyAuditId"];
            [dic removeObjectForKey:@"qualificationsId"];
            [self.honorData addObject:dic];
        }
        NSDictionary *roleApplyAudit = self.dic[@"roleApplyAudit"];
        self.roleApplyAuditId=roleApplyAudit[@"roleApplyAuditId"];
        flowLayout.headerReferenceSize=CGSizeMake(kWidth, 30);
        [self.collectionView reloadData];
    }
    
    // Do any additional setup after loading the view.
}
- (void)tapGR {
    self.isEditState = YES;
    [self.collectionView reloadData];
}
-(void)tijiaoBtnAction:(UIButton *)sender
{
    
    if (self.honorData.count<=0) {
        [ToastView showTopToast:@"请天加至少一条资质"];
        
        return;
    }
    NSString *rongyuStr= [self.honorData JSONString];
    ShowActionV();
    if (self.dic) {
        [HTTPCLIENT shengjiGCGSWithqualJson:rongyuStr WithroleApplyAuditId:self.roleApplyAuditId Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"您的工程公司认证已提交，请耐心等待"];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [HTTPCLIENT shengjiGCGSWithqualJson:rongyuStr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"您的工程公司认证已提交，请耐心等待"];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.honorData.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UINib *nib = [UINib nibWithNibName:@"ZIKMyHonorCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [cv registerNib:nib forCellWithReuseIdentifier:kHonorCellID];
    //ZIKIntegralCollectionViewCell *cell = [[ZIKIntegralCollectionViewCell alloc] init];
    ZIKMyHonorCollectionViewCell * cell = [cv dequeueReusableCellWithReuseIdentifier:kHonorCellID
                                                                        forIndexPath:indexPath];
    cell.isEditState = self.isEditState;
     cell.indexPath = indexPath;
    if (self.honorData.count > 0) {
        // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.honorData[indexPath.row] objectForKey:@"url"]]];
        NSString *myurlstr = [NSString stringWithFormat:@"%@",[self.honorData[indexPath.row] objectForKey:@"photo"]];
        NSURL *honorUrl = [NSURL URLWithString:myurlstr];
       // NSURL *myurl    = [[NSURL alloc] initWithString:myurlstr];
       // NSLog(@"%@",myurl);
        [cell.honorImageView setImageWithURL:honorUrl placeholderImage:[UIImage imageNamed:@"MoRentu"]];
        cell.honorTitleLabel.text = [self.honorData[indexPath.row] objectForKey:@"name"];
        cell.level=[self.honorData[indexPath.row] objectForKey:@"level"];
//        cell.honorTimeLabel.text  = [self.honorData[indexPath.row] objectForKey:@"acqueTime"];
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        cell.editButtonBlock = ^(NSIndexPath *indexPath) {
            NSDictionary *dic=self.honorData[indexPath.row];
            GCZZModel *model=[GCZZModel  GCZZModelWithDic:dic];
            model.uid=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            YLDZiZhiAddViewController *addhonorVC = [[YLDZiZhiAddViewController alloc] initWithModel:model andType:1];
            addhonorVC.delegate=self;
            [weakSelf.navigationController pushViewController:addhonorVC animated:YES];
        };
        cell.deleteButtonBlock = ^(NSIndexPath *indexPath) {
           
            NSString *title = NSLocalizedString(@"资质删除", nil);
            NSString *message = NSLocalizedString(@"是否确定删除该资质？", nil);
            NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
            NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            // Create the actions.
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
               
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
               [weakSelf.honorData removeObjectAtIndex:indexPath.row];
                      weakSelf.isEditState=NO;
                      [weakSelf.collectionView reloadData];
            }];
            
            // Add the actions.
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        
            //[weakSelf deleteRequest:model.uid];
        };

    }
    return cell;
}
-(void)addBtnAction
{
    YLDZiZhiAddViewController *viewCon=[[YLDZiZhiAddViewController alloc]initWithType:1];
    viewCon.delegate=self;
    [self.navigationController pushViewController:viewCon animated:YES];
}
-(void)reloadViewWithModel:(GCZZModel *)model andDic:(NSMutableDictionary *)dic
{
    if (model) {
        [self.honorData replaceObjectAtIndex:[model.uid integerValue] withObject:dic];
//        [self.honorData addObject:dic];
        [self.collectionView reloadData];
    }else{
        [self.honorData addObject:dic];
        [self.collectionView reloadData];
    }
  
}
//头部显示的内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView;

    if (kind == UICollectionElementKindSectionHeader) {
        
        headerView=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderIdentifier" forIndexPath:indexPath];
        if(self.dic)
        {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kWidth, 30)];
            [lab setTextColor:kRedHintColor];
            lab.text=[NSString stringWithFormat:@"退回原因：%@",self.dic[@"roleApplyAudit"][@"auditReason"]];
            [headerView addSubview:lab];
            [headerView addSubview:self.headerView];
        }

        
    }
    return headerView;
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
