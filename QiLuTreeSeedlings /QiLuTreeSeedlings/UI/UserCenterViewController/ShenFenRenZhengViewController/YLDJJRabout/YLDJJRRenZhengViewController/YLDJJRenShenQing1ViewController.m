//
//  YLDJJRenShenQing1ViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/1.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRenShenQing1ViewController.h"
#import "YLDJJRenShenQing2ViewController.h"
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
@property (nonatomic,strong)YLDJJRSCSFView *sfV1;
@property (nonatomic,strong)YLDJJRSCSFView *sfV2;
@property (nonatomic,copy)NSString  *txurl;
@property (nonatomic,copy)NSString  *cardFurl;
@property (nonatomic,copy)NSString  *cardBurl;
@property (nonatomic,strong)YLDRangeTextField *xingmingField;
@property (nonatomic,strong)YLDRangeTextField *phoneField;
@property (nonatomic,strong)YLDRangeTextField *IDcardField;
@property (nonatomic,assign)NSInteger imageType;
@end

@implementation YLDJJRenShenQing1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"经纪人认证";
    [YLDJJRTSView showAction];
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
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 50, kWidth, 260)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    
    YLDJJRSQtXView *txv=[YLDJJRSQtXView yldJJRSQtXView];
    self.txV=txv.txImageV;
    tempframe=txv.frame;
    tempframe.size.width=kWidth;
    txv.frame=tempframe;
    [txv.actionBtn addTarget:self action:@selector(txAction) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:txv];
    
    YLDJJRSRView *JJRSRView1=[YLDJJRSRView yldJJRSRView];
    JJRSRView1.titleLab.text=@"姓名";
    self.xingmingField=JJRSRView1.textField;
    JJRSRView1.textField.placeholder=@"请输入姓名";
    JJRSRView1.textField.delegate=self;
    JJRSRView1.textField.rangeNumber=8;
    JJRSRView1.textField.tag=11;
    tempframe=JJRSRView1.frame;
    tempframe.origin.y=80;
    tempframe.size.width=kWidth;
    JJRSRView1.frame=tempframe;
    [view1 addSubview:JJRSRView1];
    
  
    YLDJJRSRView *JJRSRView3=[YLDJJRSRView yldJJRSRView];
    JJRSRView3.textField.rangeNumber=18;
    JJRSRView3.textField.keyboardType=UIKeyboardTypeNumberPad;
    JJRSRView3.titleLab.text=@"员工编号";
    tempframe=JJRSRView3.frame;
    tempframe.origin.y=140;
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
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==11) {
        NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic1 =  [userDefau objectForKey:@"jjrRenZheng"];
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:dic1];
        if (textField.text.length==0) {
            [dic  removeObjectForKey:@"name"];
        }else{
           dic[@"name"]=textField.text;
        }
        [userDefau setObject:dic forKey:@"jjrRenZheng"];
        [userDefau synchronize];
    }
    if (textField.tag==12) {
        NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic1 =  [userDefau objectForKey:@"jjrRenZheng"];
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:dic1];
        if (textField.text.length==0) {
            [dic removeObjectForKey:@"phone"];
        }else{
            dic[@"phone"]=textField.text;
        }
        [userDefau setObject:dic forKey:@"jjrRenZheng"];
        [userDefau synchronize];
    }
}
-(void)txAction
{
    self.imageType=1;
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


    ShowActionV();
    [HTTPCLIENT jjrshenheWithDic:dic Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {

            NSString *uid=[responseObject objectForKey:@"result"];
            dispatch_async(dispatch_get_main_queue(), ^{

                RemoveActionV();
                     [ToastView showTopToast:@"提交资料中，请两分钟内勿关闭应用或网络"         ];
                
                if (self.type==2) {
                   [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    ShowActionV();
                    [HTTPCLIENT jjrshenheGetMoneyNumSuccess:^(id responseObject) {
                        if ([[responseObject objectForKey:@"success"] integerValue]) {
                            ZIKVoucherCenterViewController *voucherVC = [[ZIKVoucherCenterViewController alloc] init];
                            voucherVC.price = [responseObject objectForKey:@"result"];
                            voucherVC.wareStr=@"支付认证费用(元):";
                            voucherVC.uid=uid;
                            voucherVC.infoType=6;
                            voucherVC.hidesBottomBarWhenPushed=YES;
                            [self.navigationController pushViewController:voucherVC animated:YES];
                        }else{
                            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                    
                }
                
            });
        }else{
            RemoveActionV();
            [ToastView showTopToast:@"请求失败"];
        }
    } failure:^(NSError *error) {
        RemoveActionV();
    }];

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
        
        if (self.imageType==1) {
            [self chooseUserPictureChange:image];
        }else{
            __weak typeof(self) blockself=self;
            [ToastView showTopToast:@"正在上传图片"];
            ShowActionV();
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 [blockself upDataIamge:image];
                });
        }
    
    
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
    
    NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"member/image/%@",APPDELEGATE.userModel.access_id] WithTypeStr:@"agent"];
   
    imageData=UIImagePNGRepresentation(croppedImage);
    NSMutableDictionary *imageDic=[NSMutableDictionary dictionary];
    NSString *imagePath;
    NSString *urlstr;
    if (imageData) {
         put.objectKey = [NSString stringWithFormat:@"%@.png",nameStr];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *ary=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"pathsOfRZImage"]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        //设置一个图片的存储路径
        imagePath = [path stringByAppendingString:[NSString stringWithFormat:@"/agent%ld.png",ary.count]];
        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        
        [imageDic setObject:[NSString stringWithFormat:@"/agent%ld.png",ary.count] forKey:@"path"];
        [imageDic setObject:put.objectKey forKey:@"name"];
        [imageDic setObject:@"image/png" forKey:@"type"];
        [ary addObject:imageDic];
        [userDefaults setObject:ary forKey:@"RZImageAry"];
        [userDefaults synchronize];
    }else{
         put.objectKey = [NSString stringWithFormat:@"%@.jpeg",nameStr];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *ary=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"pathsOfRZImage"]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        //设置一个图片的存储路径
        imagePath = [path stringByAppendingString:[NSString stringWithFormat:@"/agent%ld.jpeg",ary.count]];
        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        [imageDic setObject:[NSString stringWithFormat:@"/agent%ld.jpeg",ary.count] forKey:@"path"];
        [imageDic setObject:put.objectKey forKey:@"name"];
        [imageDic setObject:@"image/png" forKey:@"type"];
        [ary addObject:imageDic];
        [userDefaults setObject:ary forKey:@"RZImageAry"];
        [userDefaults synchronize];
    }
    urlstr=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
    if (self.imageType==1) {
//        dispatch_sync(dispatch_get_main_queue(), ^{
        RemoveActionV();
            self.txurl=urlstr;
            [self.txV setImage:croppedImage];
            NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic1 =  [userDefau objectForKey:@"jjrRenZheng"];
            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:dic1];
            if (urlstr.length==0) {
                [dic removeObjectForKey:@"photo"];
            }else{
                dic[@"photo"]=urlstr;
            }
            [userDefau setObject:dic forKey:@"jjrRenZheng"];
            [userDefau synchronize];
            
//        });
        
    }
    if (self.imageType==2) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            //Update UI in UI thread here
            RemoveActionV();
            self.cardFurl=urlstr;
            [self.sfV1.shangchuanImagV setImage:croppedImage];
            NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic1 =  [userDefau objectForKey:@"jjrRenZheng"];
            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:dic1];
            if (urlstr.length==0) {
                [dic removeObjectForKey:@"idCardPicFront"];
            }else{
                dic[@"idCardPicFront"]=urlstr;
            }
            [userDefau setObject:dic forKey:@"jjrRenZheng"];
            [userDefau synchronize];
            
            
        });
    }
    if (self.imageType==3) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            //Update UI in UI thread here
          RemoveActionV();
            self.cardBurl=urlstr;
            [self.sfV2.shangchuanImagV setImage:croppedImage];
            NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic1 =  [userDefau objectForKey:@"jjrRenZheng"];
            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:dic1];
            if (urlstr.length==0) {
                [dic removeObjectForKey:@"idCardPicBack"];
            }else{
                dic[@"idCardPicBack"]=urlstr;
            }
            [userDefau setObject:dic forKey:@"jjrRenZheng"];
            [userDefau synchronize];
            
            
        });
        
    }
    if (imageData) {
        //返回为png图像。
//        imageData = UIImagePNGRepresentation(croppedImage);
        put.contentType=@"image/png";

        
    }else {
        //返回为JPEG图像。
    
        imageData = UIImageJPEGRepresentation(croppedImage, 0.5);
        put.contentType=@"image/jpeg";
       
        
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [imageData writeToFile:imagePath atomically:YES];
    });

    if (imageData.length>=1024*1024&&self.imageType!=1) {
        NSInteger x=2;
        if (self.imageType!=1) {
            x=6;
        }
        CGFloat xD=(1024*1024.f)/(CGFloat)imageData.length*x;
        CGSize newSize = {croppedImage.size.width*xD,croppedImage.size.height*xD};
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
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *ary=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"RZImageAry"]];
                [ary removeObject:imageDic];
                [userDefaults setObject:ary forKey:@"RZImageAry"];
                [userDefaults synchronize];

                
            });
            
        } else {
            //                NSLog(@"upload object failed, error: %@" , task.error);
//            RemoveActionV();
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
