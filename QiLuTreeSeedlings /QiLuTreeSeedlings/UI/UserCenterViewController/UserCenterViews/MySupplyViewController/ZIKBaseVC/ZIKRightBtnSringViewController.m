//
//  ZIKRightBtnSringViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/22.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"

@interface ZIKRightBtnSringViewController ()
{
//    @private
    
}
@end

@implementation ZIKRightBtnSringViewController
@synthesize back2Btn;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    back2Btn=[[UIButton alloc]initWithFrame:CGRectMake(Width-75, 26, 67, 30)];

    [back2Btn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:25];
    [back2Btn setTitle:self.rightBarBtnTitleString forState:UIControlStateNormal];
    [back2Btn setTintColor:[UIColor whiteColor]];
    [back2Btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:back2Btn];
    [back2Btn setTitleColor:NavTitleColor forState:UIControlStateNormal];
    [back2Btn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

//处理右侧的block回调
#pragma mark ---------------处理右侧的block回调-----------------
- (void)rightBtnClicked:(UIButton *)button
{
    if (self.rightBarBtnBlock) {
        self.rightBarBtnBlock();
    }
    //默认暂时没处理，有需要加上
}
-(void)rightbtnimage:(UIImage *)image frame:(CGRect)frame
{
    [back2Btn setImage:image forState:UIControlStateNormal];
    back2Btn.frame =frame;
}
//设置右侧按钮
#pragma mark ---------------设置右侧按钮-----------------
- (void)setRightBarBtnTitleString:(NSString *)rightBarBtnTitleString
{
    _rightBarBtnTitleString = rightBarBtnTitleString;
    [back2Btn setTitle:self.rightBarBtnTitleString forState:UIControlStateNormal];
}
-(void)setRightBarBtnTitleColor:(UIColor *)rightBarBtnTitleColor
{
    _rightBarBtnTitleColor=rightBarBtnTitleColor;
    [back2Btn setTitleColor:rightBarBtnTitleColor  forState:UIControlStateNormal];
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
