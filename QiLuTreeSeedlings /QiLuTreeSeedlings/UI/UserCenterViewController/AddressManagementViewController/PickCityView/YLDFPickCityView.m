//
//  YLDFPickCityView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/26.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFPickCityView.h"
#import "UIDefines.h"

#define kActionVTag 17778
@interface YLDFPickCityView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)NSMutableArray *ProvinceArray;
@property(nonatomic,strong)NSArray *cityArray;
@property(nonatomic,strong)NSArray *townArray;
@property(nonatomic,strong)NSArray *dataArray;

@property (nonatomic,assign)NSInteger      selectRowWithProvince; //选中的省份对应的下标

@property (nonatomic,assign)NSInteger      selectRowWithCity; //选中的市级对应的下标

@property (nonatomic,assign)NSInteger      selectRowWithTown; //选中的县级对应的下标
@property (nonatomic,strong)UIView *toolView;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *sureBtn;
@end
@implementation YLDFPickCityView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        self.tag=kActionVTag;
        _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, 216)];
        self.ProvinceArray=[NSMutableArray array];
        _pickerView.backgroundColor=[UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        GetCityDao *dao=[GetCityDao new];
        [dao openDataBase];
       NSMutableArray *Provincearray= [dao getCityByLeve:@"1"];
      
            
        NSArray   *ProvincemodelAry=[CityModel creatCityAryByAry:Provincearray];
        [self.ProvinceArray addObjectsFromArray:ProvincemodelAry];
        CityModel *Provincemodel=[ProvincemodelAry firstObject];
        NSArray   *cityAry = [dao getCityByLeve:@"2" andParent_code:Provincemodel.code];
        self.cityArray=[CityModel creatCityAryByAry:cityAry];
        CityModel *cityModel=[self.cityArray firstObject];
        NSArray   *townAry = [dao getCityByLeve:@"3" andParent_code:cityModel.code];
        self.townArray=[CityModel creatCityAryByAry:townAry];
        [dao closeDataBase];
        [self addSubview:self.pickerView];
        self.selectRowWithProvince=0;
        self.selectRowWithCity=0;
        self.selectRowWithTown=0;
        self.toolView =[[UIView alloc]initWithFrame:CGRectMake(0, -55, kWidth, 40)];
        [self.toolView setBackgroundColor:[UIColor whiteColor]];
        self.cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:kRedHintColor forState:UIControlStateNormal];
        self.sureBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 0, 70, 40)];
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:NgreenColor   forState:UIControlStateNormal];
        [self.toolView addSubview:self.cancelBtn];
        [self.toolView addSubview:self.sureBtn];
        [self addSubview:self.toolView];
        [self setBackgroundColor:kRGB(100, 100, 100, 0.3)];
        [self.cancelBtn addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    
    NSInteger integer=0;
    
    if (component==0) {
        
        integer=self.ProvinceArray.count;
    }
    else if (component==1)
    {
        
        integer=_cityArray.count;
    }
    else if (component==2)
    {
        integer=_townArray.count;
        
    }
    
    return integer;
    
}
#pragma mark =====
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *string =nil;
    
    
    if (component==0) {
        CityModel * model= self.ProvinceArray[row];
        
        string=model.cityName;
    }
    else if (component==1)
    {

        CityModel * model= self.cityArray[row];

        string=model.cityName;
       
        
    }
    else if (component==2)
    {
        CityModel * model= self.townArray[row];
        
        string=model.cityName;
        
    }
    
    return string;
    
}
#pragma mark ===== 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return kWidth/3;
}

#pragma mark ===== 行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}


#pragma mark ===== 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    if (component==0)
    {
        self.selectRowWithProvince=row;
        self.selectRowWithCity=0;
        GetCityDao *dao=[GetCityDao new];
        [dao openDataBase];
        CityModel *Provincemodel=_ProvinceArray[row];
        NSArray   *cityAry = [dao getCityByLeve:@"2" andParent_code:Provincemodel.code];
        self.cityArray=[CityModel creatCityAryByAry:cityAry];
        CityModel *cityModel=[self.cityArray firstObject];
        NSArray   *townAry = [dao getCityByLeve:@"3" andParent_code:cityModel.code];
        self.townArray=[CityModel creatCityAryByAry:townAry];
        [dao closeDataBase];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        
    }
    else if (component==1)
    {
        self.selectRowWithCity=row;
        GetCityDao *dao=[GetCityDao new];
       [dao openDataBase];
        CityModel *cityModel=self.cityArray[row];
        NSArray   *townAry = [dao getCityByLeve:@"3" andParent_code:cityModel.code];
        self.townArray=[CityModel creatCityAryByAry:townAry];
        [dao closeDataBase];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        
    }
    else
    {
        self.selectRowWithTown=row;
    }
    
    
}
-(void)sureBtnAction
{
    [self removeAction];
    if (self.delegate) {
        CityModel *shenModel=self.ProvinceArray[_selectRowWithProvince];
        CityModel *shiModel=self.cityArray[_selectRowWithCity];
        CityModel *townModel=self.townArray[_selectRowWithTown];
        [self.delegate selectSheng:shenModel shi:shiModel xian:townModel zhen:nil];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textColor=kRGB(33, 33, 33, 1);
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = kRedHintColor;
        }
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
}
-(void)showAction
{
    self.alpha = 1;
    [self setFrame:[UIScreen mainScreen].bounds];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    CGRect tempframe=self.toolView.frame;
    tempframe.origin.x=0;
    tempframe.origin.y=-40;
    CGRect tempframe2=self.pickerView.frame;
    tempframe2.origin.x=0;
    tempframe2.origin.y=kHeight+300;
    self.toolView.frame=tempframe;
    self.pickerView.frame=tempframe2;
    
    tempframe.origin.x=0;
    tempframe.origin.y=kHeight-216-40;

    tempframe2.origin.x=0;
    tempframe2.origin.y=kHeight-216;
    [UIView animateWithDuration:0.3 animations:^{
        self.toolView.frame=tempframe;
        self.pickerView.frame=tempframe2;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)removeAction
{
    NSArray *subViews = [[UIApplication sharedApplication] keyWindow].subviews;
    for (id object in subViews) {
        if ([[object class] isSubclassOfClass:[UIView class]]) {
            UIView *actionBView = (UIView *)object;
            if(actionBView.tag == kActionVTag)
            {
               
                CGRect tempframe=self.toolView.frame;
                tempframe.origin.x=-kWidth;

                CGRect tempframe2=self.pickerView.frame;
                tempframe2.origin.x=kWidth;
   
                ;
                [UIView animateWithDuration:0.3 animations:^{
                    self.toolView.frame=tempframe;
                    self.pickerView.frame=tempframe2;
                    
                } completion:^(BOOL finished) {
                    [actionBView removeFromSuperview];
                }];
                
            }
        }
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeAction];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
