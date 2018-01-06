//
//  YLDPZListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/7.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDPZListViewController.h"
#import "ZIKCityTableViewCell.h"
#import "ZIKCitySectionHeaderView.h"
#import "YLDSectionInfo.h"
#import "StringAttributeHelper.h"
#import "YLDPZInfo.h"
static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";
@interface YLDPZListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *cityTableView;
@property (nonatomic) NSMutableArray *sectionInfoArray;
@property (nonatomic) NSIndexPath *pinchedIndexPath;
@property (nonatomic) NSInteger openSectionIndex;
@property (nonatomic) CGFloat initialPinchHeight;

@property (nonatomic)  ZIKCitySectionHeaderView *sectionHeaderView;

// use the uniformRowHeight property if the pinch gesture should change all row heights simultaneously
@property (nonatomic) NSInteger uniformRowHeight;
@end
#pragma mark -

#define DEFAULT_ROW_HEIGHT 44
#define HEADER_HEIGHT 44
@implementation YLDPZListViewController
{
    NSMutableArray *_selectMArr;
    NSMutableArray *_selectnameMArr;
    BOOL _isCanSelect;
    
}
- (BOOL)canBecomeFirstResponder {
    
    return YES;
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(UIView *)makeNavView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:BGColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"backBtnBlack"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [view addSubview:backBtn];
    self.backBtn = backBtn;
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2-160,26, 320, 30)];
    [titleLab setTextColor:MoreDarkTitleColor];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    //[titleLab setText:self.vcTitle];
    //titleLab.text = self.vcTitle;
    NSString *str           = @"选择品种（最多可选5项）";
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font           = [UIFont systemFontOfSize:14.0f];
    fullFont.effectRange    = NSMakeRange(0, str.length);
    //局部设置
    FontAttribute *partFont = [FontAttribute new];
    partFont.font           = [UIFont systemFontOfSize:20.0f];
    partFont.effectRange    = NSMakeRange(0, 4);
    titleLab.attributedText = [str mutableAttributedStringWithStringAttributes:@[fullFont,partFont]];
    
    [view addSubview:titleLab];
    return view;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionInfoArray=[NSMutableArray array];
    self.rightBarBtnTitleString               = @"确定";
    [self.back2Btn setTitleColor:NavColor forState:UIControlStateNormal];
    _selectMArr                               = [[NSMutableArray alloc] initWithCapacity:5];
    _selectnameMArr                           = [[NSMutableArray alloc] initWithCapacity:5];
    _isCanSelect                              = YES;
    UITableView *cityTV                       = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStylePlain];
    cityTV.delegate                           = self;
    cityTV.dataSource                         = self;
    [self.view addSubview:cityTV];
    self.cityTableView                        = cityTV;
      
    self.cityTableView.sectionHeaderHeight    = HEADER_HEIGHT;
    self.uniformRowHeight                     = DEFAULT_ROW_HEIGHT;
    self.openSectionIndex                     = NSNotFound;
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ZIKCitySectionHeaderView" bundle:nil];
    [self.cityTableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    __weak typeof(_selectMArr) selectMarr = _selectMArr;//解决循环引用的问题
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    __weak typeof(_selectnameMArr) selectnameMArr = _selectnameMArr;
    
    self.rightBarBtnBlock = ^{
        CLog(@"%@",selectMarr);
        if (selectMarr.count == 0) {
            [ToastView showTopToast:@"您还未选择品种"];
            return ;
        }
        __block NSString *cityCodeString = @"";
//        __block NSMutableArray *ary=[NSMutableArray array];
        [selectMarr enumerateObjectsUsingBlock:^(NSString *code, NSUInteger idx, BOOL * _Nonnull stop) {
            cityCodeString = [cityCodeString stringByAppendingString:[NSString stringWithFormat:@",%@",code]];
        }];
        cityCodeString = [cityCodeString substringFromIndex:1];
        if ([weakSelf.delegate respondsToSelector:@selector(selectpzInfo:)]) {
            [weakSelf.delegate selectpzInfo:cityCodeString];
        }
        if ([weakSelf.delegate respondsToSelector:@selector(selectpzModels:)]) {
            [weakSelf.delegate selectpzModels:selectnameMArr];
        }
        [weakSelf.navigationController popViewControllerAnimated:NO];
    };
    [self requestProductType];

    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (_selectMArr.count > 0) {
        [_selectMArr removeAllObjects];
    }

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.sectionInfoArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    YLDSectionInfo *sectionInfo   = (self.sectionInfoArray)[section];
    NSInteger numStoriesInSection = [sectionInfo.pzAry count];
    
    return sectionInfo.open ? numStoriesInSection : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *QuoteCellIdentifier = @"QuoteCellIdentifier";
    
    ZIKCityTableViewCell *cell = (ZIKCityTableViewCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKCityTableViewCell" owner:self options:nil] lastObject];
    }
    YLDSectionInfo *play =self.sectionInfoArray[indexPath.section];
    cell.info = play.pzAry[indexPath.row];
    
    return cell;
}

- (void)requestProductType {
    [HTTPCLIENT getTypeInfoSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 1 ) {
            NSArray *typeListArray = [[responseObject objectForKey:@"result"] objectForKey:@"typeList"];
            if (typeListArray.count == 0) {
                [ToastView showTopToast:@"暂时没有产品信息!"];
            }
            else if (typeListArray.count > 0) {
                for (NSDictionary *dic in typeListArray) {
                    YLDSectionInfo *info=[YLDSectionInfo new];
                    info.typeName=dic[@"typeName"];
                    info.typeUid=dic[@"typeUid"];
                    [self.sectionInfoArray addObject:info];
                }
                [self.cityTableView reloadData];
//                self.productTypeDataMArray = (NSMutableArray *)typeListArray;
//                [self showSideView];
            }
        }
        else if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    YLDSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    //CLog(@"%d",sectionInfo.isAllSelect);
    //CLog(@"%d",sectionInfo.se)
    sectionInfo.headerView.disclosureButton.selected = sectionInfo.open;
//    if (sectionInfo.isAllSelect) {
//        sectionInfo.isAllSelect = sectionInfo.isAllSelect;
//        return;
//    }
    sectionInfo.selectNum = sectionInfo.selectNum;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ZIKCitySectionHeaderView *sectionHeaderView = [self.cityTableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    YLDSectionInfo *sectionInfo       = (self.sectionInfoArray)[section];
    sectionInfo.headerView            = sectionHeaderView;
    sectionHeaderView.titleLable.text = sectionInfo.typeName;
    sectionHeaderView.section         = section;
    if (sectionInfo.selectNum==0) {
        sectionHeaderView.selectHintLabel.hidden=YES;
    }else{
        sectionHeaderView.selectHintLabel.hidden=NO;
        sectionHeaderView.selectHintLabel.text=[NSString stringWithFormat:@"已选择%ld项",sectionInfo.selectNum];
    }
    sectionHeaderView.delegate        = self;
    
    return sectionHeaderView;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    YLDSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
    return 44;
    // Alternatively, return rowHeight.
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YLDSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
     YLDPZInfo *info = sectionInfo.pzAry[indexPath.row];
    if ([_selectnameMArr containsObject:info.productName]) {
        [_selectnameMArr removeObject:info.productName];
    }
    if ([_selectMArr containsObject:info.productUid]) {
        [_selectMArr removeObject:info.productUid];
        
        _isCanSelect = YES;
    }
    else if (_selectMArr.count >= 5) {
        [ToastView showTopToast:@"最多只能选择5项!"];
        _isCanSelect = NO;
    }
    else {
        _isCanSelect = YES;
    }
    return indexPath;
}
#pragma mark - SectionHeaderViewDelegate

- (void)sectionHeaderView:(ZIKCitySectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
    
    YLDSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionOpened];
    
    sectionInfo.open = YES;

    if (sectionInfo.pzAry.count==0) {
        ShowActionV();
        [HTTPCLIENT getProductWithTypeUid:sectionInfo.typeUid type:@"1" Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSArray *productList=[[responseObject objectForKey:@"result"] objectForKey:@"productList"];
                NSMutableArray *ary=[NSMutableArray array];
                for (NSDictionary *dic in productList) {
                    YLDPZInfo *info=[YLDPZInfo new];
                    info.productName=dic[@"productName"];
                    info.productUid=dic[@"productUid"];
                    
                    [ary addObject:info];
                }
                sectionInfo.pzAry=ary;
                NSInteger countOfRowsToInsert = [sectionInfo.pzAry count];
                NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
                for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
                    [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
                }
                
                NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
                
                NSInteger previousOpenSectionIndex = self.openSectionIndex;
                if (previousOpenSectionIndex != NSNotFound) {
                    
                    YLDSectionInfo *previousOpenSection = (self.sectionInfoArray)[previousOpenSectionIndex];
                    previousOpenSection.open = NO;
                    [previousOpenSection.headerView toggleOpenWithUserAction:NO];
                    NSInteger countOfRowsToDelete = [previousOpenSection.pzAry count];
                    for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
                    }
                }
                
                // style the animation so that there's a smooth flow in either direction
                UITableViewRowAnimation insertAnimation;
                UITableViewRowAnimation deleteAnimation;
                if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
                    insertAnimation = UITableViewRowAnimationTop;
                    deleteAnimation = UITableViewRowAnimationBottom;
                }
                else {
                    insertAnimation = UITableViewRowAnimationBottom;
                    deleteAnimation = UITableViewRowAnimationTop;
                }
                
                // apply the updates
                [self.cityTableView beginUpdates];
                [self.cityTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
                [self.cityTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
                [self.cityTableView endUpdates];
                
                self.openSectionIndex = sectionOpened;
            }
            
            RemoveActionV();
        } failure:^(NSError *error) {
            RemoveActionV();
        }];
    }else{
        NSInteger countOfRowsToInsert = [sectionInfo.pzAry count];
        NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
        }
        
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        
        NSInteger previousOpenSectionIndex = self.openSectionIndex;
        if (previousOpenSectionIndex != NSNotFound) {
            
            YLDSectionInfo *previousOpenSection = (self.sectionInfoArray)[previousOpenSectionIndex];
            previousOpenSection.open = NO;
            [previousOpenSection.headerView toggleOpenWithUserAction:NO];
            NSInteger countOfRowsToDelete = [previousOpenSection.pzAry count];
            for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
            }
        }
        
        // style the animation so that there's a smooth flow in either direction
        UITableViewRowAnimation insertAnimation;
        UITableViewRowAnimation deleteAnimation;
        if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
            insertAnimation = UITableViewRowAnimationTop;
            deleteAnimation = UITableViewRowAnimationBottom;
        }
        else {
            insertAnimation = UITableViewRowAnimationBottom;
            deleteAnimation = UITableViewRowAnimationTop;
        }
        
        // apply the updates
        [self.cityTableView beginUpdates];
        [self.cityTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
        [self.cityTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
        [self.cityTableView endUpdates];
        
        self.openSectionIndex = sectionOpened;
    }
   
}

- (void)sectionHeaderView:(ZIKCitySectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    

    YLDSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionClosed];
    
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.cityTableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.cityTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isCanSelect) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    YLDSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
    YLDPZInfo *info = sectionInfo.pzAry[indexPath.row];

    info.select=!info.select;
  
        

        if (info.select==NO) {
            --sectionInfo.selectNum;

        }
        else if (info.select==YES) {
            ++sectionInfo.selectNum;

        }
    
   
    if ([_selectnameMArr containsObject:info.productName]) {
        [_selectnameMArr removeObject:info.productName];
    }else{
        [_selectnameMArr addObject:info.productName];
    }
    if ([_selectMArr containsObject:info.productUid]) {
        [_selectMArr removeObject:info.productUid];
    }
    else {
        [_selectMArr addObject:info.productUid];
        
    }
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
