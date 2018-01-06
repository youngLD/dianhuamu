//
//  ZIKAddHonorViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/4.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKAddHonorViewController.h"
#import "RSKImageCropper.h"
#import "UIButton+AFNetworking.h"
#import "YLDPickTimeView.h"
#import "ZIKFunction.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface ZIKAddHonorViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,YLDPickTimeDelegate>


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
//@property (nonatomic) NSInteger type;
//@property (nonatomic,strong)GCZZModel *model;


@property (nonatomic,assign)NSInteger modelType;


@end

@implementation ZIKAddHonorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"添加荣誉";
    UIScrollView *backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    [backScrollView setBackgroundColor:BGColor];
    self.backScrollView=backScrollView;
    [self.view addSubview:backScrollView];
    CGRect tempFrame=CGRectMake(0, 5, kWidth, 50);
    
    self.typeBtn=[self danxuanViewWithName:@"资料类型" alortStr:@"请选择资料类型" andFrame:tempFrame];
    [self.typeBtn addTarget:self action:@selector(modelTypeAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self reloadBackScrollView];
    if (self.miaoqiModel) {
        if ([self.miaoqiModel.type isEqualToString:@"个人荣誉"]) {
            self.modelType=4;
            [self reloadBackScrollView];
        }
        self.nameTextField.text=self.miaoqiModel.name;
//        self.rankTextField.text=self.model.level;
    
        self.timeStr=self.miaoqiModel.acquisitionTime;
        [self.timeBtn setTitle:self.miaoqiModel.acquisitionTime forState:UIControlStateNormal];
        self.compressurl=self.miaoqiModel.image;
        [self.imageBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.miaoqiModel.image] placeholderImage:[UIImage imageNamed:@"添加图片"]];
        [self.typeBtn setTitle:_miaoqiModel.type forState:UIControlStateNormal];
    }
    
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

-(void)modelTypeAction
{
    NSString *title = NSLocalizedString(@"资料类型", nil);
    NSString *message = NSLocalizedString(@"请选择资料类型。", nil);
 
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"营业执照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
        self.modelType=1;
        [self.typeBtn setTitle:@"营业执照" forState:UIControlStateNormal];
        [self reloadBackScrollView];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"办公场所" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.modelType=2;
        [self.typeBtn setTitle:@"办公场所" forState:UIControlStateNormal];
        [self reloadBackScrollView];
    }];
    UIAlertAction *other2Action = [UIAlertAction actionWithTitle:@"苗圃" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.modelType=3;
        [self.typeBtn setTitle:@"苗圃" forState:UIControlStateNormal];
        [self reloadBackScrollView];
    }];
    UIAlertAction *other3Action = [UIAlertAction actionWithTitle:@"个人荣誉" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.modelType=4;
        [self.typeBtn setTitle:@"个人荣誉" forState:UIControlStateNormal];
        [self reloadBackScrollView];
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [alertController addAction:other2Action];
    [alertController addAction:other3Action];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)reloadBackScrollView
{
    int i=1;
    for(UIView *view in [self.backScrollView subviews])
    {
        if (i!=1) {
            [view removeFromSuperview];
        }
        i++;
        
    }
    self.timeStr=nil;
    self.compressurl=nil;
    self.url=nil;
    CGRect tempFrame=CGRectMake(0, 5, kWidth, 50);
    tempFrame.origin.y+=50;
    self.nameTextField=[self makeViewWithName:@"资料名称" alert:@"请输入资料名称" unit:@"" withFrame:tempFrame];
    self.nameTextField.tag=20;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.nameTextField];
    if (self.modelType==4) {
        tempFrame.origin.y+=50;
        self.timeBtn=[self danxuanViewWithName:@"获取时间" alortStr:@"请选择获取时间" andFrame:tempFrame];
        [self.timeBtn addTarget:self action:@selector(timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    
    tempFrame.origin.y+=55;
    tempFrame.size.height=110;
    UIView *phoneView=[[UIView alloc]initWithFrame:tempFrame];
    [phoneView setBackgroundColor:[UIColor whiteColor]];
    [self.backScrollView addSubview:phoneView];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWidth*0.3, 44)];
    nameLab.text=@"资料图片";
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    
    [phoneView addSubview:nameLab];
    UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*0.35, 10, 85, 90)];
    [phoneView addSubview:imageBtn];
    [imageBtn addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.imageBtn=imageBtn;
    [imageBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    imageBtn.tag=3;
    tempFrame.origin.y+=130;
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
    
    if (self.modelType==0) {
        [ToastView showTopToast:@"请选择资料类型"];
        return;
    }
    if (self.nameTextField.text.length<=0) {
        [ToastView showTopToast:@"请输入资料名称"];
        return;
    }
    if (self.modelType==4) {
        if (self.timeStr.length<=0) {
            [ToastView showTopToast:@"请选择获得时间"];
            return;
        }
        
    }
    if (self.compressurl.length<=0) {
        [ToastView showTopToast:@"请上传资料图片"];
        return;
    }
    

        NSString *typeStr;
        switch (self.modelType) {
            case 1:
                typeStr=@"营业执照";
                break;
            case 2:
                typeStr=@"办公场所";
                break;
            case 3:
                typeStr=@"苗圃";
                break;
            case 4:
                typeStr=@"个人荣誉";
                break;
           
            default:
                break;
        }
        NSString *uid = nil;
        if (self.workstationUid) {
            uid = self.uid;
            [HTTPCLIENT stationHonorCreateWithUid:uid workstationUid:_workstationUid name:self.nameTextField.text acquisitionTime:self.timeStr image:self.compressurl  Type:typeStr Success:^(id responseObject) {
                //CLog(@"result:%@",responseObject);
                if ([responseObject[@"success"] integerValue] == 0) {
                    [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                    return ;
                }
                [ToastView showTopToast:@"添加成功"];
                [self.navigationController popViewControllerAnimated:YES];
    
            } failure:^(NSError *error) {
                ;
            }];
    
        }
    
        if (self.miaoqiUid) {
            uid = self.miaoqiUid;
            if (self.memberUid) {
                uid = self.memberUid;
            }
            //type:营业执照、办公场所和苗圃、个人荣誉
            [HTTPCLIENT cooperationCompanyHonorsCreateWithUid:uid type:typeStr name:self.nameTextField.text acquisitionTime:self.timeStr image:self.compressurl Success:^(id responseObject) {
                //CLog(@"result:%@",responseObject);
                if ([responseObject[@"success"] integerValue] == 0) {
                    [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                    return ;
                }
                [ToastView showTopToast:@"添加成功"];
                [self.navigationController popViewControllerAnimated:YES];
    
            } failure:^(NSError *error) {
                ;
            }];
        }
        if (self.type==4||self.type==5) {
            [HTTPCLIENT updatagoldSupplierHonordetialUid:self.jinpaiUid withName:self.nameTextField.text withacquisitionTime:self.timeStr withimage:self.compressurl withType:typeStr Success:^(id responseObject) {
                if ([responseObject[@"success"] integerValue] == 0) {
                    [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                    return ;
                }
                [ToastView showTopToast:@"添加成功"];
                [self.navigationController popViewControllerAnimated:YES];
    
            } failure:^(NSError *error) {
                
            }];
        }

    
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
-(void)imageBtnAction:(UIButton *)sender
{
    [self addPicture];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 添加荣誉图片事件
//添加荣誉图片事件
- (void)addPicture
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"添加荣誉图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄新照片",@"从相册选取", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1) {

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
    }else if (buttonIndex == 0) {

        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
         UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{

        }];
    }

}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //修改图片
    [self chooseUserPictureChange:image];
}

#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;

}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    [self requestUploadHeadImage:croppedImage];
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
  }

- (void)chooseUserPictureChange:(UIImage*)image
{
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
    imageCropVC.cropMode = RSKImageCropModeSquare;
    imageCropVC.delegate = self;
    imageCropVC.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:imageCropVC animated:YES];
}

#pragma mark - 请求上传头像
- (void)requestUploadHeadImage:(UIImage *)image {
    NSData* imageData;
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(image)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(image);
    }else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(image, 0.0001);
    }
    if (imageData.length>=1024*1024) {
        if (image.size.width>800 && image.size.height>558) {
            CGSize newSize = {300,200};
            imageData =  [self imageWithImageSimple:image scaledToSize:newSize];

        } else {
            CGFloat mywidth = image.size.width/2;
            CGFloat myheight = image.size.height/2;
            CGSize newSize = {mywidth,myheight};
            imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
        }
    }
    NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];

    [HTTPCLIENT upDataImageIOS:myStringImageFile workstationUid:nil companyUid:nil type:@"3" saveTyep:@"1" Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
            [ToastView showTopToast:@"添加成功"];
            NSDictionary *result = responseObject[@"result"];
            self.compressurl   = result[@"compressurl"];
            self.url         = result[@"url"];
            NSURL *url = [NSURL URLWithString:self.compressurl];
            [self.imageBtn setImageForState:UIControlStateNormal withURL:url placeholderImage:[UIImage imageNamed:@"添加图片"]];
        }


    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
//    NSData* imageData;
//    //判断图片是不是png格式的文件
//    if (UIImagePNGRepresentation(image)) {
//        //返回为png图像。
//        imageData = UIImagePNGRepresentation(image);
//    }else {
//        //返回为JPEG图像。
//        imageData = UIImageJPEGRepresentation(image, 0.0001);
//    }
//    if (imageData.length>=1024*1024) {
//        CGSize newSize = {600,600};
//        imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
//    }
//    NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
//
//
//    [HTTPCLIENT upDataImageIOS:myStringImageFile workstationUid:nil companyUid:nil type:@"3" saveTyep:@"1" Success:^(id responseObject) {
//        //        CLog(@"%@",responseObject);
//        if ([responseObject[@"success"] integerValue] == 0) {
//            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
//            return ;
//        } else if ([responseObject[@"success"] integerValue] == 1) {
//                        NSDictionary *result = responseObject[@"result"];
//                        self.honorCompressUrl = result[@"compressurl"];
//                        self.honorDetailUrl   = result[@"detailurl"];
//                        self.honorUrl         = result[@"url"];
//                        [self.addImageButton setBackgroundImage:image forState:UIControlStateNormal];
//
//        }
//    } failure:^(NSError *error) {
//        ;
//    }];


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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.honorNameTextField resignFirstResponder];
//    [self.honorTimeTextField resignFirstResponder];
}
@end
