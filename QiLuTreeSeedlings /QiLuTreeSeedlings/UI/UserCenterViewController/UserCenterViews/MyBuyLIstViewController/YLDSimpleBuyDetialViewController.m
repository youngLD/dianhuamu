//
//  YLDSimpleBuyDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/3/13.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSimpleBuyDetialViewController.h"
#import "HttpClient.h"
#import "ZIKFunction.h"
//#import "buyFabuViewController.h"
@interface YLDSimpleBuyDetialViewController ()
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *ecttivLab;
@property (nonatomic,strong) UIButton *editingBtn;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic) BOOL go;
@end

@implementation YLDSimpleBuyDetialViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_go==YES) {
        _go=NO;
        [self reoladAction];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle =@"求购详情";
    UIButton *editingBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 26, 50, 30)];
    [editingBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    self.editingBtn=editingBtn;
    [editingBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editingBtn addTarget:self action:@selector(editingBtnAction) forControlEvents:UIControlEventTouchUpInside];
    if (self.model.state==3) {
        [self.navBackView addSubview:editingBtn];
    }else{
        [self.editingBtn removeFromSuperview];
    }
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    self.scrollView =scrollView;
    [self.view addSubview:scrollView];
    
    CGRect frame=CGRectMake(0, 0, kWidth, 50);
    self.titleLab=[self makeViewWithTitle:@"标题" WithDetial:self.model.title WithTempFrame:frame];
    frame.origin.y+=50;
    self.timeLab=[self makeViewWithTitle:@"发布时间" WithDetial:self.model.creatTime WithTempFrame:frame];
    frame.origin.y+=50;
    NSArray *ectivAry= @[@"一天",@"三天",@"五天",@"一周",@"半个月",@"一个月",@"三个月",@"半年",@"一年",@"长期"];
    NSInteger index=0;
    switch (self.model.effectiveTime) {
        case 6:
            index=0;
            break;
        case 7:
            index=1;
            break;
        case 8:
            index=2;
            break;
        case 9:
            index=3;
            break;
        case 10:
            index=4;
            break;
        case 2:
            index=5;
            break;
        case 3:
            index=6;
            break;
        case 4:
            index=7;
            break;
        case 5:
            index=8;
            break;
        case 1:
            index=9;
            break;
        default:
            index=0;
            break;
    }

    self.ecttivLab=[self makeViewWithTitle:@"有效期" WithDetial:ectivAry[index] WithTempFrame:frame];
    UILabel *bireftitleLab=[[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(frame)+15, 70, 18)];
    [bireftitleLab setTextColor:titleLabColor];
    [bireftitleLab setFont:[UIFont systemFontOfSize:15]];
    [bireftitleLab setText:@"求购信息"];
    [scrollView addSubview:bireftitleLab];
    UITextView *detialLab=[[UITextView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(bireftitleLab.frame)+10, kWidth-30, 180)];
    detialLab.editable=NO;
    self.textView=detialLab;
    [detialLab setFont:[UIFont systemFontOfSize:15]];
    detialLab.text=self.model.details;
    [scrollView addSubview:detialLab];
    UILabel *tishiLab=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(detialLab.frame)+5, kWidth-40, 20)];
    [tishiLab setFont:[UIFont systemFontOfSize:15]];
    tishiLab.numberOfLines=0;
    [tishiLab setTextColor:RedBtnColor];
    [tishiLab setText:@"提示：你所发布的简易求购会由后台工作人员审核后自动转换为一条或多条标准求购信息。"];
    [tishiLab sizeToFit];
    [scrollView addSubview:tishiLab];
    [scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(tishiLab.frame)+10)];
    
    // Do any additional setup after loading the view.
}
-(void)editingBtnAction
{
//    buyFabuViewController *fabuVC=[[buyFabuViewController alloc]initWithsimelpeModel:self.model];
//    _go=YES;
//    [self.navigationController pushViewController:fabuVC animated:YES];
}
-(void)reoladAction
{
    [HTTPCLIENT simplebuyWithUid:self.model.uid Success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            self.model =[HotBuyModel simpleBuyModelCreatByDic:[responseObject objectForKey:@"result"]];
            self.titleLab.text=self.model.title;
            self.timeLab.text=self.model.creatTime;
            NSArray *ectivAry= @[@"一天",@"三天",@"五天",@"一周",@"半个月",@"一个月",@"三个月",@"半年",@"一年",@"长期"];
            NSInteger index=0;
            switch (self.model.effectiveTime) {
                case 6:
                    index=0;
                    break;
                case 7:
                    index=1;
                    break;
                case 8:
                    index=2;
                    break;
                case 9:
                    index=3;
                    break;
                case 10:
                    index=4;
                    break;
                case 2:
                    index=5;
                    break;
                case 3:
                    index=6;
                    break;
                case 4:
                    index=7;
                    break;
                case 5:
                    index=8;
                    break;
                case 1:
                    index=9;
                    break;
                default:
                    index=0;
                    break;
            }
            self.ecttivLab.text=ectivAry[index];
            self.textView.text=self.model.details;
            if (self.model.state==3) {
                [self.navBackView addSubview:self.editingBtn];
            }else{
                [self.editingBtn removeFromSuperview];
            }
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(UILabel *)makeViewWithTitle:(NSString *)title WithDetial:(NSString *)detial WithTempFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, kWidth*0.2, frame.size.height)];
    nameLab.text=title;
    [nameLab setTextColor:titleLabColor];
//    [nameLab setTextAlignment:NSTextAlignmentRight];
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:nameLab];
    UILabel *textField=[[UILabel alloc]initWithFrame:CGRectMake(kWidth*0.35, 0, kWidth*0.53, frame.size.height)];
    [textField setFont:[UIFont systemFontOfSize:15]];
    [textField setText:detial];
    [view addSubview:textField];
    [textField setTextColor:DarkTitleColor];
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, frame.size.height-0.5, kWidth-20, 0.5)];
    [lineView setBackgroundColor:kLineColor];
    [view addSubview:lineView];
    [self.scrollView addSubview:view];
    [view setBackgroundColor:[UIColor whiteColor]];
    return textField;
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
