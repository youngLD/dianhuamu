//
//  YLDFQYInfoEditViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/6.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFQYInfoEditViewController.h"

@interface YLDFQYInfoEditViewController ()
@property (nonatomic,copy)NSString *keyWord;
@end

@implementation YLDFQYInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    if (self.type==1) {
        self.vcTitle=@"企业名称";
        self.textField.rangeNumber=50;
        self.textField.text=APPDELEGATE.qyModel.name;
        self.keyWord=@"name";
    }
    if (self.type==2) {
        self.vcTitle=@"企业地址";
        self.textField.rangeNumber=60;
        self.textField.text=APPDELEGATE.qyModel.address;
        self.keyWord=@"address";
    }
    if (self.type==3) {
        self.vcTitle=@"负责人";
        self.textField.rangeNumber=8;
        self.textField.text=APPDELEGATE.qyModel.linkman;
        self.keyWord=@"linkman";
    }
    if (self.type==4) {
        self.vcTitle=@"联系方式";
        self.textField.rangeNumber=11;
        self.textField.keyboardType=UIKeyboardTypePhonePad;
        self.textField.text=APPDELEGATE.qyModel.contactInformation;
        self.keyWord=@"contactInformation";
    }
    self.rightBarBtnTitleString=@"保存";
    __weak typeof(self)weakSelf=self;
    self.rightBarBtnBlock=^{
        if (self.textField.text.length==0) {
            [ToastView showTopToast:@"您还未输入内容"];
        }
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"name"]=APPDELEGATE.qyModel.name;
        dic[@"address"]=APPDELEGATE.qyModel.address;
        dic[@"linkman"]=APPDELEGATE.qyModel.linkman;
        dic[@"contactInformation"]=APPDELEGATE.qyModel.contactInformation;
        dic[weakSelf.keyWord]=weakSelf.textField.text;
        NSString *bodyStr =[ZIKFunction convertToJsonData:dic];
        [HTTPCLIENT upDataEnterpriseInfoWithBodyStr:bodyStr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                APPDELEGATE.qyModel=[YLDFQYInfoModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
                [ToastView showTopToast:@"修改成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    };
    // Do any additional setup after loading the view from its nib.
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
