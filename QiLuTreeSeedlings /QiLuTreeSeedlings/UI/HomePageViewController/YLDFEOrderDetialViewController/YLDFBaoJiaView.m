//
//  YLDFBaoJiaView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/13.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFBaoJiaView.h"
#import "UIDefines.h"
@implementation YLDFBaoJiaView
+(YLDFBaoJiaView *)yldFBaoJiaView
{
    YLDFBaoJiaView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDFBaoJiaView" owner:self options:nil] firstObject];
    view.frame=CGRectMake(0, 0, kWidth, kHeight);
    view.hidden=YES;
    view.baojiaBtn.layer.masksToBounds =YES;
    view.baojiaBtn.layer.cornerRadius=view.baojiaBtn.frame.size.height/2;
    return view;
}
- (IBAction)imageBtnAction:(UIButton *)sender {
    [self openMenu];
    
}
- (IBAction)baojiaBtnAction:(UIButton *)sender {
    if (self.baojiaTextField.text.length==0) {
        [ToastView showTopToast:@"请输入报价"];
        return;
    }
    if (self.guigeTextField.text.length==0) {
        [ToastView showTopToast:@"请输入规格说明"];
        return;
    }
    if (self.imageUrl==0) {
        [ToastView showTopToast:@"请上传图片"];
        return;
    }
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    NSMutableDictionary *imageDic=[NSMutableDictionary dictionary];
    imageDic[@"attaType"]=@"picture";
    imageDic[@"path"]=self.imageUrl;
    NSArray *attas=@[imageDic];
    dic[@"attas"]=attas;
    dic[@"demand"]=self.guigeTextField.text;
    dic[@"quoteType"]=@"order";
    dic[@"quote"]=self.baojiaTextField.text;
    dic[@"oibId"]=self.model.engineeringProcurementItemId;
    [self hidingSelf];
    if (self.delegate) {
        [self.delegate itemsBaojiaActionWithModel:self.model withDic:dic];
    }
    
}

- (IBAction)closeBtnAction:(UIButton *)sender {
    [self hidingSelf];
}
-(void)hidingSelf
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        self.hidden=YES;
        [self removeFromSuperview];
    }];
}
-(void)show
{
    self.hidden=NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)openMenu
{
    [self.baojiaTextField resignFirstResponder];
    [self.guigeTextField resignFirstResponder];
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
    
    [self.controller presentViewController:alertController animated:YES completion:nil];
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
        [self.controller presentViewController:picker animated:YES completion:nil];
        
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
    [self.controller presentViewController:pickerImage animated:YES completion:^{

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
            
            NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"member/image/%@",access_token] WithTypeStr:@"quote"];
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
                        
                        self.imageUrl=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
