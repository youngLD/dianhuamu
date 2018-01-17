    //
//  YLDShopBaseInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/26.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShopBaseInfoViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "YLDGCZXInfoTableViewCell.h"
#import "YLDGCZXTouxiangTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "YLDShopNameViewController.h"
#import "RSKImageCropper.h"
#import "YLDShopJianJieViewController.h"
#import "YLDShopPresonViewController.h"
#import "YLDShopPhoneViewController.h"
#import "LYDShopAddressViewController.h"
@interface YLDShopBaseInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)YLDGCZXTouxiangTableViewCell *touxiangCell;
@property (nonatomic,copy) NSDictionary *dic;
@property (nonatomic,copy) NSString *txUrl;
@end

@implementation YLDShopBaseInfoViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController.navigationBar.hidden==NO) {
        self.navigationController.navigationBar.hidden=YES;
    }
    [HTTPCLIENT getMyShopBaseMessageSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            self.dic=[responseObject objectForKey:@"data"];
            self.txUrl=self.dic[@"headPortrait"];
            [self.tableView reloadData];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"我的店铺";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
    [tableView setBackgroundColor:BGColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView=tableView;
    [self.view addSubview:tableView];
    ShowActionV();
    // Do any additional setup after loading the view.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [self addPicture];
    }
    if (indexPath.row==1) {
        YLDShopNameViewController *vc=[[YLDShopNameViewController alloc]initWithMessage:[self.dic objectForKey:@"name"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==2) {
        

    }
    if (indexPath.row==3) {
        YLDShopJianJieViewController *vc=[[YLDShopJianJieViewController alloc]initWithMessage:[self.dic objectForKey:@"description"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
    tableView.estimatedRowHeight = 50;
    return tableView.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
     
        YLDGCZXTouxiangTableViewCell *  cell=[YLDGCZXTouxiangTableViewCell yldGCZXTouxiangTableViewCell];

        cell.titleLab.text=@"店铺头像";
//        NSString *urlStr=[self.dic objectForKey:@"headPortrait"];
        if (self.txUrl.length>0) {
               [cell.imagev setImageWithURL:[NSURL URLWithString:self.txUrl] placeholderImage:[UIImage imageNamed:@"Store.png"]];
        }else{
            [cell.imagev setImage:[UIImage imageNamed:@"Store.png"]];
        }
   
        self.touxiangCell=cell;
        return cell;
    }else{
        YLDGCZXInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGCZXInfoTableViewCell"];
        if (!cell) {
            cell=[YLDGCZXInfoTableViewCell yldGCZXInfoTableViewCell];
        }
        if (indexPath.row==1) {
            cell.titleLab.text=@"店铺名称";
            NSString *name=[self.dic objectForKey:@"name"];
            if (name) {
                cell.NameLab.text=name;
            }
            
            
        }
        if (indexPath.row==2) {
            cell.titleLab.text=@"预览店铺";
            
        }
        if (indexPath.row==3) {
            cell.titleLab.text=@"店铺简介";
            NSString *description=[self.dic objectForKey:@"description"];
            if (description) {
                cell.NameLab.text=description;
            }
            
        }
  
           return cell;
        
        }
    
}
#pragma mark - 图片添加
//头像点击事件
- (void)addPicture
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"修改店铺头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄新照片",@"从相册选取", nil];
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
        //[self presentModalViewController:pickerImage animated:YES];
    }else if (buttonIndex == 0) {
        
        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
        //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
        //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        //[self presentModalViewController:picker animated:YES];//进入照相界面
    }
    
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //修改图片
    [self chooseUserPictureChange:image];
}

#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    
    [self upDataIamge:croppedImage];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseUserPictureChange:(UIImage*)image
{
    //UIImage *photo = [UIImage imageNamed:@"photo"];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeSquare];
    
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
}
#pragma mark - 请求上传图片

- (void)upDataIamge:(UIImage *)croppedImage
{
    //  [ToastView showTopToast:@"正在上传图片"];
    
    //    ShowActionV();
    //先把图片转成NSData
    NSData *imageData;
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = @"miaoxintong";
    
    NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"member/image/%@",APPDELEGATE.userModel.access_token] WithTypeStr:@"ShopHeader"];
    
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
    [self.touxiangCell.imagev setImage:croppedImage];
    
    
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
                NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                dic[@"headPortrait"]=self.txUrl;
                NSString *bodyStr=[ZIKFunction convertToJsonData:dic];
                
                [HTTPCLIENT getMyShopBaseMessageUpDataWithbodyStr:bodyStr Success:^(id responseObject) {
                    if ([[responseObject objectForKey:@"success"] integerValue]) {
                        [ToastView showTopToast:@"修改成功"];
                    }
                } failure:^(NSError *error) {
                    RemoveActionV();
                }];
                
                
            });
            
        }
        return nil;
    }];
    
    
    
    
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
