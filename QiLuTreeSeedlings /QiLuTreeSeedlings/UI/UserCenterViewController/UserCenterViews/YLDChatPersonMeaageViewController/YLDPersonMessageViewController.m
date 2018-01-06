//
//  YLDPersonMessageViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/1/11.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDPersonMessageViewController.h"
#import "UIDefines.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "UIImageView+AFNetworking.h"
@interface YLDPersonMessageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nickLab;
@property (weak, nonatomic) IBOutlet UILabel *identlyLab;
@property (weak, nonatomic) IBOutlet UILabel *phoenLab;
@property (weak, nonatomic) IBOutlet UIButton *senderBtn;

@end

@implementation YLDPersonMessageViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden==NO) {
        self.navigationController.navigationBarHidden=YES;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController.navigationBarHidden==YES) {
        self.navigationController.navigationBarHidden=NO;
    }
}
-(id)initWithFrom:(NSInteger)from withDic:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.from=from;
        self.dataDic=dic;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BGColor];
    self.imageV.layer.masksToBounds=YES;
    self.imageV.layer.cornerRadius=self.imageV.frame.size.width/2;
    [self.backBtn setEnlargeEdgeWithTop:0 right:40 bottom:10 left:10];
    [self.backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.identlyLab.text=self.dataDic[@"identity"];
    self.nickLab.text =self.dataDic[@"nick"];
    self.phoenLab.text=self.dataDic[@"phone"];
    if (self.isSender) {
        self.senderBtn.hidden=YES;
        self.senderBtn.enabled=NO;
    }
    NSString *urlStr=self.dataDic[@"avatar"];
    if (urlStr.length>0) {
        [self.imageV setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"UserImageV"]];
    }
    if (self.identlyLab.text.length==0) {
        self.identlyLab.text=@"客服";
    }
    if (self.phoenLab.text.length==0) {
        self.phoenLab.text=self.senderID;
    }
    if (self.nickLab.text.length==0) {
        self.nickLab.text=@"客服人员";
    }
    [self.senderBtn addTarget:self action:@selector(sendeMessageSender:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sendeMessageSender:(id)sender
{
    if (self.from==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.from==1) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:self.dataDic];
        dic[@"senderID"]=self.senderID;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"creatHuiHua" object:dic];
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
