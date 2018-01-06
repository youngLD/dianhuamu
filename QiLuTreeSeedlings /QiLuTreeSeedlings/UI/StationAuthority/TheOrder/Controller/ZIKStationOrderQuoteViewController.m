//
//  ZIKStationOrderQuoteViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/25.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderQuoteViewController.h"
#import "BWTextView.h"
#import "ZIKQuoteTextField.h"
#import "ZIKFunction.h"
#import "RSKImageCropper.h"
#import "UIImageView+AFNetworking.h"
#import "StringAttributeHelper.h"
#import "ZIKHintTableViewCell.h"
#import "YLDPickLocationView.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
//#import "ZIKAddPickerView.h"
#import "ZIKPickImageView.h"

#import "WHC_PhotoListCell.h"
#import "WHC_PictureListVC.h"

@interface ZIKStationOrderQuoteViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,YLDPickLocationDelegate,WHC_ChoicePictureVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *quoteTableView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) BWTextView *contentTextView;

@property (nonatomic, strong) NSString *province;//省
@property (nonatomic, strong) NSString *city;//市
@property (nonatomic, strong) NSString *county;//县
@property (nonatomic, strong) NSString *town;//镇

@property (nonatomic, strong) UIButton *addressButton;
@property (nonatomic, strong) UIView   *addImageBGView;
//@property (nonatomic, strong) ZIKAddPickerView *pickerImgView;
@property (nonatomic, strong) UIActionSheet    *myActionSheet;
@property (nonatomic, strong  ) ZIKPickImageView *pickerImgView;

@property (nonatomic,strong) NSString *areaStr;
@end

@implementation ZIKStationOrderQuoteViewController
{
    UILabel *detailLabel;
    ZIKQuoteTextField *priceTextField;
    ZIKQuoteTextField *quantityTextField;
    //UIImageView    *_globalHeadImageView; //个人头像
    UIImage        *_globalHeadImage;
    UIImageView    *cellHeadImageView;
    UILabel        *cellNameLabel;
    UILabel        *cellPhoneLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    priceTextField = [[ZIKQuoteTextField alloc] init];
    quantityTextField = [[ZIKQuoteTextField alloc] init];
    _contentTextView = [[BWTextView alloc] init];


    self.vcTitle = @"报价";
    self.titleArray = @[@[@"苗木名称",@"苗木数量",@"报价要求",@"规格要求"],@[@"报价价格",@"可供数量",@"苗圃地址",@"报价说明"],@[@"苗木图片"]];
    self.quoteTableView.delegate   = self;
    self.quoteTableView.dataSource = self;
    ShowActionV();
    [HTTPCLIENT getstationBaoJiaMessageWithUid:self.uid Success:^(id responseObject) {
        RemoveActionV();
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *quote=[[responseObject objectForKey:@"result"] objectForKey:@"quote"];
//            /**
//             *  苗木名称
//             */

            self.name=quote[@"name"];
//            /**
//             *  苗木数量
//             */
            self.count=[NSString stringWithFormat:@"%@",quote[@"quantity"]];
            
//            /**
//             *  报价要求
//             */
//            @property (nonatomic, copy) NSString *quoteRequirement;
            self.quoteRequirement=quote[@"quote"];
//            /**
//             *  规格要求
//             */
//            @property (nonatomic, copy) NSString *standardRequirement;
            self.standardRequirement=quote[@"decription"];
//            
//            /**
//             *  订单苗木ID
//             */
//            @property (nonatomic, copy) NSString *uid;
            self.uid=quote[@"uid"];
//            /**
//             *  订单ID
//             */
//            @property (nonatomic, copy) NSString *orderUid;
            self.orderUid=quote[@"orderUid"];
//            @property (nonatomic, strong) NSString *province;//省
            self.province=quote[@"province"];
//            @property (nonatomic, strong) NSString *city;//市
            self.city=quote[@"city"];
//            @property (nonatomic, strong) NSString *county;//县
            self.county=quote[@"county"];
//            @property (nonatomic, strong) NSString *town;//镇
            self.town=quote[@"town"];
//            
//            @property (nonatomic, strong) UIButton *addressButton;
            self.areaStr=quote[@"area"];
    
            [self.quoteTableView reloadData];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
    self.quoteTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.quoteTableView.backgroundColor = BGColor;
   [ZIKFunction setExtraCellLineHidden:self.quoteTableView];
    if (self.navColor) {
        self.sureButton.backgroundColor = self.navColor;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.titleArray[section];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 30;
//        return 120;
    }
    return 0.01f;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            CGRect standardRequirementRect =  [ZIKFunction getCGRectWithContent:self.standardRequirement width:kWidth-120 font:15.0f];
            if (standardRequirementRect.size.height>20) {
                return  standardRequirementRect.size.height+15;
            }
            return 36;

        }

        return 36;
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        return 70;
    }
    if (indexPath.section == 2) {
        return 120;
    }
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *tableViewCellId = @"cellID";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellId];
//  NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
 UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];


    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableViewCellId];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        if (indexPath.section == 0) {
            detailLabel = [[UILabel alloc] init];
            [cell addSubview:detailLabel];
        } else if (indexPath.section == 1 ){
            if (indexPath.row == 0) {
                [cell addSubview:priceTextField];
            } else if (indexPath.row == 1) {
                  [cell addSubview:quantityTextField];
            } else if (indexPath.row == 3) {
                _contentTextView.placeholder = @"请输入50字以内说明...";
                _contentTextView.font = [UIFont systemFontOfSize:15.0f];
                _contentTextView.layer.masksToBounds = YES;
                _contentTextView.layer.cornerRadius = 6.0f;
                _contentTextView.layer.borderWidth = 1;
                _contentTextView.layer.borderColor = [kLineColor CGColor];
                [cell addSubview:_contentTextView];
            }

        }
//        if (!self.addImageBGView) {
//             self.addImageBGView = [[UIView alloc] init];
////            self.pickerImgView = [[ZIKAddPickerView alloc] init];
//        }
        if (!self.pickerImgView) {
            self.pickerImgView = [[ZIKPickImageView alloc] initWithFrame:CGRectMake(100, 0, Width-100, 120)];

        }

    }
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    if (indexPath.section == 0) {
        cell.textLabel.textColor = detialLabColor;

        detailLabel.frame = CGRectMake(100, 3, kWidth-120, 30);
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.textColor = DarkTitleColor;
        detailLabel.font = [UIFont systemFontOfSize:15.0f];
        detailLabel.numberOfLines = 0;
        if (indexPath.row == 0) {
            detailLabel.text = self.name;
        } else if (indexPath.row == 1) {
            detailLabel.text = self.count;
        } else if (indexPath.row == 2) {
            detailLabel.text = self.quoteRequirement;
        } else if (indexPath.row == 3) {
          CGRect standardRequirementRect =  [ZIKFunction getCGRectWithContent:self.standardRequirement width:kWidth-120 font:15.0f];
            if (standardRequirementRect.size.height>20) {
                detailLabel.frame = CGRectMake(100, 3, kWidth-120, standardRequirementRect.size.height+15);
            }
            detailLabel.text = self.standardRequirement;
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        

    } else if (indexPath.section == 1) {
        cell.textLabel.textColor = DarkTitleColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

        priceTextField.frame = CGRectMake(100, 5, kWidth-120-60, 34);
        quantityTextField.frame = priceTextField.frame;
        if (indexPath.row == 0) {
            priceTextField.placeholder = @"请输入单价";
            UILabel *yuan = [self labelWithText:@"元  *"];
             priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:priceTextField];

            [cell addSubview:yuan];
        } else if (indexPath.row == 1) {
            UILabel *ke         = [self labelWithText:@"棵(株) *"];
            [cell addSubview:ke];
            quantityTextField.keyboardType = UIKeyboardTypeNumberPad;
            quantityTextField.placeholder = @"请输入数量";
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(quantityTextFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:quantityTextField];

        } else if (indexPath.row == 2) {
            UILabel *arrowLabel = [self labelWithText:@"      "];
            UIButton *addressButton = [[UIButton alloc] init];
            addressButton.frame = priceTextField.frame;
            addressButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            if (self.areaStr.length>0) {
              [addressButton setTitle:self.areaStr forState:UIControlStateNormal];
                [addressButton setTitleColor:NavColor forState:UIControlStateNormal];
            }else{
                [addressButton setTitle:@"请选择苗圃地址" forState:UIControlStateNormal];
                [addressButton setTitleColor:DarkTitleColor forState:UIControlStateNormal];
            }
            
            
            [addressButton addTarget:self action:@selector(selectAddress) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *rowImageV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-45, 10, cell.frame.size.height-20, cell.frame.size.height-20)];
            [rowImageV setImage:[UIImage imageNamed:@"moreRow"]];
            self.addressButton = addressButton;
            [addressButton setEnlargeEdgeWithTop:0 right:60 bottom:0 left:10];
            [cell addSubview:rowImageV];
            [cell addSubview:addressButton];
            [cell addSubview:arrowLabel];

        } else if (indexPath.row == 3) {
            _contentTextView.frame = CGRectMake(100, 5, kWidth-120-20, 60);
        }
        if (indexPath.row != 3) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 43, kWidth-30, 0.5)];
            lineView.backgroundColor = kLineColor;
            [cell addSubview:lineView];
        }
    } else if (indexPath.section == 2)  {
        cell.textLabel.textColor = DarkTitleColor;
        self.pickerImgView.backgroundColor = [UIColor whiteColor];

        [cell.contentView addSubview:self.pickerImgView];
        __weak typeof(self) weakSelf = self;
        self.pickerImgView.takePhotoBlock = ^{
            [weakSelf openMenu];
        };

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *footerView = [[UIView alloc] init];
        footerView.frame = CGRectMake(0, 0, kWidth, 120);
        footerView.backgroundColor = [UIColor whiteColor];
        ZIKHintTableViewCell *hintCell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKHintTableViewCell" owner:self options:nil] lastObject];
        hintCell.frame = CGRectMake(0, 0, kWidth, 30);
        [footerView addSubview:hintCell];
        hintCell.backgroundColor = BGColor;
        hintCell.contentView.backgroundColor = BGColor;
        hintCell.hintStr = @"注：输入框后有*的为必填项";
        return footerView;
    }
    return nil;
}

- (IBAction)sureButtonClick:(UIButton *)sender {
//    if (self.pickerImgView.urlMArr.count<1) {
//        [ToastView showTopToast:@"请添加苗木图片"];
//        return;
//    }
    if (priceTextField.text.length<1) {
        [ToastView showTopToast:@"请输入报价价格"];
        return;
    }
    if (quantityTextField.text.length<1) {
        [ToastView showTopToast:@"请输入可供数量"];
        return;
    }
    if (quantityTextField.text.integerValue==0) {
        [ToastView showTopToast:@"数量不能为0"];
        return;
    }
    if (self.county.length<1) {
        [ToastView showTopToast:@"苗圃地址需精确到县以下"];
        return;
    }
    [_contentTextView resignFirstResponder];
    [priceTextField resignFirstResponder];
    [quantityTextField resignFirstResponder];
    __block NSString *urlSring      = @"";
    __block NSString *compressSring = @"";

    if (self.pickerImgView.urlMArr.count>0) {
        [self.pickerImgView.urlMArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            urlSring = [urlSring stringByAppendingString:[NSString stringWithFormat:@",%@",dic[@"url"]]];
            compressSring = [compressSring stringByAppendingString:[NSString stringWithFormat:@",%@",dic[@"compressurl"]]];
        }];
        if (self.pickerImgView.urlMArr.count != 0) {
            urlSring         = [urlSring substringFromIndex:1];
            compressSring = [compressSring substringFromIndex:1];
        }
    }
    [HTTPCLIENT stationQuoteCreateWithUid:self.orderUid orderUid:self.uid price:priceTextField.text quantity:quantityTextField.text province:self.province city:self.city county:self.county town:self.town description:self.contentTextView.text imgs:urlSring compressImgs:compressSring Success:^(id responseObject) {
        //CLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        [ToastView showTopToast:@"报价成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        //CLog(@"%@",error);
    }];
}

-(void)selectSheng:(CityModel *)sheng shi:(CityModel *)shi xian:(CityModel *)xian zhen:(CityModel *)zhen {
    NSMutableString *namestr=[NSMutableString new];
    if (sheng.code) {
        [namestr appendString:sheng.cityName];
        self.province=sheng.code;
    }else
    {
        self.province=nil;
    }

    if (shi.code) {
        [namestr appendString:shi.cityName];
        self.city=shi.code;
    }else
    {
        self.city=nil;

    }
    if (xian.code) {
        [namestr appendString:xian.cityName];
        self.county=xian.code;
       // self.xiancityModel=xian;
    }else
    {
       // self.xiancityModel=nil;
        self.county=nil;
    }

    if (zhen.code) {
        [namestr appendString:zhen.cityName];
        self.town=zhen.code;
    }else
    {
        self.town=nil;
    }
    if (namestr.length>0) {
        [self.addressButton setTitle:namestr forState:UIControlStateNormal];
        [self.addressButton.titleLabel sizeToFit];
        [self.addressButton setTitleColor:NavColor forState:UIControlStateNormal];
    }else{
        [self.addressButton setTitle:@"请选择苗圃地址" forState:UIControlStateNormal];
        [self.addressButton setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
        [self.addressButton.titleLabel sizeToFit];

    }

}

- (void)selectAddress {
    [_contentTextView resignFirstResponder];
    [priceTextField resignFirstResponder];
    [quantityTextField resignFirstResponder];
    YLDPickLocationView *pickerLocation = [[YLDPickLocationView alloc] initWithFrame:[UIScreen mainScreen].bounds CityLeve:CityLeveZhen];
    pickerLocation.delegate=self;
    [pickerLocation showPickView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)labelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(kWidth-60, 10, 60, 24);
    label.textColor = DarkTitleColor;
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:15.0f];
    fullFont.effectRange  = NSMakeRange(0, text.length);
    ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
    fullColor.color = DarkTitleColor;
    fullColor.effectRange = NSMakeRange(0,text.length);
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:15.0f];
    partFont.effectRange = NSMakeRange(text.length-1,1);
    ForegroundColorAttribute *huangColor = [ForegroundColorAttribute new];
    huangColor.color = yellowButtonColor;
    huangColor.effectRange = NSMakeRange(text.length-1, 1);

    label.attributedText = [text mutableAttributedStringWithStringAttributes:@[fullFont,partFont,fullColor,huangColor]];
    return label;
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
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    WHC_PictureListVC  * vc = [WHC_PictureListVC new];
    vc.delegate = self;
    vc.maxChoiceImageNumberumber = 3-self.pickerImgView.urlMArr.count;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
}

#pragma mark - WHC_ChoicePictureVCDelegate
-(void)WHCChoicePictureVCdidSelectedPhotoArr:(NSArray *)photoArr {
//- (void)WHCChoicePictureVC:(WHC_ChoicePictureVC *)choicePictureVC didSelectedPhotoArr:(NSArray *)photoArr{
    for ( UIImage *image in photoArr) {
        NSData* imageData = nil;
        imageData  = [self  imageData:image];

        NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
        //NSLog(@"%ld",myStringImageFile.length);
        __weak typeof(self) weakSelf = self;

        [HTTPCLIENT upDataImageIOS:myStringImageFile workstationUid:nil companyUid:nil type:@"3" saveTyep:@"1" Success:^(id responseObject) {
            CLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
                if (weakSelf.pickerImgView.photos.count == 3) {
                    return ;
                }
                [weakSelf.pickerImgView addImage:[UIImage imageWithData:imageData]  withUrl:responseObject[@"result"]];
                 [ToastView showToast:@"图片上传成功" withOriginY:250 withSuperView:weakSelf.view];
            }
            else {
                //NSLog(@"图片上传失败");
                [ToastView showToast:@"上传图片失败" withOriginY:250 withSuperView:weakSelf.view];
                [UIColor darkGrayColor];
            }

        } failure:^(NSError *error) {
            ;
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
        //先把图片转成NSData
        __weak  UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData* imageData = nil;
        imageData  = [self imageData:image];
        //NSLog(@"%ld",imageData.length);
        __weak typeof(self) weakSelf = self;

        NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
        //NSLog(@"%ld",myStringImageFile.length);
        [HTTPCLIENT upDataImageIOS:myStringImageFile workstationUid:nil companyUid:nil type:@"3" saveTyep:@"1" Success:^(id responseObject) {
            //CLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
                if (weakSelf.pickerImgView.photos.count == 3) {
                    return ;
                }
                [weakSelf.pickerImgView addImage:[UIImage imageWithData:imageData]  withUrl:responseObject[@"result"]];
                [ToastView showToast:@"图片上传成功" withOriginY:250 withSuperView:weakSelf.view];
            }
            else {
                //NSLog(@"图片上传失败");
                [ToastView showToast:@"上传图片失败" withOriginY:250 withSuperView:weakSelf.view];
                [UIColor darkGrayColor];
            }

        } failure:^(NSError *error) {
            ;
        }];

        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        [ToastView showTopToast:@"暂不支持此图片格式,请换张图片"];
    }

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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

- (void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    int kssss;
    if (textField.keyboardType==UIKeyboardTypeNumberPad) {
        kssss=8;
    }else{
        kssss=10;
    }
    if (textField.keyboardType==UIKeyboardTypeDecimalPad) {
        kssss=11;
        NSArray *valueAryy=[textField.text componentsSeparatedByString:@"."];
        if (valueAryy.count==1) {
            NSString *zhengshuStr=[valueAryy firstObject];
            if (zhengshuStr.length>8) {
                [ToastView showTopToast:[NSString stringWithFormat:@"整数部分不得超过8位"]];
                textField.text = [toBeString substringToIndex:[toBeString length] - 1];
                return;
            }
        }
        if (valueAryy.count==2) {
            // NSLog(@"%@",[valueAryy firstObject]);
            NSString *zhengshuStr=[valueAryy firstObject];
            if (zhengshuStr.length>8) {
                [ToastView showTopToast:[NSString stringWithFormat:@"整数部分不得超过8位"]];
                textField.text = [toBeString substringToIndex:[toBeString length] - 1];
                return;
            }
            NSString *xiaoshuStr=valueAryy[1];
            if (xiaoshuStr.length>2) {
                [ToastView showTopToast:[NSString stringWithFormat:@"小数精确到两位"]];
                textField.text = [toBeString substringToIndex:[toBeString length] - 1];
                return;
            }

        }
        if (valueAryy.count>2) {
            [ToastView showTopToast:[NSString stringWithFormat:@"请不要输入多个小数点"]];
            textField.text = [toBeString substringToIndex:[toBeString length] - 1];
            return;
        }

    }

    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kssss) {
                // NSLog(@"最多%d个字符!!!",kMaxLength);
                [ToastView showTopToast:[NSString stringWithFormat:@"最多为%d位",kssss]];
                //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] view:nil];
                textField.text = [toBeString substringToIndex:kssss];
                return;
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{

        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kssss) {
            //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%ld个字符",(long)kMaxLength] view:nil];
            //NSLog(@"最多%d个字符!!!",kMaxLength);
            [ToastView showTopToast:[NSString stringWithFormat:@"最多%d个字符",kssss]];
            textField.text = [toBeString substringToIndex:kssss];
            return;
        }
    }
}

- (void)quantityTextFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    if ([toBeString isEqualToString:@"0"]) {
        [ToastView showTopToast:@"数量不能为0"];
//        textField.text = nil;
        return;
    }
    int kssss;
    if (textField.keyboardType==UIKeyboardTypeNumberPad) {
        kssss=8;
    }else{
        kssss=10;
    }
    if (textField.keyboardType==UIKeyboardTypeDecimalPad) {
        kssss=11;
        NSArray *valueAryy=[textField.text componentsSeparatedByString:@"."];
        if (valueAryy.count==1) {
            NSString *zhengshuStr=[valueAryy firstObject];
            if (zhengshuStr.length>8) {
                [ToastView showTopToast:[NSString stringWithFormat:@"整数部分不得超过8位"]];
                textField.text = [toBeString substringToIndex:[toBeString length] - 1];
                return;
            }
        }
        if (valueAryy.count==2) {
            // NSLog(@"%@",[valueAryy firstObject]);
            NSString *zhengshuStr=[valueAryy firstObject];
            if (zhengshuStr.length>8) {
                [ToastView showTopToast:[NSString stringWithFormat:@"整数部分不得超过8位"]];
                textField.text = [toBeString substringToIndex:[toBeString length] - 1];
                return;
            }
            NSString *xiaoshuStr=valueAryy[1];
            if (xiaoshuStr.length>2) {
                [ToastView showTopToast:[NSString stringWithFormat:@"小数精确到两位"]];
                textField.text = [toBeString substringToIndex:[toBeString length] - 1];
                return;
            }

        }
        if (valueAryy.count>2) {
            [ToastView showTopToast:[NSString stringWithFormat:@"请不要输入多个小数点"]];
            textField.text = [toBeString substringToIndex:[toBeString length] - 1];
            return;
        }

    }

    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kssss) {
                // NSLog(@"最多%d个字符!!!",kMaxLength);
                [ToastView showTopToast:[NSString stringWithFormat:@"最多为%d位",kssss]];
                //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] view:nil];
                textField.text = [toBeString substringToIndex:kssss];
                return;
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{

        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kssss) {
            //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%ld个字符",(long)kMaxLength] view:nil];
            //NSLog(@"最多%d个字符!!!",kMaxLength);
            [ToastView showTopToast:[NSString stringWithFormat:@"最多%d个字符",kssss]];
            textField.text = [toBeString substringToIndex:kssss];
            return;
        }
    }
}
//if ([propers.numberType isEqualToString:@"float"]) {
//    minTextField.keyboardType=UIKeyboardTypeDecimalPad;
//    maxTextField.keyboardType=UIKeyboardTypeDecimalPad;
//}
//if ([propers.numberType isEqualToString:@"int"]){
//    minTextField.keyboardType=UIKeyboardTypeNumberPad;
//    maxTextField.keyboardType=UIKeyboardTypeNumberPad;
//}


@end
