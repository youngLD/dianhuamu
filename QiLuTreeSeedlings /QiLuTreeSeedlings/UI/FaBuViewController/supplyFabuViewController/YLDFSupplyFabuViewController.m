//
//  YLDFSupplyFabuViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/20.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFSupplyFabuViewController.h"
#import "WHC_PhotoListCell.h"
#import "WHC_PictureListVC.h"
#import "HttpClient.h"
#import "YLDFAddressManagementViewController.h"
#import "YLDFAddressListViewController.h"
#import "UIImageView+AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import "YLDFYYSURUView.h"
@interface YLDFSupplyFabuViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,
UITextFieldDelegate,YLDFAddressListViewControllerDelegate,YLDFAddressManagementDelegate,WHC_ChoicePictureVCDelegate,AVAudioPlayerDelegate>
@property (assign,nonatomic) NSInteger PicerNum;
@property (nonatomic,strong) NSMutableArray *imageUrlAry;
@property (nonatomic,copy) NSString *addressId;
@property (nonatomic,strong)UIButton *roundBtn;
@property (nonatomic,strong)AVAudioSession *session;
@property (nonatomic,strong)AVAudioRecorder *recorder;
@property (nonatomic,strong)AVAudioPlayer *player;
@property (nonatomic,strong) NSURL *recordFileUrl;
@property (nonatomic,copy) NSString *recordfilePath;
@property (nonatomic,copy) NSString *recordOssUrl;

@end

@implementation YLDFSupplyFabuViewController
@synthesize recordfilePath;
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    [self creatYYBtnView];
    _imageUrlAry=[NSMutableArray array];
//    _imageAry=[NSMutableArray array];
    if (APPDELEGATE.addressModel.addressId) {
        self.addressId=APPDELEGATE.addressModel.addressId;
        self.noAddresssBV.hidden=YES;
       self.personNameLab.text=APPDELEGATE.addressModel.linkman;
        self.phoneLab.text=APPDELEGATE.addressModel.phone;
        self.addressLab.text=APPDELEGATE.addressModel.area;
    }
    
    self.vcTitle=@"供应发布";
    self.btn2W.constant=(kWidth-40)/3;
    self.guigeTextView.placeholder=@"请输入苗木规格说明";
    self.keyWordTextView.placeholder=@"请输入关键词，例如：法桐 原生5-10厘米";
   
    // Do any additional setup after loading the view.
    [self.imageBtn1 addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBtn2 addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBtn3 addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
   self.lineV.image =   [ZIKFunction imageWithSize:self.lineV.frame.size borderColor:kLineColor borderWidth:1];
    self.addressBGV.image=[ZIKFunction  imageWithSize:self.addressBGV.frame.size borderColor:kLineColor borderWidth:1];
    [self.fabuActionBtn addTarget:self action:@selector(faubuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.deleteImage1Btn.hidden=YES;
    self.deleteImage2Btn.hidden=YES;
    self.deleteImage3Btn.hidden=YES;
    [self.deleteImage1Btn addTarget:self action:@selector(deleteImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteImage2Btn addTarget:self action:@selector(deleteImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteImage3Btn addTarget:self action:@selector(deleteImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.addAddressBtn addTarget:self action:@selector(addAddressBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.selectAddressBtn addTarget:self action:@selector(selectAddressBtnAction) forControlEvents:UIControlEventTouchUpInside];
    if (self.supplyId) {
        __weak typeof(self)weakSelf=self;
        [HTTPCLIENT mySupplyDetialWithSupplyId:self.supplyId Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *data=[responseObject objectForKey:@"data"];
                YLDFSupplyModel *model=[YLDFSupplyModel YLDFSupplyModelWithDic:data];
                self.model=model;
                self.addressId=model.addressId;
                self.nameTextField.text=model.productName;
                self.guigeTextView.text=model.demand;
                self.keyWordTextView.text=model.keywords;
                YLDFAddressModel *addressModel = [ZIKFunction GetAddressModelWithAddressId:self.addressId];
                if (addressModel.addressId.length>0) {
                    self.addressLab.text=addressModel.area;
                    self.personNameLab.text=addressModel.linkman;
                    self.phoneLab.text=addressModel.phone;
                }
                
                for (NSDictionary *dic in model.attacs) {
                    NSString *attaTypeId=dic[@"attaTypeId"];
                    if ([attaTypeId isEqualToString:@"picture"]) {
                        NSMutableDictionary *changeDic=[NSMutableDictionary dictionaryWithDictionary:dic];
                        [changeDic removeObjectForKey:@"supplyAttaId"];
                        [self.imageUrlAry addObject:changeDic];
                    }
                    if ([attaTypeId isEqualToString:@"audio"]) {
                        self.recordOssUrl=dic[@"path"];
                        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                        recordfilePath = [path stringByAppendingString:@"/RRecord.wav"];
                        self.GGH.constant=115+55;
                        self.YYBGview.hidden=NO;
                        //2.获取文件路径
                        _recordFileUrl = [NSURL fileURLWithPath:recordfilePath];
                        [HTTPCLIENT downNetFileWithdownUrl:self.recordOssUrl savePath:recordfilePath Success:^(id responseObject) {
                            
                        } failure:^(NSError *error) {
                            
                        }];
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
                        
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            [weakSelf audioSoundDuration:weakSelf.recordFileUrl];
                        });
                    }
                }
                [self deleteImageBtnAction:nil];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
   
}

-(void)faubuBtnAction
{
    if (self.nameTextField.text.length<=0) {
        [ToastView showTopToast:@"请输入苗木名称"];
        return;
    }
    if (self.guigeTextView.text.length<=0) {
        [ToastView showTopToast:@"请输入苗木规格"];
        return;
    }
    if (_imageUrlAry.count<3) {
        [ToastView showTopToast:@"照片/视频不得少于三张"];
        return;
    }
    if (self.addressId.length<=0) {
        [ToastView showTopToast:@"请选择地址"];
        return;
    }
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:self.nameTextField.text forKey:@"productName"];
    [dic setObject:self.guigeTextView.text forKey:@"demand"];
    [dic setObject:self.keyWordTextView.text forKey:@"keywords"];
    [dic setObject:self.addressId forKey:@"addressId"];
    NSMutableArray *attas=[NSMutableArray arrayWithArray:self.imageUrlAry];
    if (self.recordOssUrl) {
        NSMutableDictionary *lyDic=[NSMutableDictionary dictionary];
        lyDic[@"attaTypeId"]=@"audio";
        lyDic[@"path"]=self.recordOssUrl;
        [attas addObject:lyDic];
    }
    [dic setObject:attas forKey:@"attas"];
    NSString *bodyStr=[ZIKFunction convertToJsonData:dic];
    ShowActionV();
    [HTTPCLIENT supplyNewPushWithBody:bodyStr WithsupplyId:self.supplyId  Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"发布成功"];
            [APPDELEGATE getdefaultAddress];
            if(self.delegate)
            {
                [self.navigationController popViewControllerAnimated:NO];
                [self.delegate fabuSuccessWithSupplyId:[responseObject objectForKey:@"data"]];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)openMenu
{
    [self.guigeTextView resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.keyWordTextView resignFirstResponder];
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
//            isPicture  = YES;
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
//        isPicture  = YES;
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
    vc.maxChoiceImageNumberumber = 3-self.imageUrlAry.count;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
}

#pragma mark - WHC_ChoicePictureVCDelegate
- (void)WHCChoicePictureVCdidSelectedPhotoArr:(NSArray *)photoArr{
    NSString *access_token = APPDELEGATE.userModel.access_token;
    OSSClient *client=APPDELEGATE.client;
    [ToastView showTopToast:@"正在上传图片，请稍后"];
    for (__weak UIImage *image in photoArr) {
        self.PicerNum+=1;
      
        [self yasuotupianWithImage:image Success:^(NSData *imageData) {
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            // 必填字段
            put.bucketName = @"miaoxintong";
            
            NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"member/image/%@",access_token] WithTypeStr:@"supply"];
            if (UIImagePNGRepresentation(image)) {
                //返回为png图像。
                
                put.contentType=@"image/png";
                put.objectKey = [NSString stringWithFormat:@"%@.png",nameStr];
            }else {
                //返回为JPEG图像。
                
                put.contentType=@"image/jpeg";
                put.objectKey =[NSString stringWithFormat:@"%@.jpeg",nameStr];
            }
           
            put.uploadingData = imageData; // 直接上传NSData
            // 可选字段，可不设置
            put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
            };
            OSSTask * putTask = [client putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                if (!task.error) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        //Update UI in UI thread here
                        [ToastView showTopToast:@"上传图片成功"];
                        self.PicerNum-=1;
                        
                        
                        [self reloadWithImageV:[UIImage imageWithData:imageData] withUrl:[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey]];
                    });
                    
                } else {
                    //                NSLog(@"upload object failed, error: %@" , task.error);
                    [ToastView showTopToast:@"上传图片失败"];
                    
                }
                return nil;
            }];
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    NSString *access_token = APPDELEGATE.userModel.access_token;
    OSSClient *client=APPDELEGATE.client;
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        self.PicerNum+=1;
        //先把图片转成NSData
        
        __weak  UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.PicerNum+=1;
        
        [self yasuotupianWithImage:image Success:^(NSData *imageData) {
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            // 必填字段
            put.bucketName = @"miaoxintong";
            
            NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"member/image/%@",access_token] WithTypeStr:@"supply"];
            if (UIImagePNGRepresentation(image)) {
                //返回为png图像。
                
                put.contentType=@"image/png";
                put.objectKey = [NSString stringWithFormat:@"%@.png",nameStr];
            }else {
                //返回为JPEG图像。
                
                put.contentType=@"image/jpeg";
                put.objectKey =[NSString stringWithFormat:@"%@.jpeg",nameStr];
            }
            
            put.uploadingData = imageData; // 直接上传NSData
            // 可选字段，可不设置
            put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
            };
            OSSTask * putTask = [client putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                if (!task.error) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        //Update UI in UI thread here
                        [ToastView showTopToast:@"上传图片成功"];
                        self.PicerNum-=1;
                        
                        
                        [self reloadWithImageV:[UIImage imageWithData:imageData] withUrl:[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey]];
                    });
                    
                } else {
                    //                NSLog(@"upload object failed, error: %@" , task.error);
                    [ToastView showTopToast:@"上传图片失败"];
                    
                }
                return nil;
            }];
        } failure:^(NSError *error) {
            
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
-(void)yasuotupianWithImage:(UIImage *)image  Success:(void (^)(NSData *imageData))success
                    failure:(void (^)(NSError *error))failure
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData;
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            imageData = UIImagePNGRepresentation(image);
            
        }else {
            //返回为JPEG图像。
            imageData = UIImageJPEGRepresentation(image, 0.8);
            
        }
        if (image.size.width>550) {
            
            CGFloat xx=1.0;
            if(image.size.width>550)
            {
                xx=550.f/image.size.width;
            }
            CGSize newSize = {image.size.width*xx,image.size.height*xx};
            imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
            
        }
        success(imageData);
    });
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
    [self.guigeTextView resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.keyWordTextView resignFirstResponder];
    
}
-(void)reloadWithImageV:(UIImage *)image withUrl:(NSString *)urlStr
{
    if (_imageUrlAry.count>=3) {
        return;
    }
    if (_imageUrlAry.count==0) {
        self.deleteImage1Btn.hidden=NO;
        [self.imageV1 setImage:image];
//        [self.imageAry addObject:image];
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"path"]=urlStr;
        dic[@"attaTypeId"]=@"picture";
        [self.imageUrlAry addObject:dic];
    }else if (_imageUrlAry.count==1)
    {
        self.deleteImage2Btn.hidden=NO;
        [self.imageV2 setImage:image];
//        [self.imageAry addObject:image];
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"path"]=urlStr;
        dic[@"attaTypeId"]=@"picture";
        [self.imageUrlAry addObject:dic];
        
    }else if (_imageUrlAry.count==2)
    {
        self.deleteImage3Btn.hidden=NO;
        [self.imageV3 setImage:image];
//        [self.imageAry addObject:image];
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"path"]=urlStr;
        dic[@"attaTypeId"]=@"picture";
        [self.imageUrlAry addObject:dic];
    }
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    if (theTextField.text.length>0) {
        [HTTPCLIENT getProductNameWithPY:theTextField.text Success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}
-(void)selectAddressBtnAction
{
    YLDFAddressListViewController *vc=[YLDFAddressListViewController new];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)selectWithYLDFAddressModel:(YLDFAddressModel *)model{
    self.personNameLab.text=model.linkman;
    self.addressId=model.addressId;
    self.phoneLab.text=model.phone;
    self.addressLab.text=model.area;
}
-(void)deleteWithYLDFAddressModel:(YLDFAddressModel *)model{
    if ([self.addressId isEqualToString:model.addressId]) {
        self.personNameLab.text=@"请选择地址";
        self.phoneLab.text=@"请选择地址";
        self.personNameLab.text=@"请选择地址";
        self.addressId=nil;
    }
}
-(void)addAddressBtnAction
{
    YLDFAddressManagementViewController *vc=[YLDFAddressManagementViewController new];
    vc.delegate=self;
    vc.isDefault=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)addSuccessWithaddressDic:(NSDictionary *)addressdic
{
    [self.noAddresssBV removeFromSuperview];
    self.addressId=addressdic[@"addressId"];
    
 self.personNameLab.text=addressdic[@"linkman"];
    self.phoneLab.text=addressdic[@"phone"];
    self.addressLab.text=addressdic[@"area"];
}
-(void)deleteImageBtnAction:(UIButton *)sender
{
    if (sender.hidden==YES) {
        return;
    }
    if (sender.tag==1) {
        if (_imageUrlAry.count>=1) {
            [_imageUrlAry removeObjectAtIndex:0];
            
//            [_imageAry removeObjectAtIndex:0];
            
        }
    }
    if (sender.tag==2) {
        if (_imageUrlAry.count>=2) {
            [_imageUrlAry removeObjectAtIndex:1];
//            [_imageAry removeObjectAtIndex:1];
        }
    }
    if (sender.tag==3) {
        if (_imageUrlAry.count>=3) {
            [_imageUrlAry removeObjectAtIndex:2];
//            [_imageAry removeObjectAtIndex:2];
        }
    }
    
    [self.imageV1 setImage:[UIImage imageNamed:@"fabuaddImage"]];
    [self.imageV2 setImage:[UIImage imageNamed:@"fabumoreAddImage"]];
    [self.imageV3 setImage:[UIImage imageNamed:@"fabumoreAddImage"]];
    self.deleteImage1Btn.hidden=YES;
    self.deleteImage2Btn.hidden=YES;
    self.deleteImage3Btn.hidden=YES;
    for (int i=0;i<_imageUrlAry.count;i++) {
        NSDictionary *dic=_imageUrlAry[i];
        NSString *imageurl=dic[@"path"];
        if (i==0) {
            [self.imageV1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_lfit,h_100,w_100",imageurl]]];
            self.deleteImage1Btn.hidden=NO;
        }
        if (i==1) {
            [self.imageV2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_lfit,h_100,w_100",imageurl]]];
            self.deleteImage2Btn.hidden=NO;
        }
        if (i==2) {
            [self.imageV3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_lfit,h_100,w_100",imageurl]]];
            self.deleteImage3Btn.hidden=NO;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)YYPlayBtnAction:(UIButton *)sender {
    [self YYPlayAction];
}
- (IBAction)YYDeleteBtnAction:(id)sender {
    
    self.GGH.constant=115;
    self.YYBGview.hidden=YES;
    self.recordOssUrl=nil;
    self.recordfilePath=nil;
    self.recordFileUrl=nil;
}
-(void)longGesture:(UILongPressGestureRecognizer *)gesture

{
    
    int sendState = 0;
    
    CGPoint  point = [gesture locationInView:_roundBtn];
    
    if (point.y<0)
        
    {
        
        NSLog(@"松开手指，取消发送");
        
        sendState = 1;
        
    }
    
    else
        
    {
        
        //重新进入长按录音范围内
        
        sendState = 0;
        
    }
    
    //手势状态
    
    switch (gesture.state) {
            
        case UIGestureRecognizerStateBegan:
            
        {
            
            //NSLog(@"开始");
            
            NSLog(@"这里开始录音");
            [self startRecord];
        }
            
            break;
            
        case UIGestureRecognizerStateEnded:
            
        {
            
            //NSLog(@"长按手势结束");
            
            if (sendState == 0)
                
            {
                
                NSLog(@"结束录音并发送录音");
                [self stopRecord];
                [self upDataWithFieldPath:nil];
                self.GGH.constant=170;
                self.YYBGview.hidden=NO;
                
            }
            
            else
                
            {
                
                //向上滑动取消发送
                [ToastView showTopToast:@"您已取消录音"];
                [self stopRecord];
//                if (self.) {
//                    self.recordfilePath=nil;
//                    self.recordFileUrl=nil;
//                }
                
                NSLog(@"取消发送删除录音");
                
            }
            
        }
            
            break;
            
        case UIGestureRecognizerStateFailed:
            
            //NSLog(@"长按手势失败");
            
            break;
            
        default:
            
            break;
            
    }
    
}
-(void)startRecord
{
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if (session == nil) {
        
        NSLog(@"Error creating session: %@",[sessionError description]);
        
    }else{
        [session setActive:YES error:nil];
        
    }
    
    self.session = session;
    
    
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    recordfilePath = [path stringByAppendingString:@"/RRecord.wav"];
    
    //2.获取文件路径
    _recordFileUrl = [NSURL fileURLWithPath:recordfilePath];
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 11025.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityMedium],AVEncoderAudioQualityKey,
                                   nil];
    
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:_recordFileUrl settings:recordSetting error:nil];
    
    if (_recorder) {
        
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            self
            [self stopRecord];
        });
        
        
        
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
        
    }
    
    
}
-(void)stopRecord
{
    //    NSLog(@"停止录音");
    
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:recordfilePath]){
        
        //        _noticeLabel.text = [NSString stringWithFormat:@"录了 %ld 秒,文件大小为 %.2fKb",COUNTDOWN - (long)countDown,[[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1024.0];
        
    }else{
        
        //        _noticeLabel.text = @"最多录60秒";
        //        YYtimeLab.text
        
    }
    CGFloat yytime = [self audioSoundDuration:_recordFileUrl];
    self.YYtimeLab.text=[NSString stringWithFormat:@"%.0lf'",yytime];
    
}

-(void)YYPlayAction
{
    NSLog(@"播放录音");
    [self.recorder stop];
    
    if ([self.player isPlaying])return;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:nil];
    self.player.delegate=self;
    
    //    NSLog(@"%li",self.player.data.length/1024);
    
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player play];
    //    NSURL * url  = [NSURL URLWithString:@""];
    //    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    //    AVPlayer * player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    //    [player play];
    
    
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //         [timer invalidate]; //NSTimer暂停   invalidate  使...无效;
}
- (void)upDataWithFieldPath:(NSString *)fieldPath
{
    //  [ToastView showTopToast:@"正在上传图片"];
    
    //    ShowActionV();
    //先把图片转成NSData
    NSData *feildData =[NSData dataWithContentsOfURL:self.recordFileUrl];
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = @"miaoxintong";
    
    NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"supplys/record/%@",APPDELEGATE.userModel.access_token] WithTypeStr:@"supply"];
    
    NSString *urlstr;
    
    put.objectKey = [NSString stringWithFormat:@"%@.wav",nameStr];
    
    
    urlstr=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
    
    
    put.uploadingData = feildData; // 直接上传NSData
    // 可选字段，可不设置
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
    };
    
    OSSTask * putTask = [APPDELEGATE.client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.recordOssUrl=urlstr;
            });
            
        }
        return nil;
    }];
    
}
-(void)creatYYBtnView
{
    UIView *GGInputAccessoryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 80)];
    self.guigeTextView.inputAccessoryView =GGInputAccessoryView;

    UIView *GGWCV=[[UIView alloc]initWithFrame:CGRectMake(0, 40, kWidth, 40)];
    [GGWCV setBackgroundColor:[UIColor whiteColor]];
    UIButton *wanchengBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 0, 70, 40)];
    [wanchengBtn setTitle:@"完成" forState: UIControlStateNormal];
    [wanchengBtn setTitleColor:kRGB(0,121,253,1) forState:UIControlStateNormal];
    [wanchengBtn addTarget:self action:@selector(textViewDownAction) forControlEvents:UIControlEventTouchUpInside];
    [GGWCV addSubview:wanchengBtn];
    [GGInputAccessoryView addSubview:GGWCV];
    UILongPressGestureRecognizer * longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGesture:)];
    YLDFYYSURUView *view=[YLDFYYSURUView yldFYYSURUView];
    CGRect frame=view.frame;
    frame.size.width=kWidth;
    view.frame=frame;
    self.roundBtn=view.YYSRBtn;
    [GGInputAccessoryView addSubview:view];
    [view.YYSRBtn addGestureRecognizer:longGesture];
    self.YYPlayBtn.layer.masksToBounds=YES;
    self.YYPlayBtn.layer.cornerRadius=20;
    self.YYBGview.hidden=YES;
}
-(void)textViewDownAction
{
    [self.guigeTextView resignFirstResponder];
}
-(float)audioSoundDuration:(NSURL *)fileUrl{
    NSDictionary *options = @{AVURLAssetPreferPreciseDurationAndTimingKey: @YES};
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:fileUrl options:options];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
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
