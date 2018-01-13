//
//  YLDFEOrderQuoteListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/10.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFEOrderQuoteListViewController.h"
#import "YLDFEorderQuoteTableViewCell.h"
@interface YLDFEOrderQuoteListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YLDFEOrderQuoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"报价详情";
    
    self.mmNameLab.text=self.model.itemName;
    self.personNumLab.text=[NSString stringWithFormat:@"%ld人",self.model.quoteCount];
    [HTTPCLIENT MyGongChengDingDanItemQuotesListWithitemId:self.model.engineeringProcurementItemId    WithorderId:self.orderStr Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
