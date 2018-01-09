//
//  YLDFeedbackViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDFeedbackViewController.h"
#import "YLDRangeTextField.h"
#import "YLDRangeTextView.h"
#import "RSKImageCropper.h"
#import "UIButton+AFNetworking.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface YLDFeedbackViewController ()<UIActionSheetDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,weak) YLDRangeTextField *titleField;
@property (nonatomic,weak) YLDRangeTextView *messageField;
@property (nonatomic,weak) UIButton *imageBtn;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,weak) UIButton *deleteBtn;
@end

@implementation YLDFeedbackViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ( self.navigationController.navigationBar.hidden==NO) {
        self.navigationController.navigationBar.hidden=YES;
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"意见反馈";
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    [self.view addSubview:scrollView];
    [scrollView setBackgroundColor:BGColor];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 10, kWidth, 180)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:view1];
    UILabel *titleLabb=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 70, 30)];
    [titleLabb setTextColor:DarkTitleColor];
    [view1 addSubview:titleLabb];
    [titleLabb setTextAlignment:NSTextAlignmentRight];
    [titleLabb setFont:[UIFont systemFontOfSize:15]];
    [titleLabb setText:@"标题"];
    YLDRangeTextField *titleField=[[YLDRangeTextField alloc]initWithFrame:CGRectMake(110, 10, kWidth-130, 30)];
    titleField.rangeNumber=100;
    titleField.placeholder=@"请输入标题";
    self.titleField=titleField;
    [titleField setFont:[UIFont systemFontOfSize:15]];
    [titleField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [view1 addSubview:titleField];
    UIImageView *lineV1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 50, kWidth-20, 0.5)];
    [lineV1 setBackgroundColor:kLineColor];
    [view1 addSubview:lineV1];
    UILabel *messageLabb=[[UILabel alloc]initWithFrame:CGRectMake(20, 60, 70, 30)];
    [messageLabb setTextColor:DarkTitleColor];
    [view1 addSubview:messageLabb];
    [messageLabb setTextAlignment:NSTextAlignmentRight];
    [messageLabb setFont:[UIFont systemFontOfSize:15]];
    [messageLabb setText:@"反馈内容"];
    YLDRangeTextView *messageTextView=[[YLDRangeTextView alloc]initWithFrame:CGRectMake(106, 59, kWidth-130, 100)];
    messageTextView.placeholder=@"请输入内容";
    messageTextView.rangeNumber=3000;
    [messageTextView setFont:[UIFont systemFontOfSize:15]];
    self.messageField=messageTextView;
    [view1 addSubview:messageTextView];
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 200, kWidth, 100)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:view2];
    UILabel *imgLabb=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 70, 30)];
    [imgLabb setTextColor:DarkTitleColor];
    [view2 addSubview:imgLabb];
    [imgLabb setTextAlignment:NSTextAlignmentRight];
    [imgLabb setFont:[UIFont systemFontOfSize:15]];
    [imgLabb setText:@"图片"];
    UIButton *iamgeBtn=[[UIButton alloc]initWithFrame:CGRectMake(120, 10, 70, 80)];
    [iamgeBtn addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    [iamgeBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    [view2 addSubview:iamgeBtn];
    self.imageBtn = iamgeBtn;
    UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(50, 5, 15, 15)];
    [deleteBtn setImage:[UIImage imageNamed:@"delectLiteBtn"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    self.deleteBtn=deleteBtn;
    deleteBtn.hidden=YES;
    [iamgeBtn addSubview:deleteBtn];
    
    UIButton *tijiaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-110, 380, 220, 40)];
    [tijiaoBtn setBackgroundColor:NavColor];
    [tijiaoBtn setTitle:@"反馈" forState:UIControlStateNormal];
    [tijiaoBtn addTarget:self action:@selector(tijiaoBtnAcion) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:tijiaoBtn];
    [scrollView setContentSize:CGSizeMake(0, 410)];
    // Do any additional setup after loading the view.
}
-(void)tijiaoBtnAcion
{
    if (self.titleField.text.length<=0) {
        
        [ToastView showTopToast:@"请输入标题"];
        return;
    }
    if (self.messageField.text.length<=0) {
        
        [ToastView showTopToast:@"请输入内容"];
        return;
    }
    NSString *titleStr=self.titleField.text;
    titleStr=[titleStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (titleStr.length==0) {
        [ToastView showTopToast:@"标题不能为空格"];
        return;
    }
    NSString *messageStr=self.messageField.text;
    messageStr=[messageStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    messageStr=[messageStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (messageStr.length==0) {
        [ToastView showTopToast:@"内容不能为空格"];
        return;
    }
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"title"]=titleStr;
    dic[@"content"]=messageStr;
    dic[@"pic"]=self.url;
    NSString *bodyStr=[ZIKFunction convertToJsonData:dic];
    ShowActionV();
    [HTTPCLIENT yijianfankuiWithBodyStr:bodyStr Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"您的反馈已提交"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)deleteBtnAction
{
    [self.imageBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    self.url=nil;
    self.deleteBtn.hidden=YES;
}
#pragma mark - 图片添加
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
    //    [alertController addAction:[UIAlertAction actionWithTitle:@"拍摄新视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //
    //        [weakself takeVideo];
    //    }]];
    
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
        picker.allowsEditing = NO;
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

#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)upDataIamge:(UIImage *)croppedImage
{
    
    ShowActionV();
    //先把图片转成NSData
    NSData *imageData;
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = @"miaoxintong";
    
    NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"member/image/%@",APPDELEGATE.userModel.access_id] WithTypeStr:@"opinion"];
    
    imageData=UIImagePNGRepresentation(croppedImage);
    
    NSString *urlstr;
    if (imageData) {
        //返回为png图像。
        put.objectKey = [NSString stringWithFormat:@"%@.png",nameStr];
        imageData = UIImagePNGRepresentation(croppedImage);
        put.contentType=@"image/png";
    }else{
        //返回为JPEG图像。
        put.objectKey = [NSString stringWithFormat:@"%@.jpeg",nameStr];
        imageData = UIImageJPEGRepresentation(croppedImage, 0.5);
        put.contentType=@"image/jpeg";
    }
    urlstr=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
    
    
    RemoveActionV();
    
    if (croppedImage.size.width>150) {
        
        
        CGSize newSize = {150,150};
        imageData =  [self imageWithImageSimple:croppedImage scaledToSize:newSize];
        
    }
    
    put.uploadingData = imageData; // 直接上传NSData
    // 可选字段，可不设置
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
    };
    
    OSSTask * putTask = [APPDELEGATE.client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                //Update UI in UI thread here
                RemoveActionV();

                self.url=urlstr;
                [self.imageBtn setImage:croppedImage forState:UIControlStateNormal];
                
            });
            
        } else {
            //                NSLog(@"upload object failed, error: %@" , task.error);
            RemoveActionV();
            //            [ToastView showTopToast:@"上传图片失败"];
            
        }
        return nil;
    }];
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
