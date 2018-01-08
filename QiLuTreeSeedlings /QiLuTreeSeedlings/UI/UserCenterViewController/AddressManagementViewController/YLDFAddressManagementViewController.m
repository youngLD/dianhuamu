//
//  YLDFAddressManagementViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/12.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFAddressManagementViewController.h"
#import "YLDFPickCityView.h"
@interface YLDFAddressManagementViewController ()<YLDFPickCityViewDelegate>
@property (assign,nonatomic)CGFloat lat;
@property (assign,nonatomic)CGFloat lng;
@property (nonatomic,copy)NSString *province;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *county;
@property (nonatomic,strong)YLDFPickCityView *yldPickView;
@property (nonatomic,strong)CityModel *shengModel;
@property (nonatomic,strong)CityModel *shiModel;
@property (nonatomic,strong)CityModel *xianModel;
@end

@implementation YLDFAddressManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightBarBtnTitleString=@"保存";
    self.rightBarBtnTitleColor=kRedHintColor;
    __weak typeof(self) weakSelf = self;
    self.rightBarBtnBlock = ^{
        [weakSelf baocunAction];
    };
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    if (_isDefault) {
        self.morenSWBtn.on=YES;
    }
    self.personTextField.rangeNumber=8;
    self.phoneTextField.rangeNumber=11;
    self.yldPickView=[[YLDFPickCityView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.yldPickView.delegate=self;
    [self.deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    if (self.model) {
        self.phoneTextField.text=_model.phone;
        self.personTextField.text=_model.linkman;
        self.lat=[_model.lat floatValue];
        self.lng=[_model.lng floatValue];
        [self.addressBtn setTitle:_model.area forState:UIControlStateNormal];
        GetCityDao *dao=[GetCityDao new];
        [dao openDataBase];
        self.shengModel=[dao getcityModelByCityCode:_model.province];
        self.shiModel=[dao getcityModelByCityCode:_model.city];
        self.xianModel=[dao getcityModelByCityCode:_model.county];

        [dao closeDataBase];
        
        self.province=_model.province;
        self.city=_model.city;
        self.county=_model.county;
        self.vcTitle=@"编辑地址";
//       NSArray *cityNameAry=[]
        
    }else
    {
        [self.deleteView removeFromSuperview];
        self.vcTitle=@"添加地址";
    }
    [self.addressBtn addTarget:self action:@selector(addressBtnAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void)addressBtnAction
{
    [self.phoneTextField resignFirstResponder];
    [self.personTextField resignFirstResponder];
    [self.yldPickView showAction];
}
-(void)baocunAction
{
    [self.phoneTextField resignFirstResponder];
    [self.personTextField resignFirstResponder];
    if (self.personTextField.text.length<1) {
        [ToastView showTopToast:@"请输入联系人姓名"];
        return;
    }
    if (self.personTextField.text.length<2||self.personTextField.text.length>8) {
        [ToastView showTopToast:@"姓名长度为2～8之间"];
        return;
    }
    if (self.phoneTextField.text.length!=11) {
        [ToastView showTopToast:@"请输入正确的手机号码"];
        return;
    }
    if (self.xianModel.cityName.length<=0) {
        [ToastView showTopToast:@"请选择地区"];
        return;
    }
    NSMutableDictionary *party  =[NSMutableDictionary dictionary];
    [party setObject:_personTextField.text forKey:@"linkman"];
    [party setObject:_phoneTextField.text forKey:@"phone"];
    [party setObject:_shengModel.code forKey:@"province"];
    [party setObject:_shiModel.code forKey:@"city"];
    [party setObject:_xianModel.code forKey:@"county"];
    if ([_morenSWBtn isOn]) {
        [party setObject:@"1" forKey:@"defaultAddress"];
    }else{
        [party setObject:@"0" forKey:@"defaultAddress"];
    }
    ShowActionV();
    NSString *oreillyAddress=[NSString stringWithFormat:@"%@%@%@",_shengModel.cityName,_shiModel.cityName,_xianModel.cityName];
    NSString *oreillyAddress2=[NSString stringWithFormat:@"%@ %@ %@",_shengModel.cityName,_shiModel.cityName,_xianModel.cityName];
    [party setObject:oreillyAddress2 forKey:@"area"];
    __weak typeof(self) weakslef=self;
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];            weakslef.lng=firstPlacemark.location.coordinate.longitude;
            weakslef.lat=firstPlacemark.location.coordinate.latitude;
            [party setObject:[NSString stringWithFormat:@"%lf",weakslef.lat] forKey:@"lat"];
            [party setObject:[NSString stringWithFormat:@"%lf",weakslef.lng] forKey:@"lng"];
            NSString *partyStr = [ZIKFunction convertToJsonData:party];
            [weakslef saveWithPartyStr:partyStr];
            
        }
        else if ([placemarks count] == 0 && error == nil) {
            [party setObject:[NSString stringWithFormat:@"%lf",weakslef.lat] forKey:@"lat"];
            [party setObject:[NSString stringWithFormat:@"%lf",weakslef.lng] forKey:@"lng"];
            NSString *partyStr = [ZIKFunction convertToJsonData:party];
            [weakslef saveWithPartyStr:partyStr];
        } else if (error != nil) {
            [party setObject:[NSString stringWithFormat:@"%lf",weakslef.lat] forKey:@"lat"];
            [party setObject:[NSString stringWithFormat:@"%lf",weakslef.lng] forKey:@"lng"];
            NSString *partyStr = [ZIKFunction convertToJsonData:party];
            [weakslef saveWithPartyStr:partyStr];
        }
    }];
}
-(void)saveWithPartyStr:(NSString *)partyStr
{
    if (_model.addressId.length>0) {
        
        [HTTPCLIENT editAddressWithaddressId:_model.addressId WithBodyStr:partyStr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"编辑成功"];
                if (self.delegate) {
                    [self.delegate addSuccessWithaddressDic:[responseObject objectForKey:@"data"]];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        ShowActionV();
        [HTTPCLIENT addNewAddressWithStr:partyStr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"保存成功"];
                if (self.delegate) {
                    [self.delegate addSuccessWithaddressDic:[responseObject objectForKey:@"data"]];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
}
-(void)deleteBtnAction
{
    if(_model.defaultAddress)
    {
        [ToastView showTopToast:@"默认地址不可删除"];
        return;
    }
    //在这里呼出下方菜单按钮项
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除地址" message:@"您确定要删除该地址，删除后无法恢复。" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [HTTPCLIENT deleteAddressWithaddressId:_model.addressId Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"删除成功"];
                if (self.delegate) {
                    [self.delegate addSuccessWithaddressDic:[responseObject objectForKey:@"data"]];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)selectSheng:(CityModel *)sheng shi:(CityModel *)shi xian:(CityModel *)xian zhen:(CityModel *)zhen
{
 
    self.shengModel=sheng;
    self.shiModel=shi;
    self.xianModel=xian;
    [self.addressBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@",sheng.cityName,shi.cityName,xian.cityName] forState:UIControlStateNormal];
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
