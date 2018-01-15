//
//  YLDFQuoteDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/15.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFQuoteDetialViewController.h"
#import "UIImageView+AFNetworking.h"
@interface YLDFQuoteDetialViewController ()
#import "ZIKFunction.h"
@end

@implementation YLDFQuoteDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    self.vcTitle=@"报价详情";
    self.headerImageV.layer.masksToBounds=YES;
    self.headerImageV.layer.cornerRadius=self.headerImageV.frame.size.width/2;
    
    self.nameLab.text=self.model.name;
    self.priceLab.text=[NSString stringWithFormat:@"%@元",self.model.quote];
    self.guigeLab.text=[NSString stringWithFormat:@"规格说明:%@",self.model.demand];
    NSString *headerImagePath=self.model.headPortrait;
    if (headerImagePath) {
        [self.imgeV setImageWithURL:[NSURL URLWithString:headerImagePath]];
    }
    NSString *mmImagePath=[self.model.attacs firstObject][@"path"];
    if (mmImagePath) {
        [self.imgeV setImageWithURL:[NSURL URLWithString:mmImagePath]];
    }else{
        self.imgeV.hidden=YES;
        self.imageLab.hidden=YES;
        self.bottomL.constant=20;
    }
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)goShopAction:(UIButton *)sender {
    
}
- (IBAction)chatBtnAction:(UIButton *)sender {
    
}
- (IBAction)callBtnAction:(UIButton *)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
