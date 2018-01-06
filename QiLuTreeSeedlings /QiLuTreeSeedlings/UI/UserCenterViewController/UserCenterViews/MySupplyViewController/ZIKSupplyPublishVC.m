//
//  ZIKSupplyPublishVC.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKSupplyPublishVC.h"

#import "UIDefines.h"
#import "HttpClient.h"

#import "ZIKMySupplyCreateModel.h"

#import "WHC_PhotoListCell.h"
#import "WHC_PictureListVC.h"
#import "ZIKAddImageView.h"
#import "ZIKPickerBtn.h"
#import "BigImageViewShowView.h"
#import "ZIKSideView.h"
#import "ZIKSelectView.h"
#import "ZIKHintTableViewCell.h"
#import "FabutiaojiaCell.h"

#import "ZIKSupplyPublishNextVC.h"

//规格更改
#import "GuiGeModel.h"
#import "GuiGeView.h"
#define kMaxLength 20

@interface ZIKSupplyPublishVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,
UITextFieldDelegate,UIAlertViewDelegate,ZIKSelectViewUidDelegate,WHC_ChoicePictureVCDelegate,GuiGeViewDelegate>

@property (nonatomic, strong) UITableView            *supplyInfoTableView;
@property (nonatomic, strong) ZIKAddImageView        *addImageView;
@property (nonatomic, strong) UIButton               *sureButton;
@property (nonatomic, strong) UITextField            *nameTextField;
@property (nonatomic, strong) ZIKSideView            *sideView;
@property (nonatomic, strong) NSMutableArray         *productTypeDataMArray;
@property (nonatomic, strong) NSArray                *dataAry;
@property (nonatomic, strong) NSMutableArray         *cellAry;
@property (nonatomic, strong) UIScrollView           *backScrollView;
@property (nonatomic, strong) UITextField            *titleTextField;
@property (nonatomic, strong) UIButton               *nameBtn;
@property (nonatomic, strong) UITextField            *nowTextField;
@property (nonatomic, strong) ZIKMySupplyCreateModel *supplyModel;
@property (nonatomic, strong) SupplyDetialMode       *model;
@property (nonatomic, strong) NSArray                *nurseryAry;
@property (nonatomic, strong) NSDictionary           *baseDic;

//规格更改新增
@property (nonatomic,strong)NSString *productUid;
@property (nonatomic, strong) NSMutableArray *guige1Ary;
@property (nonatomic,strong)GuiGeView *guigeView;


@end

@implementation ZIKSupplyPublishVC
{
    UIView *_nameView;
    NSArray *_urlArr;
    ZIKHintTableViewCell *_hintView;
    BOOL isPicture;
}

-(id)initWithModel:(SupplyDetialMode*)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"供应发布";
    [self initData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (_urlArr.count > 0 ) {
        if (!isPicture || self.addImageView.saveHaveImageMarr==nil) {
            self.addImageView.saveHaveImageMarr  = (NSMutableArray *)_urlArr;
        }
        isPicture = NO;
     }
}

- (void)initData {
    self.productTypeDataMArray = [NSMutableArray array];
    self.cellAry               = [NSMutableArray array];
    self.supplyModel           = [[ZIKMySupplyCreateModel alloc] init];
    isPicture = NO;
//规格新增
    self.guige1Ary=[NSMutableArray array];

}

- (void)initUI {
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-64)];
    [self.view addSubview:self.backScrollView];
    [self.backScrollView setBackgroundColor:BGColor];

    UIView *myveiw1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 10)];
    myveiw1.backgroundColor = BGColor;
    [self.backScrollView addSubview:myveiw1];

    CGRect tempFrame  = CGRectMake(0,10, kWidth, 44);
    UIView *titleView = [[UIView alloc] initWithFrame:tempFrame];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 40, 44)];
    [titleLab setFont:[UIFont systemFontOfSize:15]];
    [titleView addSubview:titleLab];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    titleLab.text = @"标题";
    titleLab.textColor = DarkTitleColor;
    UITextField *titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(70, 0, kWidth-70, 44)];
    [titleTextField setFont:[UIFont systemFontOfSize:15]];
    titleTextField.placeholder  = @"请输入标题(限制在20字以内)";
    titleTextField.textColor = MoreDarkTitleColor;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:titleTextField];
    self.titleTextField = titleTextField;
    UIView *titleLineView = [[UIView alloc]initWithFrame:CGRectMake(15, titleView.frame.size.height-1, kWidth-30, 1)];
    [titleLineView setBackgroundColor:BGColor];
    [titleView addSubview:titleLineView];
    [titleView addSubview:titleTextField];
    titleTextField.delegate = self;
    titleTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.backScrollView addSubview:titleView];
    tempFrame.origin.y += 44.5;
    
    ZIKAddImageView *pickView = [[ZIKAddImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), Width, (Width-60)/3 + 45) image:nil];
    pickView.backgroundColor = [UIColor whiteColor];

    [self.backScrollView addSubview:pickView];
    self.addImageView = pickView;
    __weak typeof(self) weakSelf = self;
    self.addImageView.lookPhotoBlock = ^(){//展示照片
        BigImageViewShowView *showView = [[BigImageViewShowView alloc] initWithImageAry:weakSelf.addImageView.imageArr];
        [weakSelf.view addSubview:showView];
        [showView showWithIndex:0];
        };
     self.addImageView.takePhotoBlock = ^{//添加照片
        [weakSelf openMenu];
    };

    _nameView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pickView.frame), kWidth, 54)];
    [_nameView setBackgroundColor:[UIColor whiteColor]];

    [self.backScrollView addSubview:_nameView];

    UIView *myveiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 10)];
    myveiw.backgroundColor = BGColor;
    [_nameView addSubview:myveiw];

    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 44)];
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    nameLab.text = @"苗木名称";
    nameLab.textColor = DarkTitleColor;
    [_nameView addSubview:nameLab];
    UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, nameLab.frame.origin.y, kWidth-100-60, nameLab.frame.size.height)];
    nameTextField.placeholder = @"请输入名称";
    nameTextField.textColor = NavColor;
    nameTextField.delegate = self;
    [nameTextField setFont:[UIFont systemFontOfSize:15]];
    self.nameTextField = nameTextField;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nameChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nameTextField];
    [_nameView addSubview:nameTextField];

    UIButton *nameBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-70, 9+10, 50, 25)];
    [_nameView addSubview:nameBtn];
    [nameBtn addTarget:self action:@selector(nameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [nameBtn setImage:[UIImage imageNamed:@"treeNameSure"] forState:UIControlStateNormal];
    [nameBtn setImage:[UIImage imageNamed:@"treeNameSure2"] forState:UIControlStateSelected];
    UIImageView *nameLineView = [[UIImageView alloc]initWithFrame:CGRectMake(10, _nameView.frame.size.height-1, kWidth-10, 0.5)];
    [nameLineView setBackgroundColor:kLineColor];

    self.nameBtn = nameBtn;

    ZIKHintTableViewCell *hintView = [[[NSBundle mainBundle] loadNibNamed:@"ZIKHintTableViewCell" owner:self options:nil] lastObject];
    hintView.frame = CGRectMake(0, CGRectGetMaxY(_nameView.frame)-5, Width, HINT_VIEW_HEIGHT);
    hintView.hintStr = @"输入的越详细,匹配度越高";
    hintView.hidden = YES;
    hintView.contentView.backgroundColor = BGColor;
    [self.backScrollView addSubview:hintView];
    _hintView = hintView;

    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-60, kWidth-80, 44)];
    [self.view addSubview:nextBtn];
    [nextBtn setBackgroundColor:NavColor];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidingKey)];
    [self.backScrollView addGestureRecognizer:tapgest];
    if (self.model) {
        self.titleTextField.text = self.model.title;
        self.nameTextField.text  = self.model.productName;
        self.nameBtn.selected    = YES;
        //__weak typeof(self) weakSelf = self;
        [HTTPCLIENT mySupplyUpdataWithUid:self.model.uid Success:^(id responseObject) {
            if ([[ responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *resultdic       = [responseObject objectForKey:@"result"];
                NSDictionary *ProductSpecDIc  = [resultdic objectForKey:@"ProductSpec"];
                NSArray *beanAry              = [ProductSpecDIc objectForKey:@"bean"];

                //处理图片数组
                NSArray *imagesAry            = [resultdic objectForKey:@"images"];
                NSArray *imagesCompressAry    = [resultdic objectForKey:@"imagesCompress"];
                NSArray *imagesDetailAry      = resultdic[@"imagesDetail"];
                if (imagesDetailAry.count==0) {
                    imagesDetailAry=imagesCompressAry;
                }
                NSMutableArray *imagesUrlMAry = [NSMutableArray arrayWithCapacity:2];
                for (int i = 0; i < imagesAry.count; i++) {

                    for (int j = 0; j < imagesCompressAry.count; j++) {

                        for (int k = 0; k < imagesDetailAry.count; k++) {
                            if (i == j && j == k) {
                                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
                                NSString *url=imagesAry[i];
                                url=[url stringByReplacingOccurrencesOfString:@" " withString:@""];
                                NSString *compressurl=imagesCompressAry[i];
                                compressurl=[compressurl stringByReplacingOccurrencesOfString:@" " withString:@""];
                                NSString *detailurl=imagesDetailAry[i];

                                if([ZIKFunction xfunc_check_strEmpty:detailurl]) {
                                    detailurl = compressurl;
                                } else {
                                detailurl=[detailurl stringByReplacingOccurrencesOfString:@" " withString:@""];
                                }
                                dic[@"url"]         =url;
                                dic[@"compressurl"] = compressurl;
                                dic[@"detailurl"]   = detailurl;
                                [imagesUrlMAry addObject:dic];
                            }
                        }
                    }
                };
                weakSelf.addImageView.urlMArr = imagesUrlMAry;
                //处理图片数组结束

                weakSelf.nurseryAry            = [resultdic objectForKey:@"nurseryList"];
                if (weakSelf.nurseryAry.count == 0) {
                    [ToastView showTopToast:@"请先完善苗圃信息"];
                }
                weakSelf.baseDic               = [resultdic objectForKey:@"baseMsg"];
                [weakSelf creatSCreeningCellsWithAnswerWithAry:beanAry];
            }else{
                [ToastView showTopToast:[ responseObject objectForKey:@"msg"]];
            }
           
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void)creatSCreeningCellsWithAnswerWithAry:(NSArray *)guigeAry
{


    for (int i=0; i<guigeAry.count; i++) {
        NSDictionary *dic=guigeAry[i];
        if ([[dic objectForKey:@"level"] integerValue]==0) {
            GuiGeModel *guigeModel=[GuiGeModel creatGuiGeModelWithDic:dic];
            [self.guige1Ary addObject:guigeModel];
        }
    }

    for (int i=0; i<guigeAry.count; i++) {
        NSDictionary *dic=guigeAry[i];
        if ([[dic objectForKey:@"level"] integerValue]==1) {
            GuiGeModel *guigeModel=[GuiGeModel creatGuiGeModelWithDic:dic];


            for (int j=0; j<self.guige1Ary.count; j++) {
                GuiGeModel *guigeModel1=self.guige1Ary[j];
                for (int k=0 ; k<guigeModel1.propertyLists.count; k++) {

                    Propers *proper=guigeModel1.propertyLists[k];
                    if ([proper.relation isEqualToString:guigeModel.uid]) {
                        proper.guanlianModel=guigeModel;
                    }
                }
            }
        }
    }
    _hintView.hidden = NO;
    CGFloat Y = CGRectGetMaxY(_hintView.frame) ;


    GuiGeView *guigeView = [[GuiGeView alloc]initWithValueAry:self.guige1Ary andFrame:CGRectMake(0, Y, kWidth, 0)];
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(guigeView.frame))];
    guigeView.delegate = self;
    self.guigeView = guigeView;
    if (self.guige1Ary.count == 0) {
        guigeView.showBtn.hidden = YES;
    }
    [self.backScrollView addSubview:guigeView];

}

- (void)nameChange {
    self.nameBtn.selected = NO;
}

#pragma mark - 下一步按钮点击事件
-(void)nextBtnAction:(UIButton *)sender
{

    if (self.titleTextField.text.length == 0 || self.titleTextField.text == nil) {
        [ToastView showTopToast:@"请输入标题"];
        return;
    }
    if (self.nameTextField.text.length == 0 || self.nameTextField.text == nil || self.nameBtn.selected == NO) {
        [ToastView showTopToast:@"请先确定苗木名称"];
        return;
    }
    if (self.addImageView.urlMArr.count<3) {
        [ToastView showTopToast:@"请添加三张苗木图片"];
        return;
    }
    self.supplyModel.title = self.titleTextField.text;
    self.supplyModel.name  = self.nameTextField.text;

    __block NSString *urlSring      = @"";
    __block NSString *compressSring = @"";
    __block NSString *imageDetailUrls = @"";
    [self.addImageView.urlMArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        urlSring = [urlSring stringByAppendingString:[NSString stringWithFormat:@",%@",dic[@"url"]]];
        compressSring = [compressSring stringByAppendingString:[NSString stringWithFormat:@",%@",dic[@"compressurl"]]];
        imageDetailUrls = [imageDetailUrls stringByAppendingString:[NSString stringWithFormat:@",%@",dic[@"detailurl"]]];
    }];
    if (self.addImageView.urlMArr.count != 0) {
        self.supplyModel.imageUrls         = [urlSring substringFromIndex:1];
        self.supplyModel.imageCompressUrls = [compressSring substringFromIndex:1];
        self.supplyModel.imageDetailUrls = [imageDetailUrls substringFromIndex:1];
    }
    NSMutableArray *screenTijiaoAry=[NSMutableArray array];

    BOOL canrun = [self.guigeView  getAnswerAry:screenTijiaoAry];
    if (canrun) {
//        for (int i=0; i<screenTijiaoAry.count; i++) {
//            NSDictionary *dic=screenTijiaoAry[i];
//            CLog(@"%@---%@",dic[@"field"],dic[@"value"]);
//        }
    }else{
        return;
    }

    self.supplyModel.specificationAttributes = [NSArray arrayWithObject:screenTijiaoAry];
    _urlArr = self.addImageView.urlMArr;
    if (self.addImageView.haveImageMArr.count > 0) {
        [self.addImageView.haveImageMArr enumerateObjectsUsingBlock:^(ZIKPickerBtn *btn, NSUInteger idx, BOOL * _Nonnull stop) {
            [btn removeFromSuperview];
        }];
        [self.addImageView.haveImageMArr removeAllObjects];
    }


    ZIKSupplyPublishNextVC *nextVC = [[ZIKSupplyPublishNextVC alloc] initWithNurseryList:self.nurseryAry WithbaseMsg:self.baseDic];
    //nextVC.pickerImgView = self.addImageView;
    nextVC.supplyModel = self.supplyModel;
    [self.navigationController pushViewController:nextVC animated:YES];
    self.addImageView.saveHaveImageMarr = nil;
}

- (void)nameBtnAction:(UIButton *)button {
   // NSLog(@"确定按钮点击");
    if (button.selected) {
        [self requestProductType];
        return;
    }

    [self.guige1Ary removeAllObjects];

    if (self.guigeView) {
        [self.guigeView removeFromSuperview];
        self.guigeView = nil;
    }

        [HTTPCLIENT huoqumiaomuGuiGeWithTreeName:self.nameTextField.text andType:@"1" andMain:@"0" Success:^(id responseObject) {
            if (![[responseObject objectForKey:@"success"] integerValue]) {
                
                if ([responseObject[@"msg"] isEqualToString:@"该苗木不存在"]) {
                    [self requestProductType];
                    if (self.nameTextField.text.length>0) {
                        [ToastView showToast:[responseObject objectForKey:@"msg"]
                                 withOriginY:66.0f
                               withSuperView:APPDELEGATE.window];
                    }
                }else
                {
                    [ToastView showToast:[responseObject objectForKey:@"msg"]
                             withOriginY:66.0f
                           withSuperView:APPDELEGATE.window];
                }
            }else{
                button.selected=YES;
                NSDictionary *dic=[responseObject objectForKey:@"result"];
                self.productUid=[dic objectForKey:@"productUid"];
                NSArray *guigeAry=[dic objectForKey:@"list"];

                for (int i=0; i<guigeAry.count; i++) {
                    NSDictionary *dic=guigeAry[i];
                    if ([[dic objectForKey:@"level"] integerValue]==0) {
                        GuiGeModel *guigeModel=[GuiGeModel creatGuiGeModelWithDic:dic];
                        [self.guige1Ary addObject:guigeModel];
                    }
                }

                for (int i=0; i<guigeAry.count; i++) {
                    NSDictionary *dic=guigeAry[i];
                    if ([[dic objectForKey:@"level"] integerValue]==1) {
                        GuiGeModel *guigeModel=[GuiGeModel creatGuiGeModelWithDic:dic];


                        for (int j=0; j<self.guige1Ary.count; j++) {
                            GuiGeModel *guigeModel1=self.guige1Ary[j];
                            for (int k=0 ; k<guigeModel1.propertyLists.count; k++) {

                                Propers *proper=guigeModel1.propertyLists[k];
                                  if ([proper.relation isEqualToString:guigeModel.uid]) {
                                    proper.guanlianModel=guigeModel;
                                }
                            }
                        }
                    }
                }
                _hintView.hidden = NO;
                CGFloat Y = CGRectGetMaxY(_hintView.frame) ;

                GuiGeView *guigeView=[[GuiGeView alloc]initWithAry:self.guige1Ary andFrame:CGRectMake(0, Y, kWidth, 0)];
                [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(guigeView.frame))];
                guigeView.delegate=self;
                self.guigeView=guigeView;
                if (self.guige1Ary.count == 0) {
                    guigeView.showBtn.hidden = YES;
                }
                [self.backScrollView addSubview:guigeView];
            }

        } failure:^(NSError *error) {
            //NSLog(@"%@",error);
        }];
    

}

-(void)creatScreeningCells
{
    self.dataAry = [TreeSpecificationsModel creatTreeSpecificationsModelAryByAry:self.dataAry];
    //    NSLog(@"%@",ary);
    _hintView.hidden = NO;
    CGFloat Y = CGRectGetMaxY(_hintView.frame) ;

    [self.backScrollView.subviews enumerateObjectsUsingBlock:^(UIView *myview, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([myview isKindOfClass:[FabutiaojiaCell class]]) {
            [myview removeFromSuperview];
        }
    }];
    
    for (int i=0; i < self.dataAry.count; i++) {
        FabutiaojiaCell *cell = [[FabutiaojiaCell alloc] initWithFrame:CGRectMake(0, Y, kWidth, 44) AndModel:self.dataAry[i] andAnswer:nil];
        [_cellAry addObject:cell.model];
        Y = CGRectGetMaxY(cell.frame);
        [self.backScrollView addSubview:cell];
    }
    [self.backScrollView setContentSize:CGSizeMake(0, Y)];
    self.backScrollView.backgroundColor = [UIColor whiteColor];
}

- (void)requestProductType {
    [HTTPCLIENT getTypeInfoSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 1 ) {
            NSArray *typeListArray = [[responseObject objectForKey:@"result"] objectForKey:@"typeList"];
            if (typeListArray.count == 0) {
                //NSLog(@"暂时没有产品信息!!!");
                [ToastView showToast:@"暂时没有产品信息" withOriginY:Width/3 withSuperView:self.view];
            }
            else if (typeListArray.count > 0) {
                self.productTypeDataMArray = (NSMutableArray *)typeListArray;
                [self showSideView];
            }
        }
        else if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
               [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/3 withSuperView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)showSideView {
    [self.titleTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];

     [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if (!self.sideView) {
        self.sideView = [[ZIKSideView alloc] initWithFrame:CGRectMake(Width, 0, Width, Height)];
    }
    self.sideView.selectView.type = @"1";
    self.sideView.pleaseSelectLabel.text = @"请选择苗木";
    self.sideView.selectView.uidDelegate = self;
    //    self.selectView = self.sideView.selectView;
    //    self.selectView.delegate = self;
    self.sideView.dataArray = self.productTypeDataMArray;
    self.sideView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:.3 animations:^{
        self.sideView.frame = CGRectMake(0, 0, Width, Height);
    }];
    [self.view addSubview:self.sideView];
}
//- (BOOL)prefersStatusBarHidden
//{
//    return YES; // 返回NO表示要显示，返回YES将hiden
//}
#pragma mark - 实现选择苗木协议
- (void)didSelectorUid:(NSString *)selectId title:(NSString *)selectTitle {
    //NSLog(@"%@",selectTitle);
    self.nameTextField.text = selectTitle;
    //self.supplyModel.name = selectTitle;
    self.supplyModel.productUid = selectId;
    [self.sideView removeSideViewAction];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.nameBtn.selected=NO;
    [self nameBtnAction:self.nameBtn];
}

- (void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;

    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
               // NSLog(@"最多%d个字符!!!",kMaxLength);
                [ToastView showToast:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] withOriginY:250 withSuperView:self.view];
                //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] view:nil];
                textField.text = [toBeString substringToIndex:kMaxLength];
                return;
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{

        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%ld个字符",(long)kMaxLength] view:nil];
             //NSLog(@"最多%d个字符!!!",kMaxLength);
            [ToastView showToast:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] withOriginY:250 withSuperView:self.view];
            textField.text = [toBeString substringToIndex:kMaxLength];
            return;
        }
    }
}

-(void)openMenu
{
    [self.titleTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];

    __weak typeof(self)weakself =self;
    //在这里呼出下方菜单按钮项
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传视频或照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        

        
    }]];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍摄新照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakself takePhoto];
        
    }]];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        [weakself LocalPhoto];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍摄新视频" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        [weakself takeVideo];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


//
-(void)takeVideo
{
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *availableMediaTypes = [UIImagePickerController
                                        availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]) {
            // 支持视频录制
            UIImagePickerController *camera = [UIImagePickerController new];
            camera.sourceType = UIImagePickerControllerSourceTypeCamera;
            camera.mediaTypes = @[(NSString *)kUTTypeMovie];
            camera.videoMaximumDuration = 30.0f;//30秒
            camera.delegate = self;
            [self presentViewController:camera animated:YES completion:nil];
            isPicture  = YES;
        }else
        {
            [ToastView showTopToast:@"您的设备不支持视频录制"];
        }
    }
    
}
//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        //        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
        isPicture  = YES;
    }else
    {
        //NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    WHC_PictureListVC  * vc = [WHC_PictureListVC new];
    vc.delegate = self;
    vc.maxChoiceImageNumberumber = 3-self.addImageView.urlMArr.count;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    isPicture  = YES;
}

#pragma mark - WHC_ChoicePictureVCDelegate
- (void)WHCChoicePictureVCdidSelectedPhotoArr:(NSArray *)photoArr{
    for (__weak UIImage *image in photoArr) {
        
        NSData *imageData;
        
        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
        // 必填字段
        put.bucketName = @"miaoxintong";
        
        NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"member/image/%@",APPDELEGATE.userModel.access_id] WithTypeStr:@"supply"];
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            imageData = UIImagePNGRepresentation(image);
            put.contentType=@"image/png";
            put.objectKey = [NSString stringWithFormat:@"%@.png",nameStr];
        }else {
            //返回为JPEG图像。
            imageData = UIImageJPEGRepresentation(image,1);
            put.contentType=@"image/jpeg";
            put.objectKey =[NSString stringWithFormat:@"%@.jpeg",nameStr];
        }
        if (imageData.length>=1024*1024) {
            CGSize newSize = {image.size.width*0.5,image.size.height*0.5};
            imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
        }
        put.uploadingData = imageData; // 直接上传NSData
        // 可选字段，可不设置
        put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
        };
        OSSTask * putTask = [APPDELEGATE.client putObject:put];
        [putTask continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                //                NSLog(@"upload object success!");
                
                NSMutableDictionary *result=[NSMutableDictionary dictionary];
                result[@"compressurl"]=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@?x-oss-process=style/supplybuy_compress",put.objectKey];
                result[@"detailurl"]=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@?x-oss-process=style/supplybuy_small",put.objectKey];
                result[@"url"]=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //Update UI in UI thread here
                    [ToastView showTopToast:@"上传图片成功"];
                    [self.addImageView addImage:[UIImage imageWithData:imageData]  withUrl:result];
                    
                });
                
            } else {
                //                NSLog(@"upload object failed, error: %@" , task.error);
                [ToastView showTopToast:@"上传图片失败"];
                
            }
            return nil;
        }];
    }

}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        __weak  UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *imageData;
        
        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
        // 必填字段
        put.bucketName = @"miaoxintong";
        
        NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"member/image/%@",APPDELEGATE.userModel.access_id] WithTypeStr:@"supply"];
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            imageData = UIImagePNGRepresentation(image);
            put.contentType=@"image/png";
            put.objectKey = [NSString stringWithFormat:@"%@.png",nameStr];
        }else {
            //返回为JPEG图像。
            imageData = UIImageJPEGRepresentation(image, 1);
            put.contentType=@"image/jpeg";
            put.objectKey =[NSString stringWithFormat:@"%@.jpeg",nameStr];
        }
        if (imageData.length>=1024*1024) {
            CGSize newSize = {image.size.width*0.5,image.size.height*0.5};
            imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
        }
        put.uploadingData = imageData; // 直接上传NSData
        // 可选字段，可不设置
        put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
        };
        OSSTask * putTask = [APPDELEGATE.client putObject:put];
        [putTask continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                //                NSLog(@"upload object success!");
                
                NSMutableDictionary *result=[NSMutableDictionary dictionary];
                result[@"compressurl"]=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@?x-oss-process=style/supplybuy_compress",put.objectKey];
                result[@"detailurl"]=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@?x-oss-process=style/supplybuy_small",put.objectKey];
                result[@"url"]=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //Update UI in UI thread here
                    [ToastView showTopToast:@"上传图片成功"];
                    [self.addImageView addImage:[UIImage imageWithData:imageData]  withUrl:result];
                    
                });
                
            } else {
                //                NSLog(@"upload object failed, error: %@" , task.error);
                [ToastView showTopToast:@"上传图片失败"];
                
            }
            return nil;
        }];
        
        
    }else if([type isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
        
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
//            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
        }
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)backBtnAction:(UIButton *)sender
{
    __weak typeof(self)weakself =self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要退出编辑？" preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }]];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakself.navigationController popViewControllerAnimated:YES];
        
    }]];


    
    // 由于它是一个控制器 直接modal出来就好了
    
    [self presentViewController:alertController animated:YES completion:nil];

}


-(void)cellBeginEditing:(UITextField *)field
{
    self.nowTextField=field;
}

-(void)cellEndEditing
{
    if (self.backScrollView.frame.size.height==kHeight-44-44) {
        return;
    }
}

-(void)cellKeyHight:(CGFloat)hight
{
    if (self.backScrollView.frame.size.height==kHeight-hight-44-44) {
        return;
    }
}

-(void)hidingKey
{
    if (self.nowTextField) {
        [self.nowTextField resignFirstResponder];
    }
    if (self.backScrollView.frame.size.height==kHeight-44-44) {
        return;
    }
}

-(NSData *)imageData:(UIImage *)myimage
{
    __weak typeof(myimage) weakImage = myimage;
    NSData *data = UIImageJPEGRepresentation(weakImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data = UIImageJPEGRepresentation(weakImage, 0.1);
        }
        else if (data.length>512*1024) {//0.5M-1M
            data = UIImageJPEGRepresentation(weakImage, 0.9);
        }
        else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(weakImage, 0.9);
        }
    }
    if (data.length>=1024*1024) {
        CGSize newSize = {200,150};
        data =  [self imageWithImageSimple:myimage scaledToSize:newSize];
    }
    return data;
}
-(NSData*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    
    return UIImagePNGRepresentation(newImage);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.titleTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}

-(void)reloadViewWithFrame:(CGRect)frame
{
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(frame))];
}

@end
