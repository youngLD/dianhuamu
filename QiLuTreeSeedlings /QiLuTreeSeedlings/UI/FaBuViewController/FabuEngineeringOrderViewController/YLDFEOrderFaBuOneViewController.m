//
//  YLDFEOrderFaBuOneViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/8.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFEOrderFaBuOneViewController.h"
#import "YLDFAddressManagementViewController.h"
#import "YLDFAddressListViewController.h"
#import "YLDPickTimeView.h"
#import "YLDFEOrderFaBuTwoViewController.h"
@interface YLDFEOrderFaBuOneViewController ()<YLDFAddressListViewControllerDelegate,YLDFAddressManagementDelegate,YLDPickTimeDelegate,YLDRangeTextViewDelegate>
@property (nonatomic,copy)NSString *addressId;
@property (nonatomic,strong)UIButton *baojiaTypeBtn;
@property (nonatomic,copy)NSString *timeStr;
@property (nonatomic,strong)YLDFEOrderFaBuTwoViewController *nextvc;
@end

@implementation YLDFEOrderFaBuOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    if (APPDELEGATE.addressModel.addressId) {
        self.addressId=APPDELEGATE.addressModel.addressId;
        self.addBGV.hidden=YES;
        self.personLab.text=APPDELEGATE.addressModel.linkman;
        self.phoneLab.text=APPDELEGATE.addressModel.phone;
        self.addressLab.text=[NSString stringWithFormat:@"%@%@%@",APPDELEGATE.addressModel.province,APPDELEGATE.addressModel.city,APPDELEGATE.addressModel.county];
    }
    self.vcTitle=@"工程订单发布";
    self.shuomingTextView.placeholder=@"请输入订单说明（不超过70个字）";
    self.shuomingTextView.Rdelegate=self;
    self.shuomingTextView.rangeNumber=70;
    self.nameTextField.rangeNumber=50;
    self.LineImageV.image =   [ZIKFunction imageWithSize:self.LineImageV.frame.size borderColor:kLineColor borderWidth:1];
    self.addAddImageV.image=[ZIKFunction  imageWithSize:self.addAddImageV.frame.size borderColor:kLineColor borderWidth:1];
    [self.shangchejiaBtn addTarget:self action:@selector(baojiayaoqiuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.shangchejiaBtn.selected=YES;
    self.baojiaTypeBtn=self.shangchejiaBtn;
    [self.daohuajiaBtn addTarget:self action:@selector(baojiayaoqiuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.miaomiaojiaBtn addTarget:self action:@selector(baojiayaoqiuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickTimeBtn addTarget:self action:@selector(timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //self.companyNameLab.text=APPDELEGATE.qyModel.name;
    self.nextvc=[YLDFEOrderFaBuTwoViewController new];
  
    
    
//    [self. addTarget:self action:@selector(fabuAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void)textChangeNowLength:(NSInteger)length
{
    self.textNumLab.text=[NSString stringWithFormat:@"%ld/70",length];
}
-(void)timeBtnAction:(UIButton *)sender
{
    YLDPickTimeView *pickTimeView=[[YLDPickTimeView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    pickTimeView.delegate=self;
//    pickTimeView.pickerView.maximumDate=[NSDate new];
    pickTimeView.pickerView.minimumDate=[NSDate new];
    [pickTimeView showInView];
    [self.nameTextField resignFirstResponder];
    [self.shuomingTextView resignFirstResponder];
//    [self.organizationalField resignFirstResponder];
}
-(void)timeDate:(NSDate *)selectDate andTimeStr:(NSString *)timeStr
{
    self.timeStr=timeStr;
    [self.pickTimeBtn setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
    [self.pickTimeBtn setTitle:timeStr forState:UIControlStateNormal];
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
-(void)deleteWithYLDFAddressModel:(YLDFAddressModel *)model{
    if ([self.addressId isEqualToString:model.addressId]) {
        self.personLab.text=@"请选择地址";
        self.phoneLab.text=@"请选择地址";
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
    
    self.personLab.text=addressdic[@"linkman"];
    self.phoneLab.text=addressdic[@"phone"];
    self.addressLab.text=addressdic[@"area"];
}
-(IBAction)selectAddressBtnAction
{
    YLDFAddressListViewController *vc=[YLDFAddressListViewController new];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)selectWithYLDFAddressModel:(YLDFAddressModel *)model{
    self.personLab.text=model.linkman;
    self.addressId=model.addressId;
    self.phoneLab.text=model.phone;
    self.addressLab.text=model.area;
}
- (IBAction)nextBtnAction:(UIButton *)sender {
    if (self.nameTextField.text.length==0) {
        [ToastView showTopToast:@"请输入订单名称"];
        return;
    }
    if (self.shuomingTextView.text.length==0) {
        [ToastView showTopToast:@"请输入订单说明"];
        return;
    }
    if (self.timeStr.length==0) {
        [ToastView showTopToast:@"请选择截止日期"];
        return;
    }
    if (self.addressId.length==0) {
        [ToastView showTopToast:@"请选择用苗地信息"];
        return;
    }
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"addressId"]=self.addressId;
    dic[@"description"]=self.shuomingTextView.text;
    dic[@"engineeringProcurementName"]=self.nameTextField.text;
    dic[@"partyId"]=APPDELEGATE.userModel.partyId;
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
    dic[@"quoteTypeId"]=baojiatype;
    dic[@"thruDate"]=self.timeStr;
   
    self.nextvc.dic=dic;
    [self.navigationController pushViewController:self.nextvc animated:YES];

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
