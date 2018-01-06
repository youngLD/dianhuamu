//
//  YLDJJRenShenQing3ViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/6.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRenShenQing3ViewController.h"
#import "ZIKCityListViewController.h"//城市选择

#import "ZIKVoucherCenterViewController.h"
@interface YLDJJRenShenQing3ViewController ()<ZIKCityListViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *citys;
@property (nonatomic, strong) NSString       *citysStr;

@property (nonatomic)NSMutableArray *areaMArr;
@property (nonatomic,copy)NSString *uid;
@end

@implementation YLDJJRenShenQing3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"经纪人认证";
    self.areaMArr=[NSMutableArray array];
    self.jstextField.placeholder=@"请输入自我介绍";
    self.areaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.areaBtn addTarget:self action:@selector(citySelectAction) forControlEvents:UIControlEventTouchUpInside];

    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.citys=(NSMutableArray *)[self citysz];
    });
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)nextBtnAction:(id)sender {
    if (self.jstextField.text.length<=0) {
        [ToastView showTopToast:@"请输入自我介绍"];
        return;
    }
    if(self.citysStr.length<=0)
    {
        [ToastView showTopToast:@"请选择经营区域"];
        return;
    }
    if(self.pzTextField.text.length<=0)
    {
        [ToastView showTopToast:@"请输入主营品种"];
        return;
    }
    NSString *pzStr=self.pzTextField.text;
    pzStr=[pzStr stringByReplacingOccurrencesOfString:@"，" withString:@","];
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:self.dic];
    dic[@"explain"]=self.jstextField.text;
    dic[@"product"]=pzStr;
    dic[@"areaCodes"]=self.citysStr;
    if (self.uid) {
        ZIKVoucherCenterViewController *voucherVC = [[ZIKVoucherCenterViewController alloc] init];
        voucherVC.price = @"300";
        voucherVC.wareStr=@"支付认证费用(元):";
        voucherVC.uid=self.uid;
        voucherVC.infoType=6;
        [self.navigationController pushViewController:voucherVC animated:YES];
    }else{
         
    }
    
}

-(void)citySelectAction
{
    ZIKCityListViewController *cityVC = [[ZIKCityListViewController alloc] init];
    cityVC.maxNum=10000;
    cityVC.selectStyle = SelectStyleMultiSelect;
//    [self.citys removeAllObjects];
    [self rrrload];
    cityVC.citys=self.citys;
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 确定返回后，传回地址执行协议
- (void)selectCitysInfo:(NSString *)citysStr {
//    self.screenView.hidden = NO;
    _citysStr = citysStr;
    if (self.areaMArr.count > 0) {
        [self.areaMArr removeAllObjects];
    }
    GetCityDao *citydao = [GetCityDao new];
    [citydao openDataBase];
    __block NSString *str = @"";
    NSArray *cityArray = [_citysStr componentsSeparatedByString:@","];
    [cityArray enumerateObjectsUsingBlock:^(NSString *cityCode, NSUInteger idx, BOOL * _Nonnull stop) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[citydao getCityNameByCityUid:cityCode]]];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
        if (cityCode.length>2) {
            dic[@"provinceCode"] = [citydao getCityParentCode:cityCode];
            dic[@"cityCode"]     = cityCode;
        }else{
            dic[@"provinceCode"] = cityCode;
        }
        
        [self.areaMArr addObject:dic];
    }];
    [citydao closeDataBase];
    //CLog(@"%@",self.areaMArr);
    [self.areaBtn setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
    [self.areaBtn setTitle:[str substringToIndex:str.length-1] forState:UIControlStateNormal];
}


- (NSArray *)citysz {
    //if (_citys == nil) {
    //    ShowActionV();
    _citys = [[NSMutableArray alloc] init];
    GetCityDao *dao = [[GetCityDao alloc] init];
    [dao openDataBase];
    NSArray *allProvince = [dao getCityByLeve:@"1"];
    [allProvince enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        ZIKCityModel *cityModel = [ZIKCityModel initCityModelWithDic:dic];
        //             cityModel.province.citys = [dao getCityByLeve:@"2" andParent_code:cityModel.province.code];
        NSMutableArray *cityMArr = [dao getCityByLeve:@"2" andParent_code:cityModel.province.code];
        
        
        NSMutableDictionary *dicionary = [NSMutableDictionary dictionary];
        [dicionary setObject:cityModel.province.provinceID forKey:@"id"];
        [dicionary setObject:cityModel.province.code forKey:@"code"];
        [dicionary setObject:cityModel.province.parent_code forKey:@"parent_code"];
        [dicionary setObject:@"全省" forKey:@"name"];
        [dicionary setObject:cityModel.province.level forKey:@"level"];
        [cityMArr insertObject:dicionary atIndex:0];
        cityModel.province.citys = cityMArr;
        
        [_citys addObject:cityModel];
        
    }];
    [dao closeDataBase];
    [self rrrload];
    //}
    return _citys;
    //    RemoveActionV();
}
-(void)rrrload
{
    if (![self.areaBtn.titleLabel.text isEqualToString:@"请选择经营区域"]) {
        NSArray *cityArray = [_citysStr componentsSeparatedByString:@","];
        __block NSInteger numcount = 0;
        [_citys enumerateObjectsUsingBlock:^(ZIKCityModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            [model.province.citys enumerateObjectsUsingBlock:^(NSMutableDictionary *cityDic, NSUInteger idx, BOOL * _Nonnull stop) {
                [cityArray enumerateObjectsUsingBlock:^(NSString *cityCode, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([cityDic[@"code"] isEqualToString:cityCode]) {
                        cityDic[@"select"] = @"1";
                        if (++numcount == cityArray.count) {
                            *stop = YES;
                        }
                    }
                }];
            }];
        }];
    }

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
