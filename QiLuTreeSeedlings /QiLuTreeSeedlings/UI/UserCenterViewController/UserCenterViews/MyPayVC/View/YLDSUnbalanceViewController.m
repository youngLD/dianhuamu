//
//  YLDSUnbalanceViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/28.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSUnbalanceViewController.h"
#import "ZIKFunction.h"
@interface YLDSUnbalanceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *begionTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@end
@implementation YLDSUnbalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle = @"不可用余额";
    if (APPDELEGATE.userModel.goldsupplierStatus==5) {
        self.typeLab.text=@"工作站总站";
    }else if (APPDELEGATE.userModel.goldsupplierStatus==6)
    {
        self.typeLab.text=@"工作站分站";
    }else{
        self.typeLab.text=APPDELEGATE.userModel.goldsupplier;
    }
    self.moneyLab.text = [NSString stringWithFormat:@"%.2f",APPDELEGATE.userModel.creditMargin];
    self.begionTimeLab.text=APPDELEGATE.userModel.fromDate;
    self.endTimeLab.text=APPDELEGATE.userModel.thruDate;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
