//
//  YLDShopNameViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/26.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShopNameViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
@interface YLDShopNameViewController ()
@property (nonatomic,copy)NSString *str;
@end

@implementation YLDShopNameViewController
-(id)initWithMessage:(NSString *)str
{
    self=[super init];
    if (self) {
        self.str=str;
    }
    return  self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"店铺名称";
    YLDRangeTextView *textView=[[YLDRangeTextView alloc]initWithFrame:CGRectMake(0, 70, kWidth, 100)];
    [textView setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:textView];
    self.textView=textView;
    textView.text=self.str;
    textView.rangeNumber=20;
    textView.placeholder=@"请输入店铺名称";
    [self.wareView addTextWithAry:@[@"1、名称由汉字、字母或数字组成；",@"2、不能包含“@＃％&”等特殊字符；",@"3、名称字数不超过20个字符。"]];
    // Do any additional setup after loading the view from its nib.
    [self.sureBtn addTarget:self action:@selector(sureBtnAcion) forControlEvents:UIControlEventTouchUpInside];
}
-(void)sureBtnAcion
{
    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(self.textView.text.length <=0)
    {
        [ToastView showTopToast:@"请输入名称"];
        return;
    }
    if(![pred evaluateWithObject: self.textView.text])
    {
        [ToastView showTopToast:@"名称只能由汉字、字母或数字组成"];
        return;
    }
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"name"]=self.textView.text;
    NSString *bodyStr=[ZIKFunction convertToJsonData:dic];
    [HTTPCLIENT getMyShopBaseMessageUpDataWithbodyStr:bodyStr Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
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
