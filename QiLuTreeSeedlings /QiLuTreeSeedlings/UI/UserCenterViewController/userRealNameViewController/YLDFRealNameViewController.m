//
//  YLDFRealNameViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/4.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFRealNameViewController.h"
#import "UIImageView+AFNetworking.h"
@interface YLDFRealNameViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,copy)NSString *idCardPicBack;
@property (nonatomic,copy)NSString *idCardPicFront;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong) UIButton *nowBtn;
@property (nonatomic,copy)NSString *roleApplyAuditId;
@end

@implementation YLDFRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"实名认证";
    if (@available(iOS 11.0, *)) {
        _topC.constant=44.0;
    }
    self.nameTextField.rangeNumber=8;
    self.CareIDTextField.rangeNumber=18;
    if (self.dic) {
        NSDictionary *usersApply=self.dic[@"usersApply"];
        self.CareIDTextField.text=usersApply[@"idCard"];
        self.nameTextField.text=usersApply[@"name"];
        self.roleApplyAuditId=usersApply[@"roleApplyAuditId"];
        self.idCardPicBack=usersApply[@"idCardPicBack"];
        
        self.idCardPicFront=usersApply[@"idCardPicFront"];
        NSDictionary *roleApplyAudit=self.dic[@"roleApplyAudit"];
        self.resonLab.text=[NSString stringWithFormat:@"退回原因：%@",roleApplyAudit[@"auditReason"]];
        [self.zhengmianImageV setImageWithURL:[NSURL URLWithString:self.idCardPicFront]];
        [self.beimiamImageV setImageWithURL:[NSURL URLWithString:self.idCardPicBack]];
    }
}
- (IBAction)zhengmianBtnAction:(UIButton *)sender {
    self.nowBtn=sender;
    [self openMenu];
}
- (IBAction)beimianBtnAction:(UIButton *)sender {
    self.nowBtn=sender;
    [self openMenu];
}
- (IBAction)tijiaoBtnAction:(id)sender {
    if (_nameTextField.text.length==0) {
        [ToastView showTopToast:@"请输入姓名"];
        return;
    }
    if (self.nameTextField.text.length<2||self.nameTextField.text.length>8) {
        [ToastView showTopToast:@"姓名长度为2～8之间"];
        return;
    }
    if (_CareIDTextField.text.length!=18) {
        [ToastView showTopToast:@"请输入正确身份证号"];
        return;
    }
    if (self.idCardPicFront.length==0) {
        [ToastView showTopToast:@"请添加身份证正面照片"];
        return;
    }
    if (self.idCardPicBack.length==0) {
        [ToastView showTopToast:@"请添加身份证反面照片"];
        return;
    }
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"idCard"]=_CareIDTextField.text;
    dic[@"name"]=_nameTextField.text;
    dic[@"idCardPicBack"]=self.idCardPicBack;
    dic[@"idCardPicFront"]=self.idCardPicFront;
 
    NSString *bodyStr = [ZIKFunction convertToJsonData:dic];
    if (self.roleApplyAuditId) {
        [HTTPCLIENT upDataRealNameWithroleApplyAuditId:self.roleApplyAuditId bodyStr:bodyStr Success:^(id responseObject) {
            if([[responseObject objectForKey:@"success"] integerValue])
            {
                if([[responseObject objectForKey:@"success"] integerValue])
                {
                    [ToastView showTopToast:@"提交资料成功，请耐心等待审核"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [HTTPCLIENT realNameWithBodyStr:bodyStr Success:^(id responseObject) {
            if([[responseObject objectForKey:@"success"] integerValue])
            {
                if([[responseObject objectForKey:@"success"] integerValue])
                {
                    [ToastView showTopToast:@"提交资料成功，请耐心等待审核"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
}
-(void)openMenu
{
    [self.nameTextField resignFirstResponder];
    [self.CareIDTextField resignFirstResponder];
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
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];

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
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:^{
        
    }];
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
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    NSString *access_token = APPDELEGATE.userModel.access_token;
    OSSClient *client=APPDELEGATE.client;
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
//        self.PicerNum+=1;
        //先把图片转成NSData
        
        __weak  UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        self.PicerNum+=1;
        
        [self yasuotupianWithImage:image Success:^(NSData *imageData) {
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            // 必填字段
            put.bucketName = @"miaoxintong";
            
            NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"member/image/%@",access_token] WithTypeStr:@"RealName"];
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
                        if (self.nowBtn.tag==1) {
                            self.idCardPicFront=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
                            [self.zhengmianImageV setImage:[UIImage imageWithData:imageData]];
                        }else{
                            self.idCardPicBack=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
                            [self.beimiamImageV setImage:[UIImage imageWithData:imageData]];
                        }

//                        [self reloadWithImageV:[UIImage imageWithData:imageData] withUrl:[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey]];
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
