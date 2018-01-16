//
//  YLDZiZhiAddViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZiZhiAddViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "YLDPickTimeView.h"
#import "UIButton+AFNetworking.h"
#import "RSKImageCropper.h"
#import "JSONKit.h"
@interface YLDZiZhiAddViewController ()<UINavigationControllerDelegate,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,YLDPickTimeDelegate>
@property (nonatomic,weak)UIScrollView *backScrollView;
@property (nonatomic,weak) UITextField *nameTextField;
@property (nonatomic,weak) UITextField *rankTextField;
@property (nonatomic,weak) UITextField *organizationalField;
@property (nonatomic,copy) NSString *timeStr;
@property (nonatomic,weak) UIButton *timeBtn;
@property (nonatomic,weak) UIButton *typeBtn;
@property (nonatomic,weak) UIButton *imageBtn;
@property (nonatomic,copy) NSString *compressurl;
@property (nonatomic,copy) NSString *url;
@property (nonatomic) NSInteger type;
@property (nonatomic,strong)GCZZModel *model;
@end

@implementation YLDZiZhiAddViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ( self.navigationController.navigationBar.hidden==NO) {
        self.navigationController.navigationBar.hidden=YES;
        
    }
}
-(id)initWithType:(NSInteger)type
{
    self=[super init];
    if (self) {
        self.type=type;
    }
    return self;
}
-(id)initWithModel:(GCZZModel *)model andType:(NSInteger )type
{
    self=[super init];
    if (self) {
        self.type=type;
        self.model=model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"资质添加";

    UIScrollView *backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    [backScrollView setBackgroundColor:BGColor];
    self.backScrollView=backScrollView;
    [self.view addSubview:backScrollView];

    [self reloadBackScrollView];
    if (self.dic) {
        NSDictionary *roleApplyAudit=self.dic[@"roleApplyAudit"];
        self.roleApplyAuditId=roleApplyAudit[@"roleApplyAuditId"];
        NSArray *engineeringCompanyApplies=self.dic[@"engineeringCompanyApplies"];
        if (engineeringCompanyApplies.count>0) {
            NSDictionary *dic=[engineeringCompanyApplies firstObject];
            self.nameTextField.text=dic[@"name"];
            self.rankTextField.text=dic[@"level"];
            self.organizationalField.text=dic[@"issuingAuthority"];;
//            self.timeStr=self.model.acqueTime;
//            [self.timeBtn setTitle:self.model.acqueTime forState:UIControlStateNormal];
            self.compressurl=dic[@"photo"];
            [self.imageBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"添加图片"]];
//            [self.typeBtn setTitle:self.model.type forState:UIControlStateNormal];
        }
    
//        self.imageBtn
    }
    // Do any additional setup after loading the view.
}

-(void)reloadBackScrollView
{
 
    CGRect tempFrame=CGRectMake(0, 5, kWidth, 50);
//    tempFrame.origin.y+=50;
    self.nameTextField=[self makeViewWithName:@"资质名称" alert:@"请输入名称" unit:@"" withFrame:tempFrame];
    self.nameTextField.tag=20;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.nameTextField];
   

//        tempFrame.origin.y+=50;
//        self.timeBtn=[self danxuanViewWithName:@"获取时间" alortStr:@"请选择获取时间" andFrame:tempFrame];
//        [self.timeBtn addTarget:self action:@selector(timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        tempFrame.origin.y+=50;
        self.rankTextField=[self makeViewWithName:@"资质等级" alert:@"请输入资质等级" unit:@"" withFrame:tempFrame];
        self.rankTextField.tag=10;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:self.rankTextField];
        tempFrame.origin.y+=50;
        self.organizationalField=[self makeViewWithName:@"发证机关" alert:@"请输入发证机关" unit:@"" withFrame:tempFrame];
    
    
   
    tempFrame.origin.y+=55;
    tempFrame.size.height=110;
    UIView *phoneView=[[UIView alloc]initWithFrame:tempFrame];
    [phoneView setBackgroundColor:[UIColor whiteColor]];
    [self.backScrollView addSubview:phoneView];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWidth*0.3, 44)];
    nameLab.text=@"资质图片";
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    
    [phoneView addSubview:nameLab];
    UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*0.35, 10, 85, 90)];
    [phoneView addSubview:imageBtn];
    [imageBtn addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.imageBtn=imageBtn;
    [imageBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    imageBtn.tag=3;
    tempFrame.origin.y+=150;
    tempFrame.size.height=45;
    tempFrame.origin.x=40;
    tempFrame.size.width=kWidth-80;
    UIButton *sureBtn=[[UIButton alloc]initWithFrame:tempFrame];
    [sureBtn setBackgroundColor:NavColor];
    sureBtn.tag=3;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget: self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:sureBtn];
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(tempFrame))];

}
-(void)sureBtnAction
{
    if (self.nameTextField.text.length<=0) {
        [ToastView showTopToast:@"请输入资质名称"];
        return;
    }

    if (self.rankTextField.text.length<=0) {
        [ToastView showTopToast:@"请输入资质等级"];
        return;
    }
        
    if (self.organizationalField.text.length<=0) {
        [ToastView showTopToast:@"请输入发证机关"];
        return;
    }
//    if (self.timeStr.length<=0) {
//        [ToastView showTopToast:@"请选择获得时间"];
//        return;
//    }

    if (self.compressurl.length<=0) {
        [ToastView showTopToast:@"请上传资质图片"];
        return;
    }
    if (self.type==1) {
        NSMutableDictionary *dic=[NSMutableDictionary new];
        dic[@"name"]=self.nameTextField.text;
        dic[@"level"]=self.rankTextField.text;
        dic[@"issuingAuthority"]=self.organizationalField.text;
        dic[@"photo"]=self.compressurl;
        NSMutableArray *honorData=[NSMutableArray array];
        [honorData addObject:dic];
        NSString *rongyuStr= [honorData JSONString];
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
 
    
   
}
-(void)imageBtnAction:(UIButton *)sender
{
    [self.nameTextField resignFirstResponder];
    [self.rankTextField resignFirstResponder];
    [self.organizationalField resignFirstResponder];
    [self openMenu];
}
-(UITextField *)makeViewWithName:(NSString *)name alert:(NSString *)alert unit:(NSString *)unit withFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWidth*0.3, frame.size.height)];
    nameLab.text=name;
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:nameLab];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.35, 3, kWidth*0.53, 44)];
    [textField setFont:[UIFont systemFontOfSize:15]];
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;

    textField.placeholder=alert;
    [view addSubview:textField];
    [textField setTextColor:detialLabColor];
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 49.5, kWidth-20, 0.5)];
    [lineView setBackgroundColor:kLineColor];
    [view addSubview:lineView];
    [self.backScrollView addSubview:view];
    view.tag=3;
    [view setBackgroundColor:[UIColor whiteColor]];
    return textField;
}

-(UIButton *)danxuanViewWithName:(NSString *)nameStr alortStr:(NSString *)alortStr andFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 90, frame.size.height)];
    [nameLab setText:nameStr];
    [view addSubview:nameLab];
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    UIButton *pickBtn=[[UIButton alloc]initWithFrame:CGRectMake(110, 0, 190/320.f*kWidth, frame.size.height)];
    pickBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    pickBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 17, 0, 0);
    [pickBtn setEnlargeEdgeWithTop:7 right:100 bottom:7 left:80];
    //[pickBtn setEnlargeEdgeWithTop:7 right:100 bottom:7 left:80];
    [pickBtn setTitle:alortStr forState:UIControlStateNormal];
    [pickBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    [pickBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(10,frame.size.height-0.5, kWidth-20, 0.5)];
    [lineImagV setBackgroundColor:kLineColor];
    [view addSubview:lineImagV];
    UIImageView *imageVVV=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-42.5, 15, 15, 15)];
    [imageVVV setImage:[UIImage imageNamed:@"xiala2"]];
    [view addSubview:imageVVV];
    
    [view addSubview:pickBtn];
    view.tag=3;
    [self.backScrollView addSubview:view];
    return pickBtn;
}
-(void)timeBtnAction:(UIButton *)sender
{
    YLDPickTimeView *pickTimeView=[[YLDPickTimeView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    pickTimeView.delegate=self;
    pickTimeView.pickerView.maximumDate=[NSDate new];
    pickTimeView.pickerView.minimumDate=nil;
    [pickTimeView showInView];
    [self.nameTextField resignFirstResponder];
    [self.rankTextField resignFirstResponder];
    [self.organizationalField resignFirstResponder];
}
-(void)timeDate:(NSDate *)selectDate andTimeStr:(NSString *)timeStr
{
    self.timeStr=timeStr;
    [self.timeBtn setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
    [self.timeBtn setTitle:timeStr forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 图片添加
//头像点击事件
-(void)openMenu
{
    
    __weak typeof(self)weakself =self;
    //在这里呼出下方菜单按钮项
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传视频或照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍摄新照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakself takePhoto];
        
    }]];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [weakself LocalPhoto];
    }]];

    
    [self presentViewController:alertController animated:YES completion:nil];
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
        //        isPicture  = YES;
    }else
    {
        //NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:^{
        
    }];
    
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self chooseUserPictureChange:image];
    
}
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    [ToastView showTopToast:@"正在上传图片"];
    ShowActionV();
    [self upDataIamge:croppedImage];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)chooseUserPictureChange:(UIImage*)image
{
    //UIImage *photo = [UIImage imageNamed:@"photo"];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
    imageCropVC.cropMode = RSKImageCropModeSquare;
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
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
#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)upDataIamge:(UIImage *)croppedImage
{
    //  [ToastView showTopToast:@"正在上传图片"];
    
    //    ShowActionV();
    //先把图片转成NSData
    __weak typeof(self) weakSelf=self;
    NSData *imageData;
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = @"miaoxintong";
    
    NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"member/image/%@",APPDELEGATE.userModel.access_token] WithTypeStr:@"engineeringZZ"];
    
    imageData=UIImagePNGRepresentation(croppedImage);
    
    NSString *urlstr;
    if (imageData) {
        put.objectKey = [NSString stringWithFormat:@"%@.png",nameStr];
        
    }else{
        put.objectKey = [NSString stringWithFormat:@"%@.jpeg",nameStr];
        
    }
    urlstr=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
    
    //        dispatch_sync(dispatch_get_main_queue(), ^{
    
    self.compressurl=urlstr;
//    [self.imageBtn  setTitleColor:croppedImage forState:UIControlStateNormal];
     [self.imageBtn  setImage:croppedImage forState:UIControlStateNormal];
    
    //        });
    
    if (imageData) {
        //返回为png图像。
        //        imageData = UIImagePNGRepresentation(croppedImage);
        put.contentType=@"image/png";
        
        
    }else {
        //返回为JPEG图像。
        
        imageData = UIImageJPEGRepresentation(croppedImage, 0.5);
        put.contentType=@"image/jpeg";
        
        
    }
    
    
    if (croppedImage.size.width>150) {
        CGFloat xD=150.f/croppedImage.size.width;
        CGSize newSize = {150,croppedImage.size.height*xD};
        imageData =  [self imageWithImageSimple:croppedImage scaledToSize:newSize];
        
    }
    
    put.uploadingData = imageData; // 直接上传NSData
    // 可选字段，可不设置
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
    };
    
    OSSTask * putTask = [APPDELEGATE.client putObject:put];
    RemoveActionV();
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            weakSelf.compressurl=urlstr;
        
            
        }
        return nil;
    }];
    
    
    
    
}

- (void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    NSInteger kssss=10;
    if (textField.tag>0) {
        kssss=textField.tag;
    }
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kssss) {
                // NSLog(@"最多%d个字符!!!",kMaxLength);
                [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",(long)kssss] withOriginY:250 withSuperView:self.view];
                //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] view:nil];
                textField.text = [toBeString substringToIndex:kssss];
                return;
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kssss) {
            [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",(long)kssss] withOriginY:250 withSuperView:self.view];
            textField.text = [toBeString substringToIndex:kssss];
            return;
        }
    }
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
