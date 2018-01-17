//
//  YLDFBuyFBViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/25.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFBuyFBViewController.h"
#import "YLDFAddressManagementViewController.h"
#import "YLDFAddressListViewController.h"
@interface YLDFBuyFBViewController ()<YLDFAddressListViewControllerDelegate,YLDFAddressManagementDelegate>
@property (nonatomic,copy)NSString *addressId;
@property (nonatomic,strong)UIButton *baojiaTypeBtn;
@end

@implementation YLDFBuyFBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    if (APPDELEGATE.addressModel.addressId) {
        self.addressId=APPDELEGATE.addressModel.addressId;
        self.addBGV.hidden=YES;
        self.addressPersonLab.text=APPDELEGATE.addressModel.linkman;
        self.addressPhoneLab.text=APPDELEGATE.addressModel.phone;
        self.addressLab.text=APPDELEGATE.addressModel.area;
    }
    self.vcTitle=@"求购发布";
    self.guigeTextFiled.placeholder=@"请输入苗木规格说明";
    self.addLineV.image =   [ZIKFunction imageWithSize:self.addLineV.frame.size borderColor:kLineColor borderWidth:1];
    self.addAddressBGImageV.image=[ZIKFunction  imageWithSize:self.addAddressBGImageV.frame.size borderColor:kLineColor borderWidth:1];
    [self.shangchejiaBtn addTarget:self action:@selector(baojiayaoqiuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.shangchejiaBtn.selected=YES;
    self.baojiaTypeBtn=self.shangchejiaBtn;
    [self.daohuojiaBtn addTarget:self action:@selector(baojiayaoqiuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.maimiaojiaBtn addTarget:self action:@selector(baojiayaoqiuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fabuBtn addTarget:self action:@selector(fabuAction) forControlEvents:UIControlEventTouchUpInside];
    if (self.buyIdstr.length>0) {
        [HTTPCLIENT myBuyDetialWithbuyIds:self.buyIdstr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *dic=[[responseObject objectForKey:@"data"] objectForKey:@"buy"];
                self.model=[YLDFBuyModel YLDFBuyModelWithDic:dic];
                self.nameTextField.text=self.model.productName;
                self.guigeTextFiled.text=self.model.demand;
                if (self.model.quantity>0) {
                    self.numTextField.text=[NSString stringWithFormat:@"%@",self.model.quantity];
                }
                self.baojiaTypeBtn.selected=NO;
                if ([self.model.quoteTypeId isEqualToString:@"car_price"]) {
                    self.baojiaTypeBtn=self.shangchejiaBtn;
                }else if ([self.model.quoteTypeId isEqualToString:@"arrival_price"])
                {
                    self.baojiaTypeBtn=self.daohuojiaBtn;
                }else if ([self.model.quoteTypeId isEqualToString:@"buy_price"])
                {
                    self.baojiaTypeBtn=self.maimiaojiaBtn;
                }
                self.baojiaTypeBtn.selected=YES;
                self.addressId=self.model.addressId;
               YLDFAddressModel *addressModel = [ZIKFunction GetAddressModelWithAddressId:self.addressId];
                if (addressModel.addressId.length>0) {
                    self.addressLab.text=addressModel.area;
                    self.addressPersonLab.text=addressModel.linkman;
                    self.addressPhoneLab.text=addressModel.phone;
                }

            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)baojiayaoqiuBtnAction:(UIButton *)sender
{
    if(sender.selected)
    {
        return;
    }
    sender.selected=YES;
    self.baojiaTypeBtn.selected=NO;
    self.baojiaTypeBtn=sender;
}
-(void)fabuAction
{
    if (self.nameTextField.text.length<=0) {
        [ToastView showTopToast:@"请输入苗木名称"];
        return;
    }
    if (self.guigeTextFiled.text.length<=0) {
        [ToastView showTopToast:@"请输入苗木规格"];
        return;
    }
    if (self.numTextField.text.length<=0) {
        [ToastView showTopToast:@"请输入求购数量"];
        return;
    }
    if (self.addressId.length<=0) {
        [ToastView showTopToast:@"请选择地址"];
        return;
    }
    NSMutableDictionary *party=[NSMutableDictionary dictionary];
    [party setObject:self.nameTextField.text forKey:@"productName"];
    [party setObject:self.guigeTextFiled.text forKey:@"demand"];
    if (self.baojiaTypeBtn) {
        NSString *baojiatype=nil;
        if (self.baojiaTypeBtn.tag==1) {
            baojiatype=@"car_price";
        }
        if (self.baojiaTypeBtn.tag==2) {
            baojiatype=@"arrival_price";
        }
        if (self.baojiaTypeBtn.tag==3) {
            baojiatype=@"buy_price";
        }
        party[@"quoteTypeId"]=baojiatype;
    }
    if (self.numTextField.text.length>0) {
        [party setObject:self.numTextField.text forKey:@"quantity"];
    }
    [party setObject:self.addressId forKey:@"addressId"];
    NSString *partyStr=[ZIKFunction convertToJsonData:party];
    ShowActionV();
    if(!self.buyIdstr)
    {
        [HTTPCLIENT buyNewPushWithBody:partyStr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"发布成功"];
                [APPDELEGATE getdefaultAddress];
                [self.navigationController popViewControllerAnimated:NO];
                if (self.delegate) {
                    [self.delegate fabuSuccessWithbuyId:[responseObject objectForKey:@"data"]];
                }
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [HTTPCLIENT buyNewUpDataWithBody:partyStr WithBuyId:self.buyIdstr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"修改成功"];
                [APPDELEGATE getdefaultAddress];
            [self.navigationController popViewControllerAnimated:NO];
            if (self.delegate) {
                [self.delegate fabuSuccessWithbuyId:[responseObject objectForKey:@"data"]];
            }
            }
        } failure:^(NSError *error) {
            
        }];
    }
   
}
-(void)deleteWithYLDFAddressModel:(YLDFAddressModel *)model{
    if ([self.addressId isEqualToString:model.addressId]) {
        self.addressPersonLab.text=@"请选择地址";
        self.addressPhoneLab.text=@"请选择地址";
        self.addressLab.text=@"请选择地址";
        self.addressId=nil;
    }
}
- (IBAction)addAdressBtnAction:(id)sender {
    YLDFAddressManagementViewController *vc=[YLDFAddressManagementViewController new];
    vc.delegate=self;
    vc.isDefault=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)addSuccessWithaddressDic:(NSDictionary *)addressdic
{
    self.addBGV.hidden=YES;
    self.addressId=addressdic[@"addressId"];
    
    self.addressPersonLab.text=addressdic[@"linkman"];
    self.addressPhoneLab.text=addressdic[@"phone"];
    self.addressLab.text=addressdic[@"area"];
}
-(IBAction)selectAddressBtnAction
{
    YLDFAddressListViewController *vc=[YLDFAddressListViewController new];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)selectWithYLDFAddressModel:(YLDFAddressModel *)model{
    self.addressPersonLab.text=model.linkman;
    self.addressId=model.addressId;
    self.addressPhoneLab.text=model.phone;
    self.addressLab.text=model.area;
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
