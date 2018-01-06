//
//  YLDWMSFBViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/5/22.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDWMSFBViewController.h"
#import "BWTextView.h"
#import "BigImageViewShowView.h"
#import "WHC_PhotoListCell.h"
#import "WHC_PictureListVC.h"

#import "YLDMSFAView.h"
#import "UIImageView+AFNetworking.h"
@interface YLDWMSFBViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIAlertViewDelegate,WHC_ChoicePictureVCDelegate,YLDMSFAViewDelegate>
@property (nonatomic,strong)UIView *vvvvvv;
@property (nonatomic,strong)UIScrollView *imageScrollView;
@property (nonatomic,strong) UIActionSheet   *myActionSheet;
@property (nonatomic,strong) NSMutableArray *imageVAry;
@property (nonatomic,strong) NSMutableArray *imageUrlAry;
@property (nonatomic,strong) UIButton *pickImageB;
@end

@implementation YLDWMSFBViewController
@synthesize imageVAry,imageUrlAry,pickImageB,imageScrollView;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        self.navigationController.navigationBar.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"微苗商";
    imageVAry = [NSMutableArray array];
    imageUrlAry=[NSMutableArray array];
    [self.backBtn removeFromSuperview];
    [self setRightBarBtnTitleString:@"发布"];
    __weak typeof(self) weakSelf = self;
  
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"backBtnBlack"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [self.navBackView addSubview:backBtn];

    [backBtn addTarget:self action:@selector(backbtnAction) forControlEvents:UIControlEventTouchUpInside];
    pickImageB =[[UIButton alloc]initWithFrame:CGRectMake(10, 10, (kWidth-40)/3, (kWidth-40)/3)];
    [pickImageB addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    [pickImageB setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    
    [self.view setBackgroundColor:BGColor];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 165+(kWidth-40)/3)];
    self.vvvvvv=view;
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    BWTextView *textview=[[BWTextView alloc]initWithFrame:CGRectMake(0, 5, kWidth, 140)];
    [textview setFont:[UIFont systemFontOfSize:23]];
    textview.placeholder=@"说点什么吧...";
    [view addSubview:textview];
    self.imageScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 155, kWidth, (kWidth-40)/3+20)];
    
    [self.imageScrollView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:self.imageScrollView];
    [imageScrollView addSubview:pickImageB];
    __weak typeof(self) weakself=self;
    self.rightBarBtnBlock = ^{
        if (textview.text.length<=0&&self.imageUrlAry.count<=0) {
            [ToastView showTopToast:@"请输入内容"];
        }else{
            NSMutableArray *attas=[NSMutableArray array];
            for (int i=0; i<weakself.imageUrlAry.count; i++) {
                NSMutableDictionary *imageDic=[NSMutableDictionary dictionary];
                imageDic[@"attaType"]=@"picture";
                NSString *urlStr=weakself.imageUrlAry[i];
                imageDic[@"path"]=urlStr;
                imageDic[@"sort"]=@"0";
                [attas addObject:imageDic];
            }
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            dic[@"attas"]=attas;
            dic[@"content"]=textview.text;
            NSString *bodyStr=[ZIKFunction convertToJsonData:dic];
            
            ShowActionV();
            [HTTPCLIENT weimiaoshangFabuWithBodyStr:bodyStr Success:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                     [ToastView showTopToast:@"发表成功"];
                     [weakSelf.navigationController popViewControllerAnimated:YES];
                 }
                 RemoveActionV();
            } failure:^(NSError *error) {
                RemoveActionV();
            }];

        }
       
    };
    // Do any additional setup after loading the view.
}
-(void)reloadImageVV
{
    [imageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if (self.imageVAry.count==0) {
        
        pickImageB.frame=CGRectMake(5, 10, (kWidth-40)/3, (kWidth-40)/3);
        [imageScrollView addSubview:pickImageB];
        imageScrollView.frame=CGRectMake(0, 155, kWidth, (kWidth-40)/3+20);
        self.vvvvvv.frame=CGRectMake(0, 64, kWidth, 165+(kWidth-40)/3);
    }else{
        for (int i=0; i<imageVAry.count; i++) {
            int zz=i/3;
            int xx=i%3;
            YLDMSFAView *vvv=imageVAry[i];
            vvv.tag=i;
            CGRect tempFrame=vvv.frame;
            tempFrame.origin.x=10+xx*(kWidth-40)/3+xx*10;
            tempFrame.origin.y=10+zz*(kWidth-40)/3+zz*10;
            vvv.frame=tempFrame;
            [imageScrollView addSubview:vvv];
       }
        NSInteger zz=imageVAry.count/3;
        NSInteger xx=imageVAry.count%3;
        if (imageVAry.count<9) {
            
            pickImageB.frame=CGRectMake(10+xx*(kWidth-40)/3+xx*10, 10+zz*(kWidth-40)/3+zz*10, (kWidth-40)/3, (kWidth-40)/3);
            [imageScrollView addSubview:pickImageB];
            
        }

        if (imageVAry.count<9) {
            zz++;
        }
        if (165+zz*(kWidth-20)/3+20+64>kHeight) {
            imageScrollView.frame=CGRectMake(0, 155, kWidth, kHeight-64-20-165);
            [imageScrollView setContentSize:CGSizeMake(0, zz*(kWidth-20)/3+20)];
            self.vvvvvv.frame=CGRectMake(0, 64, kWidth, kHeight-64-20);
        }else{
            imageScrollView.frame=CGRectMake(0, 155, kWidth, zz*(kWidth-20)/3+20);
            self.vvvvvv.frame=CGRectMake(0, 64, kWidth, 165+zz*(kWidth-20)/3+20);
       }
        
    }
}
-(void)deleteimagewithindex:(NSInteger)index{
    [self.imageUrlAry removeObjectAtIndex:index];
    [self.imageVAry removeObjectAtIndex:index];
    [self reloadImageVV];
}
-(void)openMenu
{

    
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
    vc.maxChoiceImageNumberumber = 9-self.imageUrlAry.count;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
//    isPicture  = YES;
}

#pragma mark - WHC_ChoicePictureVCDelegate
- (void)WHCChoicePictureVCdidSelectedPhotoArr:(NSArray *)photoArr{
    NSString *access_token = APPDELEGATE.userModel.access_token;
    OSSClient *client=APPDELEGATE.client;
    [ToastView showTopToast:@"正在上传图片，请稍后"];
    for (__weak UIImage *image in photoArr) {
        
        //先把图片转成NSData
        [self yasuotupianWithImage:image Success:^(NSData *imageData) {
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            // 必填字段
            put.bucketName = @"miaoxintong";
            
            NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"member/image/%@",access_token] WithTypeStr:@"circle"];
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
            __weak typeof(self) weakself=self;
            [putTask continueWithBlock:^id(OSSTask *task) {
                if (!task.error) {
                    //                NSLog(@"upload object success!");
                    
                    
                    NSString *urlstr=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        //Update UI in UI thread here
                        RemoveActionV();
                        [ToastView showTopToast:@"上传图片成功"];
                        [self.imageUrlAry insertObject:urlstr atIndex:0];
                        YLDMSFAView *vvv=[[YLDMSFAView alloc]initWithFrame:CGRectMake(0, 0, (kWidth-40)/3, (kWidth-40)/3)];
                        vvv.delegate=self;
                        [vvv.imageV setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
                        [weakself.imageVAry insertObject:vvv atIndex:0];
                        [weakself reloadImageVV];

                        
                    });
                    
                } else {
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
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        [ToastView showTopToast:@"正在上传图片，请稍等"];
        //先把图片转成NSData
        __weak  UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *imageData;
        
        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
        // 必填字段
        put.bucketName = @"miaoxintong";
        
        NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"member/image/%@",APPDELEGATE.userModel.access_token] WithTypeStr:@"circle"];
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            imageData = UIImagePNGRepresentation(image);
            put.contentType=@"image/png";
            put.objectKey = [NSString stringWithFormat:@"%@.png",nameStr];
        }else {
            //返回为JPEG图像。
            imageData = UIImageJPEGRepresentation(image, 0.01);
            put.contentType=@"image/jpeg";
            put.objectKey =[NSString stringWithFormat:@"%@.jpeg",nameStr];
        }
        if (imageData.length>=1024*1024) {
            CGSize newSize = {image.size.width*0.3,image.size.height*0.3};
            imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
        }
        put.uploadingData = imageData; // 直接上传NSData
        // 可选字段，可不设置
        put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
        };
        OSSTask * putTask = [APPDELEGATE.client putObject:put];
        __weak typeof(self) weakself=self;
        [putTask continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                //                NSLog(@"upload object success!");
                
                NSString *urlstr=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //Update UI in UI thread here
                    RemoveActionV();
                    [ToastView showTopToast:@"上传图片成功"];
                    [weakself.imageUrlAry insertObject:urlstr atIndex:0];
                    YLDMSFAView *vvv=[[YLDMSFAView alloc]initWithFrame:CGRectMake(0, 0, (kWidth-40)/3, (kWidth-40)/3)];
                        [vvv.imageV setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
                    vvv.delegate=self;
                    [weakself.imageVAry insertObject:vvv atIndex:0];
                    [weakself reloadImageVV];
//                    [self.addImageView addImage:[UIImage imageWithData:imageData]  withUrl:result];
                    
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
            imageData = UIImageJPEGRepresentation(image, 0.5);
            
        }
        if (image.size.width>250) {
            
            CGFloat xx=1.0;
            if(image.size.width>250)
            {
                xx=250.f/image.size.width;
            }
            CGSize newSize = {image.size.width*xx,image.size.height*xx};
            imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
        }
        success(imageData);
    });
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
        CGSize newSize = {myimage.size.width*0.5,myimage.size.height*0.5};
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

-(void)backbtnAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定取消编辑？" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakself=self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull      action) {
        
        [weakself.navigationController popViewControllerAnimated:YES];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
