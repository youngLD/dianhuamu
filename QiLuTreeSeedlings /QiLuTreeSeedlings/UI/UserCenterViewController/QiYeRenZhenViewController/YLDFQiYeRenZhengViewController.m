//
//  YLDFQiYeRenZhengViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/4.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFQiYeRenZhengViewController.h"
#import "UIImageView+AFNetworking.h"
@interface YLDFQiYeRenZhengViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,copy)NSString *license;
@property (nonatomic,copy)NSString *roleApplyAuditId;
@end

@implementation YLDFQiYeRenZhengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        _topC.constant=54.0;
    }
    self.vcTitle=@"企业认证";
    if (self.dic) {
        NSDictionary *enterpriseApplydic=self.dic[@"enterpriseApply"];
        
        self.phoneTextfield.text=enterpriseApplydic[@"contactInformation"];
        self.license=enterpriseApplydic[@"license"];
        self.qiyeAddressTexfField.text=enterpriseApplydic[@"address"];
        self.qiyeNameTexfField.text=enterpriseApplydic[@"name"];
        self.qiyePersonTexfField.text=enterpriseApplydic[@"linkman"];
        self.roleApplyAuditId=enterpriseApplydic[@"roleApplyAuditId"];
        NSDictionary *roleApplyAuditDic=self.dic[@"roleApplyAudit"];
        [self.imageV setImageWithURL:[NSURL URLWithString:self.license]];
        self.resonLab.text=[NSString stringWithFormat:@"退回原因：%@",roleApplyAuditDic[@"auditReason"]];
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)ImageBtnAction:(UIButton *)sender {
    [self openMenu];
}
- (IBAction)tijiaoAction:(UIButton *)sender {
    if (self.qiyeNameTexfField.text.length==0) {
        [ToastView showTopToast:@"请输入企业名称"];
        return;
    }
    if (self.qiyeAddressTexfField.text.length==0) {
        [ToastView showTopToast:@"请输入企业地址"];
        return;
    }
    if (self.qiyePersonTexfField.text.length<2||self.qiyePersonTexfField.text.length>8) {
        [ToastView showTopToast:@"请输入企业法人"];
        return;
    }
    if (self.phoneTextfield.text.length==0) {
        [ToastView showTopToast:@"请输入企业联系方式"];
        return;
    }
    if (self.license.length==0) {
        [ToastView showTopToast:@"请添加营业执照"];
        return;
    }
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"address"]=self.qiyeAddressTexfField.text;
    dic[@"contactInformation"]=self.phoneTextfield.text;
    dic[@"linkman"]=self.qiyePersonTexfField.text;
    dic[@"name"]=self.qiyeNameTexfField.text;
    dic[@"license"]=self.license;
    if (self.roleApplyAuditId.length>0) {
     dic[@"roleApplyAuditId"]=self.roleApplyAuditId;
        NSString *bodyStr=[ZIKFunction convertToJsonData:dic];
        ShowActionV();
        [HTTPCLIENT enterpriseShenQingWithBodyStr:bodyStr WithroleApplyAuditId:self.roleApplyAuditId Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"提交资料成功，请耐心等待审核"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        ShowActionV();
        NSString *bodyStr=[ZIKFunction convertToJsonData:dic];
        [HTTPCLIENT enterpriseShenQingWithBodyStr:bodyStr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"提交资料成功，请耐心等待审核"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
}
-(void)openMenu
{
    [self.phoneTextfield resignFirstResponder];
    [self.qiyeNameTexfField resignFirstResponder];
    [self.qiyePersonTexfField resignFirstResponder];
    [self.qiyeAddressTexfField resignFirstResponder];
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
            
            NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"member/image/%@",access_token] WithTypeStr:@"enterprise"];
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
                        
                            self.license=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
                            [self.imageV setImage:[UIImage imageWithData:imageData]];
                      
                    });
                    
                } else {

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
