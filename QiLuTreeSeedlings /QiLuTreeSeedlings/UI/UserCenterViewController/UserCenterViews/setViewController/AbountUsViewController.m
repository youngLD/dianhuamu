//
//  AbountUsViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/11.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "AbountUsViewController.h"
#import "UIDefines.h"
@interface AbountUsViewController ()

@end

@implementation AbountUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"关于我们";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-30, 35+64, 60, 60)];
    [imageV setImage:[UIImage imageNamed:@"logV"]];
    [imageV setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:imageV];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-60, CGRectGetMaxY(imageV.frame)+30, 120, 26)];
    [titleLab setFont:[UIFont systemFontOfSize:20]];
    [titleLab setTextColor:NavColor];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    titleLab.text=@"点花木";
    [self.view addSubview:titleLab];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    UILabel *versionLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-50,  CGRectGetMaxY(titleLab.frame)+8, 100, 20)];
    [versionLab setTextAlignment:NSTextAlignmentCenter];
    [versionLab setFont:[UIFont systemFontOfSize:15]];
    [versionLab setText:[NSString stringWithFormat:@"version:%@",app_build]];
    [versionLab setTextColor:titleLabColor];
    [self.view addSubview:versionLab];
   
    UILabel *guangwangLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-130,  CGRectGetMaxY(versionLab.frame)+8, 260, 20)];
    [guangwangLab setTextAlignment:NSTextAlignmentCenter];
    [guangwangLab setFont:[UIFont systemFontOfSize:14]];
    [guangwangLab setText:@"公司官网：http://www.somiao.top"];
    [guangwangLab setTextColor:titleLabColor];
    [self.view addSubview:guangwangLab];





    UILabel *rexianLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-100,  CGRectGetMaxY(guangwangLab.frame), 200, 20)];
    [rexianLab setTextAlignment:NSTextAlignmentCenter];
    [rexianLab setFont:[UIFont systemFontOfSize:14]];
    [rexianLab setText:@"公司热线：400 168 6717"];
    [rexianLab setTextColor:titleLabColor];
    [self.view addSubview:rexianLab];
    
    
    UILabel *lxxxab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-100,  kHeight-55, 200, 20)];
    [lxxxab setTextAlignment:NSTextAlignmentCenter];
    [lxxxab setFont:[UIFont systemFontOfSize:13]];
    [lxxxab setText:@"Copyinght©️ 2016-2018"];
    [lxxxab setTextColor:titleLabColor];
    [self.view addSubview:lxxxab];
    UILabel *lcccab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-100,  kHeight-40, 200, 20)];
    [lcccab setTextAlignment:NSTextAlignmentCenter];
    [lcccab setFont:[UIFont systemFontOfSize:13]];
    [lcccab setText:@"搜苗(上海)信息科技有限公司"];
    [lcccab setTextColor:titleLabColor];
    [self.view addSubview:lcccab];
    // Do any additional setup after loading the view.
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
