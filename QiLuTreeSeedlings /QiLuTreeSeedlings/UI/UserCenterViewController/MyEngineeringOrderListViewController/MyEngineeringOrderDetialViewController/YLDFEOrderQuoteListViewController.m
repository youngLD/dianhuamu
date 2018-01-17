//
//  YLDFEOrderQuoteListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/10.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFEOrderQuoteListViewController.h"
#import "YLDFEorderQuoteTableViewCell.h"
#import "YLDFQuoteModel.h"
#import "YLDFQuoteDetialViewController.h"

@interface YLDFEOrderQuoteListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSArray *dataAry;
@end

@implementation YLDFEOrderQuoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"报价详情";
    
    self.mmNameLab.text=self.model.itemName;
//    self.personNumLab.text=[NSString stringWithFormat:@"%ld人",self.model.quoteCount];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [HTTPCLIENT MyGongChengDingDanItemQuotesListWithitemId:self.model.engineeringProcurementItemId    WithorderId:self.orderStr Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *data=[responseObject objectForKey:@"data"];
//            if (data[@"quoteCount"]) {
//                self.personNumLab.text=[NSString stringWithFormat:@"%@人",data[@"quoteCount"]];
//            }
            
            NSArray *quotes=data[@"quotes"];
            self.personNumLab.text=[NSString stringWithFormat:@"%ld人",quotes.count];
            self.dataAry=[YLDFQuoteModel creatByAry:quotes];
            [self.tableView reloadData];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.estimatedRowHeight=83.0;
    tableView.rowHeight=UITableViewAutomaticDimension;
    return tableView.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDFEorderQuoteTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDFEorderQuoteTableViewCell"];
    if (!cell) {
        cell=[YLDFEorderQuoteTableViewCell yldFEorderQuoteTableViewCell];
    }
    cell.model=self.dataAry[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YLDFQuoteDetialViewController *vc=[YLDFQuoteDetialViewController new];
    vc.model=self.dataAry[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
