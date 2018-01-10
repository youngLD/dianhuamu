//
//  YLDFHomeFenYeViewConroller.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/10.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFHomeFenYeViewConroller.h"
#import "UIDefines.h"
@interface YLDFHomeFenYeViewConroller ()
@property (nonatomic,strong) UIButton *ActionVNowBtn;
@property (nonatomic,strong)UIView *topActionMoveV;
@property (nonatomic,assign)NSInteger lastType;
@end

@implementation YLDFHomeFenYeViewConroller

- (void)viewDidLoad {
    [super viewDidLoad];
   [self.view addSubview:[self creatGBTypeV]];
    // Do any additional setup after loading the view from its nib.
}
-(UIView *)creatGBTypeV
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 70)];
    NSArray *ary=@[@"推荐供应",@"推荐求购",@"推荐订单",@"头条"];
    for (int i=0; i<ary.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/4*i, 20, kWidth/4, 48)];
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        [btn setTitleColor:titleLabColor  forState:UIControlStateNormal];
        [btn setTitleColor:MoreDarkTitleColor  forState:UIControlStateSelected];
        btn.tag=i;
        [btn addTarget:self action:@selector(topActionVBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.selected=YES;
            self.ActionVNowBtn=btn;
        }
        [view addSubview:btn];
    }
    UIView *linV=[[UIView alloc]initWithFrame:CGRectMake(0, 69.5, kWidth, 0.5)];
    [linV setBackgroundColor:kLineColor];
    [view addSubview:linV];
    UIView *moveView=[[UIView alloc]initWithFrame:CGRectMake(0, 67, kWidth/4, 3)];
    [moveView setBackgroundColor:NavColor];
    [view addSubview:moveView];
    self.topActionMoveV=moveView;
    [view setBackgroundColor:[UIColor whiteColor]];
    
    return view;
}
-(void)topActionVBtnAction:(UIButton *)sender
{
    //    if (sender.selected) {
    //        return;
    //    }
    
    self.ActionVNowBtn.selected=NO;
    sender.selected=YES;
    self.lastType=sender.tag;
    self.ActionVNowBtn=sender;
    CGRect frame=self.topActionMoveV.frame;
    frame.origin.x=sender.tag*(kWidth/4);
    [UIView animateWithDuration:0.3 animations:^{
        self.topActionMoveV.frame=frame;
        [self reloadTableVVVWithLastType];
    }];
    
}
-(void)reloadTableVVVWithLastType
{
    if(_lastType==0)
    {
//        ShowActionV();
        
        
    }
    
    if(_lastType==1)
    {
//        ShowActionV();
        
    }
    
    if(_lastType==2)
    {
        
        
//        RemoveActionV();
        
    }
    if(_lastType==3)
    {
        
      
//        RemoveActionV();
        
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
