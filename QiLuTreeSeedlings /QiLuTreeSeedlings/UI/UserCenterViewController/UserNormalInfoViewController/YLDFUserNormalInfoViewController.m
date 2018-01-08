//
//  YLDFUserNormalInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/26.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFUserNormalInfoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "RSKImageCropper.h"
#import "ZIKUserNameSetViewController.h"
@interface YLDFUserNormalInfoViewController ()<UINavigationControllerDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate>
@property (copy,nonatomic)NSString *txUrl;
@end

@implementation YLDFUserNormalInfoViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ( self.navigationController.navigationBar.hidden==NO) {
         self.navigationController.navigationBar.hidden=YES;
        
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.nameLab.text=APPDELEGATE.userModel.nickname;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    self.vcTitle=@"基本信息";
    self.heardImageV.layer.masksToBounds=YES;
    if (APPDELEGATE.userModel.headPortrait.length>0) {
       [self.heardImageV setImageWithURL:[NSURL URLWithString:APPDELEGATE.userModel.headPortrait]];
    }
     self.heardImageV.layer.cornerRadius=self.heardImageV.frame.size.height/2;
    [self.heardBtn addTarget:self action:@selector(heardIamgeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nameBtn addTarget:self action:@selector(nameBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.phoneBtn addTarget:self action:@selector(phoneBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.phoneLab.text=APPDELEGATE.userModel.partyId;
    // Do any additional setup after loading the view from its nib.
}
-(void)heardIamgeBtnAction
{
    [self openMenu];
}
-(void)nameBtnAction
{
    ZIKUserNameSetViewController *vc=[ZIKUserNameSetViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)phoneBtnAction
{
    
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
    NSData *imageData;
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = @"miaoxintong";
    
    NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"member/image/%@",APPDELEGATE.userModel.access_token] WithTypeStr:@"UserHeard"];
    
    imageData=UIImagePNGRepresentation(croppedImage);
 
    NSString *urlstr;
    if (imageData) {
        put.objectKey = [NSString stringWithFormat:@"%@.png",nameStr];
        
    }else{
        put.objectKey = [NSString stringWithFormat:@"%@.jpeg",nameStr];
        
    }
    urlstr=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
 
        //        dispatch_sync(dispatch_get_main_queue(), ^{
    
    self.txUrl=urlstr;
        [self.heardImageV setImage:croppedImage];
    
        
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
    
 
    if (croppedImage.size.width>200) {
        CGFloat xD=200.f/croppedImage.size.width;
        CGSize newSize = {200,croppedImage.size.height*xD};
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
                [HTTPCLIENT updataUserNormalInfoWithKey:@"headPortrait" WithValue:self.txUrl Success:^(id responseObject) {
                    if ([[responseObject objectForKey:@"success"] integerValue]) {
                        [ToastView showTopToast:@"修改头像成功"];
                    }else{
                        [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                    }
                } failure:^(NSError *error) {
                    
                }];
                
                
            });
            
        }
        return nil;
    }];
    
    
    
    
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
