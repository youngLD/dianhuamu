//
//  YLDJJRenShenQing1ViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/1.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRenShenQing1ViewController.h"
#import "YLDJJRSQtXView.h"
#import "YLDJJRSRView.h"
#import "YLDJJRSCSFView.h"

#import "YLDJJRTSView.h"
#import "UIImageView+AFNetworking.h"
#import "RSKImageCropper.h"
#import "ZIKVoucherCenterViewController.h"
@interface YLDJJRenShenQing1ViewController ()<UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate,UITextFieldDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong)UIScrollView *backScrollView;
@property (nonatomic,strong)UIImageView *txV;
@property (nonatomic,copy)NSString  *txurl;
@property (nonatomic,strong)YLDRangeTextField *IDcardField;
@property (nonatomic,copy)NSString *roleApplyAuditId;
@end

@implementation YLDJJRenShenQing1ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ( self.navigationController.navigationBar.hidden==NO) {
        self.navigationController.navigationBar.hidden=YES;
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"经纪人认证";
//    [YLDJJRTSView showAction];
    CGRect tempframe;
    self.backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-80)];
    [self.backScrollView setBackgroundColor:BGColor];
    [self.view addSubview:self.backScrollView];
    UIView *wareV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    UIImageView *iamgeV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    [iamgeV setImage:[UIImage imageNamed:@"注意"]];
    [wareV addSubview:iamgeV];
    UILabel *wareLab=[[UILabel alloc]initWithFrame:CGRectMake(33, 0, kWidth-40, 50)];
    [wareLab setFont:[UIFont systemFontOfSize:15]];
    [wareLab setTextAlignment:NSTextAlignmentLeft];
    wareLab.numberOfLines=2;
    [wareLab setTextColor:NavYellowColor];
    wareLab.text=@"您所提供的所有资料只做认证使用，系统保证用户资料的安全!";
    [wareV addSubview:wareLab];
    [self.backScrollView addSubview:wareV];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 50, kWidth, 140)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    
    YLDJJRSQtXView *txv=[YLDJJRSQtXView yldJJRSQtXView];
    self.txV=txv.txImageV;
    tempframe=txv.frame;
    tempframe.size.width=kWidth;
    txv.frame=tempframe;
    [txv.actionBtn addTarget:self action:@selector(txAction) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:txv];
  
  
    YLDJJRSRView *JJRSRView3=[YLDJJRSRView yldJJRSRView];
    JJRSRView3.textField.rangeNumber=18;
    JJRSRView3.textField.keyboardType=UIKeyboardTypeNumberPad;
    JJRSRView3.titleLab.text=@"员工编号";
    tempframe=JJRSRView3.frame;
    tempframe.origin.y=80;
    tempframe.size.width=kWidth;
    JJRSRView3.textField.placeholder=@"请输入员工编号";
    JJRSRView3.frame=tempframe;
    self.IDcardField=JJRSRView3.textField;
    [view1 addSubview:JJRSRView3];
    [self.backScrollView addSubview:view1];
   
  
    UIButton *nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-60, kWidth-80, 40)];
    [nextBtn setBackgroundColor:NavColor];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view setBackgroundColor:BGColor];
    if (self.dic) {
        NSDictionary *brokerApply=self.dic[@"brokerApply"];
        self.IDcardField.text=brokerApply[@"csNumber"];
        self.txurl=brokerApply[@"photo"];
        self.roleApplyAuditId=brokerApply[@"roleApplyAuditId"];
        [self.txV setImageWithURL:[NSURL URLWithString:self.txurl]];
    }
    
}

-(void)txAction
{

    [self openMenu];
}

-(void)nextBtnAction
{
    if(self.txurl.length==0)
    {
        [ToastView showTopToast:@"请上传我的工作照(个人半身照)"];
        return;
    }
   

    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"photo"]=self.txurl;

    dic[@"csNumber"]=self.IDcardField.text;

    NSString *bodyStr= [ZIKFunction convertToJsonData:dic];
    ShowActionV();
    if (self.roleApplyAuditId) {
        [HTTPCLIENT jjrShenHetuihuiWithRoleApplyAuditId:self.roleApplyAuditId WithBodyStr:bodyStr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"提交成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [HTTPCLIENT jjrshenheWithDic:bodyStr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                
                [ToastView showTopToast:@"提交成功"];
                [self.navigationController popViewControllerAnimated:NO];
                if (self.deleagte) {
                    [self.deleagte jjrTiJiaoSuccessWithDic:responseObject];
                }
                
                //            dispatch_async(dispatch_get_main_queue(), ^{
                
                RemoveActionV();
                //                [ToastView showTopToast:@"提交资料中，请两分钟内勿关闭应用或网络"];
                
                
                //            });
            }else{
                RemoveActionV();
                [ToastView showTopToast:@"请求失败"];
            }
        } failure:^(NSError *error) {
            RemoveActionV();
        }];

    }
    
}
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
    
    NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"member/image/%@",APPDELEGATE.userModel.access_id] WithTypeStr:@"agent"];
   
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
                self.txurl=urlstr;
                [self.txV setImage:croppedImage];
                
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
