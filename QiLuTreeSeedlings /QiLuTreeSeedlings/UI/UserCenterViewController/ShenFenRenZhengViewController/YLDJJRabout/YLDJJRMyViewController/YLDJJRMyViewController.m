//
//  YLDJJRMyViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/8.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRMyViewController.h"
#import "ZIKCityListViewController.h"//城市选择
#import "YLDJJrModel.h"
#import "UIImageView+AFNetworking.h"
#import "YLDjjrJieShaoChangViewController.h"
#import "YLDJJRhangePheonViewController.h"
#import "YLDJJRChangeAreaViewController.h"
#import "JJRMyAreaView.h"
#import "ZIKFunction.h"
#import "UIView+SDAutoLayout.h"
@interface YLDJJRMyViewController ()<ZIKCityListViewControllerDelegate,YLDJJRChangeAreaViewControllerDelegate,YLDjjrJieShaoChangViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *citys;
@property (nonatomic, strong) NSString       *citysStr;
@property (nonatomic, strong) NSString       *pzStr;
@property (nonatomic, strong) JJRMyAreaView  *mrAreaV;
@property (nonatomic, copy) NSArray       *cityAry;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *mrcode;
@end
@implementation YLDJJRMyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"苗木经纪人";
//    self.areaMArr=[NSMutableArray array];
    self.txImagV.layer.masksToBounds=YES;
    self.txImagV.layer.cornerRadius=25;
    self.xingmingTextF.enabled=NO;
    self.phoneLab.enabled=NO;
    self.chageBtn.layer.masksToBounds=YES;
    self.chageBtn.layer.cornerRadius=4;
    self.areaView.hidden=YES;
    self.ziwojieshaoTextV.editable=NO;
    
    self.ziwojieshaoTextV.placeholder=@"请输入自我介绍";

    [self.quyuBtn addTarget:self action:@selector(quyuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.chageBtn addTarget:self action:@selector(quyuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.pinzhongBtn addTarget:self action:@selector(pinzhongBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.JieshaoBtn addTarget:self action:@selector(jieshaoBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.citys=(NSMutableArray *)[self citysz];
    });
    ShowActionV();
    [HTTPCLIENT jjrDetialWithUid:APPDELEGATE.userModel.access_id Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic=[responseObject objectForKey:@"data"];

            NSArray *cityAry=dic[@"area"];
            NSMutableString *cityStr=[NSMutableString new];
            self.cityAry=cityAry;
            self.mrcode=dic[@"defaultArea"];
            for (NSDictionary *dic in cityAry) {
                 [cityStr appendFormat:@"%@,",dic[@"code"]];
               
            }
            NSString *strs=[NSString stringWithFormat:@"%@",cityStr];
            if (strs.length>0) {
                strs = [strs substringToIndex:[strs length] - 1];
                self.citysStr=strs;
            }
            if (dic[@"product"]) {
                [self.pinzhongBtn setTitle:dic[@"product"] forState:UIControlStateNormal];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.txImagV setImageWithURL:[NSURL URLWithString:dic[@"photo"]]];
                self.xingmingTextF.text=dic[@"name"];

                self.phoneLab.text=dic[@"partyId"];
                if (dic[@"explain"]) {
                    self.ziwojieshaoTextV.text=dic[@"explain"];
                }
                
                if (cityAry.count>0) {
                    CGRect frame=self.areaView.frame;
                    frame.size.height=50*cityAry.count+60;
                    self.areaView.frame=frame;
//                    self.areaVH.constant=50*cityAry.count+60;
                    self.areaView.hidden=NO;
                    for (int i=0; i<cityAry.count; i++) {
                        NSDictionary *dic=cityAry[i];
                        JJRMyAreaView *view=[JJRMyAreaView jjrMyAreaView];
                        CGRect tempFrame=view.frame;
                        tempFrame.size.width=kWidth-117;
                        tempFrame.origin.x=0;
                        tempFrame.size.height=40;
                        tempFrame.origin.y=60+50*i;
                        view.frame=tempFrame;

                        view.wareLab.text=dic[@"shortName"];
                        [view.actionBtn addTarget:self action:@selector(selectMrCodeAction:) forControlEvents:UIControlEventTouchUpInside];
                        view.actionBtn.tag=i;
                        NSString *code=dic[@"code"];

                        if ([code isEqualToString:self.mrcode]) {
                            [view setBackgroundColor:kRGB(245, 253, 242, 1)];
                            self.mrAreaV=view;
                            view.moLab.hidden=NO;
                            [view.wareLab setTextColor:NavColor];
                            [view.bgImageV setImage:[ZIKFunction imageWithSize:view.bgImageV.frame.size borderColor:NavColor borderWidth:1]];
                        }else{
                            [view setBackgroundColor:[UIColor whiteColor]];
                            view.moLab.hidden=YES;
                            [view.wareLab setTextColor:MoreDarkTitleColor];
                            [view.bgImageV setImage:[ZIKFunction imageWithSize:view.bgImageV.frame.size borderColor:detialLabColor borderWidth:1]];
                        }
                        [self.areaView addSubview:view];
                    }


                }

            });
            
           
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view from its nib.
}



-(void)jieshaoBtnAction:(UIButton *)sender
{
    YLDjjrJieShaoChangViewController *vc=[YLDjjrJieShaoChangViewController new];
    vc.jsstr=self.ziwojieshaoTextV.text;
    vc.delgete=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)sureWithJieShaoStr:(NSString *)Str
{
    ShowActionV();
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"explain"]=Str;
    NSString *bodyStr=[ZIKFunction convertToJsonData:dic];
    [HTTPCLIENT jjrdetialChangeWithbodyStr:bodyStr Success:^(id responseObject){
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"修改成功"];
            self.ziwojieshaoTextV.text=Str;

        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)quyuBtnAction:(UIButton *)sender
{
    ZIKCityListViewController *cityVC = [[ZIKCityListViewController alloc] init];
    cityVC.maxNum=9999;
    cityVC.selectStyle = SelectStyleMultiSelect;
    [self rrrload];
    cityVC.citys=self.citys;
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:NO];
}
-(void)pinzhongBtnAction:(UIButton *)sender
{
    YLDJJRChangeAreaViewController *fabuVC=[[YLDJJRChangeAreaViewController alloc]init];
    fabuVC.delgete=self;
    if (![self.pinzhongBtn.titleLabel.text isEqualToString:@"请输入主营品种"]) {
       fabuVC.pzStr=self.pinzhongBtn.titleLabel.text; 
    }
    
    [self.navigationController pushViewController:fabuVC animated:YES];
}
-(void)sureWithpzStr:(NSString *)Str
{
    ShowActionV();
    Str=[Str stringByReplacingOccurrencesOfString:@"，" withString:@","];
  
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"product"]=Str;
    NSString *bodyStr=[ZIKFunction convertToJsonData:dic];
    [HTTPCLIENT jjrdetialChangeWithbodyStr:bodyStr Success:^(id responseObject){
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"修改成功"];
            
            [self.pinzhongBtn setTitle:Str forState:UIControlStateNormal];
            
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)selectMrCodeAction:(UIButton *)sender
{
    if (self.mrAreaV==nil) {
        NSDictionary *dic=self.cityAry[sender.tag];
        JJRMyAreaView *view=(JJRMyAreaView *)sender.superview;
        [view setBackgroundColor:kRGB(245, 253, 242, 1)];
        
        self.mrAreaV=view;
        view.moLab.hidden=NO;
        [view.wareLab setTextColor:NavColor];
        [view.wareLab setText:dic[@"name"]];
        self.mrcode=dic[@"code"];
        [view.bgImageV setImage:[ZIKFunction imageWithSize:view.bgImageV.frame.size borderColor:NavColor borderWidth:1]];
        NSMutableDictionary *dics=[NSMutableDictionary dictionary];
        dics[@"defaultArea"]=self.mrcode;
        NSString *bodyStr=[ZIKFunction convertToJsonData:dics];
        [HTTPCLIENT jjrdetialChangeWithbodyStr:bodyStr Success:^(id responseObject){
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"修改成功"];
                
        
                
            }
        } failure:^(NSError *error) {
            
        }];

    }else{
        if (sender.tag==self.mrAreaV.actionBtn.tag) {
            return;
        }else
        {
            
            [self.mrAreaV setBackgroundColor:[UIColor whiteColor]];
            self.mrAreaV.moLab.hidden=YES;
            [self.mrAreaV.wareLab setTextColor:MoreDarkTitleColor];
            [self.mrAreaV.bgImageV setImage:[ZIKFunction imageWithSize:self.mrAreaV.bgImageV.frame.size borderColor:detialLabColor borderWidth:1]];
            NSDictionary *dic=self.cityAry[sender.tag];
            JJRMyAreaView *view=(JJRMyAreaView *)sender.superview;
            [view setBackgroundColor:kRGB(245, 253, 242, 1)];
            
            self.mrAreaV=view;
            view.moLab.hidden=NO;
            [view.wareLab setTextColor:NavColor];
            [view.wareLab setText:dic[@"name"]];
            self.mrcode=dic[@"code"];
            [view.bgImageV setImage:[ZIKFunction imageWithSize:view.bgImageV.frame.size borderColor:NavColor borderWidth:1]];
            NSMutableDictionary *dics=[NSMutableDictionary dictionary];
            dics[@"defaultArea"]=self.mrcode;
            NSString *bodyStr=[ZIKFunction convertToJsonData:dics];
            [HTTPCLIENT jjrdetialChangeWithbodyStr:bodyStr Success:^(id responseObject){
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    [ToastView showTopToast:@"修改成功"];
                }
            } failure:^(NSError *error) {
                
            }];

            
        }
    }
    
    
}
#pragma mark - 确定返回后，传回地址执行协议
- (void)selectCitysInfo:(NSString *)citysStr {
    //    self.screenView.hidden = NO;
    _citysStr = citysStr;
//    if (self.areaMArr.count > 0) {
//        [self.areaMArr removeAllObjects];
//    }
    GetCityDao *citydao = [GetCityDao new];
    [citydao openDataBase];
    __block NSString *str = @"";
    NSArray *cityArray = [_citysStr componentsSeparatedByString:@","];
    NSMutableArray *cityDicAry=[NSMutableArray array];
    __block BOOL hasmrcode=NO;
    [cityArray enumerateObjectsUsingBlock:^(NSString *cityCode, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic=[citydao getcityDicByCityCode:cityCode];
        if ([self.mrcode isEqualToString:cityCode]) {
            hasmrcode=YES;
        }
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",dic[@"name"]]];
        [cityDicAry addObject:dic];
    }];
    self.cityAry=cityDicAry;
    [citydao closeDataBase];
    if (hasmrcode==NO) {
        self.mrcode=[cityArray firstObject];
    }
    ShowActionV();
    NSMutableDictionary *dics=[NSMutableDictionary dictionary];
    dics[@"defaultArea"]=self.mrcode;
    NSArray *businessAreaAry=[citysStr componentsSeparatedByString:@","];
    dics[@"businessArea"]=businessAreaAry;
    NSString *bodyStr=[ZIKFunction convertToJsonData:dics];
    [HTTPCLIENT jjrdetialChangeWithbodyStr:bodyStr  Success:^(id responseObject){
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"修改成功"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.quyuBtn setTitle:@"" forState:UIControlStateNormal];
                for (UIView *view in self.areaView.subviews) {
                    
                    if (view.tag!=20) {
                        [view removeFromSuperview];
                    }
                }
                if (self.cityAry.count>0) {
                    CGRect frame=self.areaView.frame;
                    frame.size.height=50*self.cityAry.count+60;
                    self.areaView.frame=frame;
                    
                   
                    self.areaView.hidden=NO;
                    for (int i=0; i<self.cityAry.count; i++) {
                        NSDictionary *dic=self.cityAry[i];
                        JJRMyAreaView *view=[JJRMyAreaView jjrMyAreaView];
                        CGRect tempFrame=view.frame;
                        tempFrame.size.width=kWidth-117;
                        tempFrame.origin.x=0;
                        tempFrame.size.height=40;
                        tempFrame.origin.y=60+50*i;
                        view.frame=tempFrame;
                        
                        view.wareLab.text=dic[@"name"];
                        [view.actionBtn addTarget:self action:@selector(selectMrCodeAction:) forControlEvents:UIControlEventTouchUpInside];
                        view.actionBtn.tag=i;
                        NSString *code=dic[@"code"];
                        if ([code isEqualToString:self.mrcode]) {
                            [view setBackgroundColor:kRGB(245, 253, 242, 1)];
                            self.mrAreaV=view;
                            view.moLab.hidden=NO;
                            [view.wareLab setTextColor:NavColor];
                            [view.bgImageV setImage:[ZIKFunction imageWithSize:view.bgImageV.frame.size borderColor:NavColor borderWidth:1]];
                        }else{
                            [view setBackgroundColor:[UIColor whiteColor]];
                            view.moLab.hidden=YES;
                            [view.wareLab setTextColor:MoreDarkTitleColor];
                            [view.bgImageV setImage:[ZIKFunction imageWithSize:view.bgImageV.frame.size borderColor:detialLabColor borderWidth:1]];
                        }
                        [self.areaView addSubview:view];
                    }
                    
                    
                }else{
                    self.areaView.hidden=YES;
                }
                
            });
            
            

 
        }
    } failure:^(NSError *error) {
        
    }];
 
//
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
//        [dicionary setObject:cityModel.province.provinceID forKey:@"id"];
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
    if (_citysStr) {
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
