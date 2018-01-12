//
//  YLDSearchActionViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/3/8.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSearchActionViewController.h"
#import "SearchRecommendView.h"
#import "HttpClient.h"
#import "UIDefines.h"
@interface YLDSearchActionViewController ()<SearchRecommendViewDelegate>
@property (nonatomic,weak) UIButton *nowBtn;
@property (nonatomic,strong)UIView *moveView;
@end

@implementation YLDSearchActionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [HTTPCLIENT hotkeywordWithkeywordCount:@"10" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *Dic =[responseObject objectForKey:@"result"];
            NSArray *ary=[Dic objectForKey:@"productList"];
            
                SearchRecommendView *searchRView = [[SearchRecommendView
                                                     alloc] initWithFrame:CGRectMake(0, 64+44, kWidth, kHeight-64-44) WithAry:ary];
//                self.searchRecommendView=searchRView;
                searchRView.delegate=self;
                [self.view addSubview:searchRView];
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    if (self.searchType<=0) {
        self.searchType=1;
    }
    if (self.searchType>3) {
        self.searchType=3;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self creatNavView];
    self.searchTextField.text=self.searchStr;
    // Do any additional setup after loading the view.
}
- (void)SearchRecommendViewSearch:(NSString *)searchStr
{
    if (self.delegate) {
        [self.delegate searchActionWithType:self.searchType searchString:searchStr];
    }
    [self backBtnAction:nil];
}
- (void)SearchRecommendViewSearchDIC:(NSDictionary *)dic
{
    NSString *nameStr=dic[@"productName"];
    if (self.delegate) {
        [self.delegate searchActionWithType:self.searchType searchString:nameStr];
    }
    [self backBtnAction:nil];
}
- (void)creatNavView {
    UIView *searchBackV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    [searchBackV setBackgroundColor:kRGB(240, 240, 240, 1)];
    [self.view addSubview:searchBackV];
    
//    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 27, 30, 30)];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtnBlack"] forState:UIControlStateNormal];
//    [backBtn setEnlargeEdgeWithTop:15 right:20 bottom:10 left:10];
//    [searchBackV addSubview:backBtn];
//    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIView * searchsssskV=[[UIView alloc]initWithFrame:CGRectMake(20, 25,kWidth-80, 34)];
    searchsssskV.layer.masksToBounds=YES;
    searchsssskV.layer.cornerRadius=17;
    [searchsssskV setBackgroundColor:[UIColor whiteColor]];
    UIImageView *searchIamV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 4.5, 25, 25)];
    searchIamV.tag=12;
    searchIamV.image=[UIImage imageNamed:@"serachSG"];
    [searchsssskV addSubview:searchIamV];
    [searchBackV addSubview:searchsssskV];
    UITextField * searchMessageField=[[UITextField alloc]initWithFrame:CGRectMake(40, 0,kWidth-120, 34)];

    [searchMessageField setBackgroundColor:[UIColor clearColor]];
    [searchMessageField setTextColor:titleLabColor];
    searchMessageField.placeholder=@"请输入搜索关键词";
    [searchMessageField setFont:[UIFont systemFontOfSize:15]];
    self.searchTextField=searchMessageField;
    searchMessageField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [searchsssskV addSubview:searchMessageField];
    
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 27, 50, 30)];
    [searchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setTitleColor:titleLabColor forState:UIControlStateNormal];
    [searchBackV addSubview:searchBtn];
    UIView *typeView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    [typeView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:typeView];
    NSArray *btnAry=@[@"供应",@"求购",@"工程订单",@"企业"];
    for (int i=0; i<btnAry.count; i++) {
        NSString *title=btnAry[i];
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/4*i, 0, kWidth/4, 50)];
        [btn setTitleColor:DarkTitleColor forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:NavColor forState:UIControlStateSelected];
        [btn setTitle:title forState:UIControlStateSelected];
        
        btn.tag=i+1;
        [btn addTarget:self action:@selector(searchTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [typeView addSubview:btn];
        if (btn.tag==self.searchType) {
            btn.selected=YES;
            self.nowBtn=btn;
        }
    }
    UIView *moveView=[[UIView alloc]initWithFrame:CGRectMake(12, 47.5, kWidth/4-24, 2.5)];
    self.moveView=moveView;
    [moveView setBackgroundColor:NavColor];
    [typeView addSubview:moveView];
}
-(void)searchBtnAction
{
    if (self.delegate) {
        [self.delegate searchActionWithType:self.searchType searchString:self.searchTextField.text];
    }
    [self backBtnAction:nil];
}
-(void)searchTypeAction:(UIButton *)sender
{
    if (sender.selected==YES) {
        return;
    }
    self.searchType=sender.tag;
    sender.selected=YES;
    self.nowBtn.selected=NO;
    self.nowBtn=sender;
    CGRect frame=self.moveView.frame;
    frame.origin.x=kWidth/4*(sender.tag-1)+12;
    [UIView animateWithDuration:0.3 animations:^{
        self.moveView.frame=frame;
    }];
    
    
}
-(void)backBtnAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:^{
        
        
    }];
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
