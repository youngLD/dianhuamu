//
//  buyFabuViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/18.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "buyFabuViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "TreeSpecificationsModel.h"
#import "FabutiaojiaCell.h"
#import "ZIKSideView.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "YLDMyBuyListViewController.h"
#import "BuyDetialInfoViewController.h"
#import "GuiGeModel.h"
#import "GuiGeView.h"
#import "YLDBuyFabuViewController.h"
#import "ZIKHintTableViewCell.h"
#import "ZIKAddImageView.h"
#import "ZIKPickerBtn.h"
#import "BigImageViewShowView.h"
#import "WHC_PhotoListCell.h"
#import "WHC_PictureListVC.h"
#import "PickerShowView.h"
#import "BWTextView.h"
#import "YLDRangeTextView.h"
#import "YLDRangeTextField.h"
@interface buyFabuViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,ZIKSelectViewUidDelegate,UIAlertViewDelegate,GuiGeViewDelegate,PickeShowDelegate,WHC_ChoicePictureVCDelegate>
@property (nonatomic,strong)UITextField *titleTextField;
@property (nonatomic,strong)UITextField *simpletitleTextField;
@property (nonatomic,strong)UITextField *nameTextField;
@property (nonatomic,strong)UIButton *nameBtn;
@property (nonatomic,strong)NSString *productName;
@property (nonatomic,strong)NSArray *dataAry;
@property (nonatomic,strong)NSString *productUid;
@property (nonatomic,strong)UIScrollView *backScrollView;
@property (nonatomic,strong)UITextField *nowTextField;
@property (nonatomic,strong)NSMutableArray *cellAry;
@property (nonatomic,strong)BuyDetialModel *model;
@property (nonatomic,strong)HotBuyModel *simplemodel;
@property (nonatomic,strong)NSDictionary *baseMessageDic;
@property (nonatomic) BOOL isCanPublish;
@property (nonatomic, strong) ZIKSideView     *sideView;
@property (nonatomic, strong) NSMutableArray   *productTypeDataMArray;
@property (nonatomic, strong) NSMutableArray *guige1Ary;
@property (nonatomic,strong)GuiGeView *guigeView;
@property (nonatomic,strong)ZIKHintTableViewCell *hintView;
@property (nonatomic,strong)ZIKAddImageView *addImageView;
@property (nonatomic, strong) UIActionSheet   *myActionSheet;
@property (nonatomic, strong) UIView   *accurateView;
@property (nonatomic, strong) UIView   *simpleView;
@property (nonatomic,strong)UIButton *ectiveBtn;
@property (nonatomic)NSInteger ecttiv;
@property (nonatomic,strong)PickerShowView *ecttivePickerView;
@property (nonatomic,strong)BWTextView *birefTextView;
@end

@implementation buyFabuViewController
{
    NSArray *_urlArr;
    BOOL isPicture;
}
@synthesize cellAry;
-(id)initWithModel:(BuyDetialModel *)model
{
    self=[super init];
    if (self) {
        self.model=model;
    }
    return self;
}
-(id)initWithsimelpeModel:(HotBuyModel *)model
{
    self=[super init];
    if (self) {
        self.simplemodel=model;
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.ecttiv=0;
    self.productTypeDataMArray = [NSMutableArray array];
    self.guige1Ary=[NSMutableArray array];
    self.cellAry=[NSMutableArray array];
    UIView *navView=[self makeNavView];
    [self.view addSubview:navView];
    self.accurateView =[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    
    [self creatAccurateView];
    self.simpleView =[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    [self.view addSubview:self.simpleView];
    [self creatSimpleView];
    if(self.model)
    {
        [self.simpleView removeFromSuperview];
        [self.view addSubview:self.accurateView];

        [self editingMyBuy];
    }else{
        if (self.simplemodel) {
            [self.accurateView removeFromSuperview];
            [self.view addSubview:self.simpleView];
        }
    }
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        if (self.nameBtn.selected==YES) {
            self.nameBtn.selected=NO;
        }
    }
}
-(void)reloadViewWithFrame:(CGRect)frame
{
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(frame))];
}

-(void)editingMyBuy
{
    self.titleTextField.text=self.model.title;
    self.nameTextField.text=self.model.productName;
    self.nameBtn.selected=YES;
    self.productName=self.nameTextField.text;
    [self getEditingMessage];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.nowTextField=textField;
}
-(void)nextBtnAction:(UIButton *)sender
{
    if (self.titleTextField.text.length==0) {
        [ToastView showTopToast:@"标题不能为空"];
        return;
    }
    if (self.nameBtn.selected==NO) {
        [ToastView showTopToast:@"请先确认苗木名称"];
        return;
    }
    if(!self.productUid)
    {
        [ToastView showTopToast:@"该苗木不存在"];
        return;
    }
    NSMutableArray *screenTijiaoAry=[NSMutableArray array];
    for (NSDictionary *dic in self.addImageView.urlMArr) {
        NSLog(@"%@",dic);
    }
    BOOL canrun = [self.guigeView  getAnswerAry:screenTijiaoAry];
    if (canrun) {

    }else{
        return;
    }
    
    if (self.baseMessageDic) {
        YLDBuyFabuViewController *yldBuyFabuViewController=[[YLDBuyFabuViewController alloc]initWithUid:self.model.uid Withtitle:self.titleTextField.text WithName:self.nameTextField.text WithproductUid:self.productUid WithGuigeAry:screenTijiaoAry andBaseDic:self.baseMessageDic];
        yldBuyFabuViewController.imageAry=self.addImageView.urlMArr;
        [self.navigationController pushViewController:yldBuyFabuViewController animated:YES];
    }else
    {
        YLDBuyFabuViewController *yldBuyFabuViewController=[[YLDBuyFabuViewController alloc]initWithUid:self.model.uid Withtitle:self.titleTextField.text WithName:self.nameTextField.text WithproductUid:self.productUid WithGuigeAry:screenTijiaoAry];
        yldBuyFabuViewController.imageAry=self.addImageView.urlMArr;
        [self.navigationController pushViewController:yldBuyFabuViewController animated:YES];
    }
   

}
//1. 整形判断

- (BOOL)isPureInt:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}




//2.浮点形判断：

- (BOOL)isPureFloat:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return [scan scanFloat:&val] && [scan isAtEnd];
    
}
-(void)backRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavSColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"backBtnBlack"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:80 bottom:10 left:10];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:NavTitleColor];
    [titleLab setTextAlignment:NSTextAlignmentCenter];

    
    [titleLab setFont:[UIFont systemFontOfSize:NavTitleSize]];
    [view addSubview:titleLab];
    if(self.model||self.simplemodel)
    {
        [titleLab setText:@"求购编辑"];
    }else
    {
        [titleLab setText:@"求购发布"];
        UIButton *fabuTypeBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-80, 26, 70, 30)];
        [fabuTypeBtn setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
        [fabuTypeBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [fabuTypeBtn setTitle:@"简易发布" forState:UIControlStateNormal];
        [fabuTypeBtn setTitle:@"精确发布" forState:UIControlStateSelected];
        [fabuTypeBtn addTarget:self action:@selector(fabuTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        fabuTypeBtn.selected=YES;
        [view addSubview:fabuTypeBtn];
    }

    return view;
}
-(void)fabuTypeBtnAction:(UIButton *)sender
{
    if (sender.selected==YES) {
        [self.simpleView removeFromSuperview];
        [self.view addSubview:self.accurateView];
    }else{
        [self.accurateView removeFromSuperview];
        [self.view addSubview:self.simpleView];

    }
    sender.selected=!sender.selected;
}
- (void)getTreeSHUXINGWithBtn:(UIButton *)sender
{
    [self.guige1Ary removeAllObjects];
    if (self.guigeView) {
        [self.guigeView removeFromSuperview];
        self.guigeView=nil;
    }
    
    [HTTPCLIENT huoqumiaomuGuiGeWithTreeName:self.nameTextField.text andType:@"1" andMain:@"0" Success:^(id responseObject) {
        if (![[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showToast:[responseObject objectForKey:@"msg"]
                     withOriginY:66.0f
                   withSuperView:APPDELEGATE.window];
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
            sender.selected=YES;
            NSDictionary *dics=[responseObject objectForKey:@"result"];
            self.productUid=[dics objectForKey:@"productUid"];
            NSArray *guigeAry=[dics objectForKey:@"list"];
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

           // [self sortListWithAry:guigeAry WithSortAry:self.guige1Ary WithLeve:1]; 多级规格递归排序
            
            self.hintView.hidden=NO;
            GuiGeView *guigeView=[[GuiGeView alloc]initWithAry:self.guige1Ary andFrame:CGRectMake(0,CGRectGetMaxY(self.hintView.frame), kWidth, 0)];
            [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(guigeView.frame))];
            guigeView.delegate=self;
            self.guigeView=guigeView;
            [self.backScrollView addSubview:guigeView];
        }

    } failure:^(NSError *error) {
        
    }];
}
-(void)sortListWithAry:(NSArray *)ary WithSortAry:(NSMutableArray *)SortAry WithLeve:(NSInteger)leve
{
    if (SortAry.count<=0) {
        return;
    }
    NSMutableArray *modelAry=[NSMutableArray array];
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        if ([[dic objectForKey:@"level"] integerValue]==leve) {
            GuiGeModel *guigeModel=[GuiGeModel creatGuiGeModelWithDic:dic];
            [modelAry addObject:guigeModel];
            for (int j=0; j<SortAry.count; j++) {
                GuiGeModel *guigeModel1=SortAry[j];
                for (int k=0 ; k<guigeModel1.propertyLists.count; k++) {
                    Propers *proper=guigeModel1.propertyLists[k];
                    if ([proper.relation isEqualToString:guigeModel.uid]) {
                        proper.guanlianModel=guigeModel;
                    }
                }
            }
        }
    }
    [self sortListWithAry:ary WithSortAry:modelAry WithLeve:leve+1];

}
-(void)getEditingMessage
{
    
    [self.guige1Ary removeAllObjects];
    if (self.guigeView) {
        [self.guigeView removeFromSuperview];
        self.guigeView=nil;
    }
    
        [HTTPCLIENT myBuyEditingWithUid:self.model.uid Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                //NSLog(@"%@",responseObject);
                NSDictionary *dic=[[responseObject objectForKey:@"result"] objectForKey:@"ProductSpec"];
                self.productUid=[dic objectForKey:@"productUid"];
                self.productName=[dic objectForKey:@"productName"];
                self.baseMessageDic=[[responseObject objectForKey:@"result"] objectForKey:@"baseMsg"];
                NSArray *ary=[dic objectForKey:@"bean"];
                [self creatSCreeningCellsWithAnswerWithAry:ary];
                
                //处理图片数组
                NSArray *imagesAry            = [[responseObject objectForKey:@"result"] objectForKey:@"images"];
                NSArray *imagesCompressAry    = [[responseObject objectForKey:@"result"] objectForKey:@"imagesCompress"];
                NSArray *imagesDetailAry      = [[responseObject objectForKey:@"result"] objectForKey:@"imagesDetail"];
                if (imagesDetailAry.count==0) {
                    imagesDetailAry=imagesCompressAry;
                }
                NSMutableArray *imagesUrlMAry = [NSMutableArray array];
                for (int i = 0; i < imagesAry.count; i++) {
                    
                    
                                NSMutableDictionary *dics= [NSMutableDictionary dictionary];
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
                                dics[@"url"]         =url;
                                dics[@"compressurl"] = compressurl;
                                dics[@"detailurl"]   = detailurl;
                                [imagesUrlMAry addObject:dics];
                    
                };
                self.addImageView.urlMArr = imagesUrlMAry;
               
            }else
            {
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
   
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
   // [self sortListWithAry:guigeAry WithSortAry:self.guige1Ary WithLeve:1]; 多级规格递归排序
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
    self.hintView.hidden=NO;
    GuiGeView *guigeView=[[GuiGeView alloc]initWithValueAry:self.guige1Ary andFrame:CGRectMake(0, CGRectGetMaxY(self.hintView.frame), kWidth, 0)];
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(guigeView.frame))];
    guigeView.delegate=self;
    self.guigeView=guigeView;
    [self.backScrollView addSubview:guigeView];

}
-(void)nameBtnAction:(UIButton *)sender
{
    [self.nameTextField resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    if (sender.selected) {
        [self requestProductType];
        return;
    }
    self.productName=self.nameTextField.text;
    [self getTreeSHUXINGWithBtn:sender];
}
-(void)cellBeginEditing:(UITextField *)field
{
    self.nowTextField=field;
}

-(void)hidingKey
{
    if (self.nowTextField) {
        [self.nowTextField resignFirstResponder];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hidingKey];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)requestProductType {
    [HTTPCLIENT getTypeInfoSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 1 ) {
            NSArray *typeListArray = [[responseObject objectForKey:@"result"] objectForKey:@"typeList"];
            if (typeListArray.count == 0) {
                [ToastView showTopToast:@"暂时没有产品信息!"];
            }
            else if (typeListArray.count > 0) {
                self.productTypeDataMArray = (NSMutableArray *)typeListArray;
                [self showSideView];
            }
        }
        else if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            
        }
    } failure:^(NSError *error) {

    }];
}

- (void)showSideView {
    if (!self.sideView) {
        self.sideView = [[ZIKSideView alloc] initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight)];
    }
    self.sideView.selectView.type = @"1";
    self.sideView.pleaseSelectLabel.text = @"请选择苗木";
    self.sideView.selectView.uidDelegate = self;
    self.sideView.dataArray = self.productTypeDataMArray;
    self.sideView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:.3 animations:^{
        self.sideView.frame = CGRectMake(0, 0, kWidth, kHeight);
    }];
    [self.view addSubview:self.sideView];
}

- (void)didSelectorUid:(NSString *)selectId title:(NSString *)selectTitle {
    self.nameTextField.text = selectTitle;
    self.productName=self.nameTextField.text;
    self.nameBtn.selected=NO;
    [self nameBtnAction:self.nameBtn];
    [self.sideView removeSideViewAction];
    self.sideView=nil;
}
- (void)creatSimpleView {
  UIScrollView  *backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64-64)];
    [self.simpleView setBackgroundColor:BGColor];
    [self.simpleView addSubview:backScrollView];
    CGRect tempFrame=CGRectMake(0,0, kWidth, 44);
    UIView *titleView=[[UIView alloc]initWithFrame:tempFrame];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, kWidth*0.25, 44)];
    [titleLab setTextColor:titleLabColor];
    [titleLab setFont:[UIFont systemFontOfSize:15]];
    [titleView addSubview:titleLab];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    titleLab.text=@"标题";
    YLDRangeTextField *titleTextField=[[YLDRangeTextField alloc]initWithFrame:CGRectMake(kWidth*0.27, 0, kWidth*0.6, 44)];
    titleTextField.placeholder=@"请输入标题";
    titleTextField.rangeNumber=20;
    [titleTextField setTextColor:detialLabColor];
    titleTextField.tag=111;
    self.simpletitleTextField=titleTextField;
    
    [titleTextField setFont:[UIFont systemFontOfSize:15]];
    [titleView addSubview:titleTextField];
    
    UIImageView *lineImagVz=[[UIImageView alloc]initWithFrame:CGRectMake(15, 43.5, kWidth-30, 0.5)];
    [lineImagVz setBackgroundColor:kLineColor];
    [titleView addSubview:lineImagVz];
    
    [backScrollView addSubview:titleView];
    tempFrame.origin.y+=44;
    UIView *ecttiveView=[[UIView alloc]initWithFrame:tempFrame];
    [ecttiveView setBackgroundColor:[UIColor whiteColor]];
    UILabel *ecttNameLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, 44)];
    [ecttiveView addSubview:ecttNameLab];
    UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(15, 43.5, kWidth-30, 0.5)];
    [lineImagV setBackgroundColor:kLineColor];
    [ecttiveView addSubview:lineImagV];
    [backScrollView addSubview:ecttiveView];
    [ecttNameLab setText:@"有效期"];
    [ecttNameLab setTextColor:titleLabColor];
    [ecttNameLab setFont:[UIFont systemFontOfSize:15]];
    UIButton *ecttiveBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*0.27, 0, kWidth*0.72, 44)];
    ecttiveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [ecttiveView addSubview:ecttiveBtn];
    [ecttiveBtn setTitle:@"请选择有效期" forState:UIControlStateNormal];
    [ecttiveBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    self.ectiveBtn=ecttiveBtn;
    [ecttiveBtn addTarget:self action:@selector(ecttiveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [ecttiveBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UILabel *birefLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 105, 70, 20)];
    [birefLab setTextColor:titleLabColor];
    [birefLab setFont:[UIFont systemFontOfSize:15]];
    [birefLab setText:@"求购信息"];
    [backScrollView addSubview:birefLab];
    YLDRangeTextView *textView=[[YLDRangeTextView alloc]initWithFrame:CGRectMake(15, 132, kWidth-30, 180)];
    textView.rangeNumber=500;
    [textView setFont:[UIFont systemFontOfSize:15]];
    [textView setTextColor:detialLabColor];
    self.birefTextView=textView;
    textView.placeholder=@"请输入求购信息，包括树种名称、规格要求、求购数量、苗源地、价格等信息。提交后系统会根据输入内容转换为标准求购信息。";
    [backScrollView addSubview:textView];
    UILabel *tishiLab=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(textView.frame)+5, kWidth-40, 20)];
    [tishiLab setFont:[UIFont systemFontOfSize:15]];
    tishiLab.numberOfLines=0;
    [tishiLab setTextColor:RedBtnColor];
    [tishiLab setText:@"提示：你所发布的简易求购会由后台工作人员审核后自动转换为一条或多条标准求购信息。"];
    [tishiLab sizeToFit];
    [backScrollView addSubview:tishiLab];
    [backScrollView setContentSize:CGSizeMake(0,CGRectGetMaxY(tishiLab.frame)+5)];
    UIButton *tijiaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-60-64, kWidth-80, 44)];
    [self.simpleView addSubview:tijiaoBtn];
    [tijiaoBtn setBackgroundColor:NavColor];
    [tijiaoBtn setTitle:@"确认发布" forState:UIControlStateNormal];
    [tijiaoBtn addTarget:self action:@selector(tijiaoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (self.simplemodel) {
        titleTextField.text=self.simplemodel.title;
        self.birefTextView.text=self.simplemodel.details;
        self.ecttiv=self.simplemodel.effectiveTime;
        NSArray *ectivAry= @[@"一天",@"三天",@"五天",@"一周",@"半个月",@"一个月",@"三个月",@"半年",@"一年",@"长期"];
        NSInteger index=0;
        switch (self.simplemodel.effectiveTime) {
            case 6:
                index=0;
                break;
            case 7:
                index=1;
                break;
            case 8:
                index=2;
                break;
            case 9:
                index=3;
                break;
            case 10:
                index=4;
                break;
            case 2:
                index=5;
                break;
            case 3:
                index=6;
                break;
            case 4:
                index=7;
                break;
            case 5:
                index=8;
                break;
            case 1:
                index=9;
                break;
            default:
                self.ecttiv=0;
                break;
        }
        [self.ectiveBtn setTitle:ectivAry[index] forState:UIControlStateNormal];

    }
   
}
-(void)tijiaoBtnAction
{
    if (self.simpletitleTextField.text.length<=0) {
        [ToastView showTopToast:@"请输入求购标题"];
        return;
    }
    if (self.ecttiv==0) {
        [ToastView showTopToast:@"请选择有效期"];
        return;
    }
    if (self.birefTextView.text.length==0) {
        [ToastView showTopToast:@"请输入求购信息"];
        return;
    }
    [HTTPCLIENT simplebuyWithUid:self.simplemodel.uid Wtihtitle:self.simpletitleTextField.text WitheffectiveTime:[NSString stringWithFormat:@"%ld",self.ecttiv] Withdetails:self.birefTextView.text Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"发布成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)ecttiveBtnAction
{

    [self.simpletitleTextField resignFirstResponder];
    [self.birefTextView resignFirstResponder];
    if (!self.ecttivePickerView) {
        self.ecttivePickerView=[[PickerShowView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.ecttivePickerView resetPickerData:@[@"一天",@"三天",@"五天",@"一周",@"半个月",@"一个月",@"三个月",@"半年",@"一年",@"长期"]];
        
        self.ecttivePickerView.delegate=self;
    }
    [self.ecttivePickerView showInView];
}
-(void)selectInfo:(NSString *)select
{
    [self.ectiveBtn setTitle:select forState:UIControlStateNormal];
}
-(void)selectNum:(NSInteger)select
{
    switch (select) {
        case 0:
            self.ecttiv=6;
            break;
        case 1:
            self.ecttiv=7;
            break;
        case 2:
            self.ecttiv=8;
            break;
        case 3:
            self.ecttiv=9;
            break;
        case 4:
            self.ecttiv=10;
            break;
        case 5:
            self.ecttiv=2;
            break;
        case 6:
            self.ecttiv=3;
            break;
        case 7:
            self.ecttiv=4;
            break;
        case 8:
            self.ecttiv=5;
            break;
        case 9:
            self.ecttiv=1;
            break;
        default:
            self.ecttiv=0;
            break;
    }
    
}
- (void)creatAccurateView {
    [self.accurateView setBackgroundColor:BGColor];
    self.backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64-64)];
    [self.accurateView addSubview:self.backScrollView];
    [self.backScrollView setBackgroundColor:BGColor];
    CGRect tempFrame=CGRectMake(0,0, kWidth, 44);
    UIView *titleView=[[UIView alloc]initWithFrame:tempFrame];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, kWidth*0.25, 44)];
    [titleLab setTextColor:titleLabColor];
    [titleLab setFont:[UIFont systemFontOfSize:15]];
    [titleView addSubview:titleLab];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    titleLab.text=@"标题";
    UITextField *titleTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.27, 0, kWidth*0.6, 44)];
    titleTextField.placeholder=@"请输入标题";
    [titleTextField setTextColor:detialLabColor];
    titleTextField.tag=111;
    [titleTextField setFont:[UIFont systemFontOfSize:15]];
    
    self.titleTextField=titleTextField;
    UIImageView *titleLineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-20, 0.5)];
    [titleLineView setBackgroundColor:kLineColor];
    [titleView addSubview:titleLineView];
    [titleView addSubview:titleTextField];
    titleTextField.delegate=self;
    titleTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.backScrollView addSubview:titleView];
    
    ZIKAddImageView *pickView = [[ZIKAddImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), Width, (Width-60)/3 + 45) image:[UIImage imageNamed:@"添加图片"]];
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
    
    tempFrame.origin.y=CGRectGetMaxY(pickView.frame)+5;
    UIView *nameView=[[UIView alloc]initWithFrame:tempFrame];
    [nameView setBackgroundColor:[UIColor whiteColor]];
    [self.backScrollView addSubview:nameView];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, kWidth*0.25, 44)];
    nameLab.text=@"苗木名称";
    [nameLab setTextColor:[UIColor darkGrayColor]];
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    [nameLab setTextColor:titleLabColor];
    [nameView addSubview:nameLab];
    UITextField *nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.30, 0, kWidth*0.6, 44)];
    nameTextField.placeholder=@"请输入苗木名称";
    
    nameTextField.textColor=NavColor;
    [nameTextField setFont:[UIFont systemFontOfSize:14]];
    nameTextField.delegate=self;
    [nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.nameTextField=nameTextField;
    [nameView addSubview:nameTextField];
    UIButton *nameBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 9, 50, 25)];
    [nameBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    [nameView addSubview:nameBtn];
    [nameBtn addTarget:self action:@selector(nameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [nameBtn setImage:[UIImage imageNamed:@"treeNameSure"] forState:UIControlStateNormal];
    [nameBtn setImage:[UIImage imageNamed:@"treeNameSure2"] forState:UIControlStateSelected];
    UIImageView *nameLineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-10, 0.5)];
    [nameLineView setBackgroundColor:kLineColor];
    [nameView addSubview:nameLineView];
    self.nameBtn=nameBtn;
    ZIKHintTableViewCell *hintView = [[[NSBundle mainBundle] loadNibNamed:@"ZIKHintTableViewCell" owner:self options:nil] lastObject];
    hintView.frame = CGRectMake(0, CGRectGetMaxY(nameView.frame)+5, Width, HINT_VIEW_HEIGHT);
    hintView.hintStr = @"输入的越详细,匹配度越高";
    hintView.hidden = YES;
    hintView.contentView.backgroundColor = BGColor;
    [self.backScrollView addSubview:hintView];
    _hintView = hintView;
    UIButton *nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-60-64, kWidth-80, 44)];
    [self.accurateView addSubview:nextBtn];
    [nextBtn setBackgroundColor:NavColor];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tapgest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidingKey)];
    [self.backScrollView addGestureRecognizer:tapgest];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%ld",(long)buttonIndex);
    if(alertView.tag == 300)//是否退出编辑
    {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)backBtnAction:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要退出编辑？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    //[[UIView appearance]setTintColor:titleLabColor];
    [alert show];
    alert.tag = 300;
    alert.delegate = self;

    //[self.navigationController popViewControllerAnimated:YES];
}
-(void)openMenu
{
    [self.titleTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    
    //在这里呼出下方菜单按钮项
    self.myActionSheet = [[UIActionSheet alloc]
                          initWithTitle:nil
                          delegate:self
                          cancelButtonTitle:@"取消"
                          destructiveButtonTitle:nil
                          otherButtonTitles: @"拍摄新照片", @"从相册中选取",nil];
    
    [self.myActionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.myActionSheet) {
        //呼出的菜单按钮点击后的响应
        if (buttonIndex == self.myActionSheet.cancelButtonIndex)
        {
            //取消
        }
        switch (buttonIndex)
        {
            case 0:  //打开照相机拍照
                [self takePhoto];
                break;
                
            case 1:  //打开本地相册
                [self LocalPhoto];
                break;
        }
    }else {
        
    }
    //isPicture = YES;
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
        
        //先把图片转成NSData
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
            imageData = UIImageJPEGRepresentation(image, 0.0001);
            put.contentType=@"image/jpeg";
            put.objectKey =[NSString stringWithFormat:@"%@.jpeg",nameStr];
        }
        if (imageData.length>=1024*1024) {
            CGSize newSize = {200,140};
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
                result[@"compressurl"]=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
                result[@"detailurl"]=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
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
            imageData = UIImageJPEGRepresentation(image, 0.0001);
            put.contentType=@"image/jpeg";
            put.objectKey =[NSString stringWithFormat:@"%@.jpeg",nameStr];
        }
        if (imageData.length>=1024*1024) {
            CGSize newSize = {200,140};
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
                result[@"compressurl"]=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
                result[@"detailurl"]=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
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
        [picker dismissViewControllerAnimated:YES completion:nil];

    
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
        CGSize newSize = {200,140};
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
