//
//  YLDFMessageViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/5.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFMessageViewController.h"

@interface YLDFMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIButton *nowBtn;
@end

@implementation YLDFMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"消息";
    [self.backBtn removeFromSuperview];
    if (@available(iOS 11.0, *)) {
        _topC.constant=44.0;
    }
    CGRect frame=self.moveView.frame;
    frame.size.width=kWidth/3;
    frame.origin.x=0;
    frame.origin.y=44;
    self.moveView.frame=frame;
    self.buyMessageBtn.selected=YES;
    self.nowBtn=self.buyMessageBtn;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)topBtnAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.nowBtn.selected=NO;
    sender.selected=YES;
    self.nowBtn=sender;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=self.moveView.frame;
        
        frame.origin.x=(kWidth/3)*(sender.tag-1);
        
        self.moveView.frame=frame;
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[UITableViewCell new];
    
    return cell;
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
