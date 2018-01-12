//
//  YLDFEOrderFaBuTwoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/8.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFEOrderFaBuTwoViewController.h"
#import "YLDFEngineeMMTableViewCell.h"
#import "YLDFUserCenterViewController.h"
#import "YLDFEngineeringMMEidtViewController.h"
@interface YLDFEOrderFaBuTwoViewController ()<YLDRangeTextViewDelegate,UITableViewDelegate,UITableViewDataSource,YLDFEngineeMMTableViewCellDelegate,YLDFEngineeringMMEidtViewControllerDelegate>
@property (nonatomic,strong)NSMutableArray *MMAry;
@end

@implementation YLDFEOrderFaBuTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    self.vcTitle=@"苗木清单";
    self.miaoMuNameTextField.rangeNumber=20;
    self.miaomuNumTextField.rangeNumber=16;
    self.shuomingTextView.rangeNumber=70;
    self.shuomingTextView.placeholder=@"请输入苗木规格要求（不超过70字）";
    self.shuomingTextView.Rdelegate=self;
    self.addMMBtn.layer.masksToBounds=YES;
    self.addMMBtn.layer.cornerRadius=5;
    self.addMMBGV.layer.shadowOpacity = 0.5;// 阴影透明度
    
    self.addMMBGV.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    
    self.addMMBGV.layer.shadowRadius = 2;// 阴影扩散的范围控制
    
    self.addMMBGV.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
    

    self.MMAry=[NSMutableArray array];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.shangyibuBtn.layer.masksToBounds=YES;
    self.shangyibuBtn.layer.cornerRadius=5;
    self.shangyibuBtn.layer.borderWidth=1;
    self.shangyibuBtn.layer.borderColor=NavColor.CGColor;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)fabuBtnAction:(UIButton *)sender {
    if (self.MMAry.count==0) {
        [ToastView showTopToast:@"请至少添加一条苗木"];
        return;
    }
    NSMutableDictionary *pushDic=[NSMutableDictionary dictionaryWithDictionary:self.dic];
    [pushDic setObject:self.MMAry forKey:@"items"];
    NSString *bodyStr=[ZIKFunction convertToJsonData:pushDic];
    [HTTPCLIENT fabuGongChengDingDanWithBodyStr:bodyStr Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            for(UIViewController *controller in self.navigationController.viewControllers) {
                if([controller isKindOfClass:[YLDFUserCenterViewController class]]){
//               YLDFUserCenterViewController *owr = (YLDFUserCenterViewController *)controller;
                    [ToastView showTopToast:@"发布成功"];
                    [self.navigationController popToViewController:controller animated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"GCDDFB" object:[responseObject objectForKey:@"data"]];
                }
            }
       
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (IBAction)shangyibuBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addBtnAction:(UIButton *)sender {
    if (self.miaoMuNameTextField.text.length==0) {
        [ToastView showTopToast:@"请输入苗木名称"];
        return;
    }
    if (self.miaomuNumTextField.text.length==0) {
        [ToastView showTopToast:@"请输入采购数量"];
        return;
    }
    if (self.shuomingTextView.text.length==0) {
        [ToastView showTopToast:@"请输入苗木规格说明"];
        return;
    }
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"itemName"]=self.miaoMuNameTextField.text;
    dic[@"quantity"]=self.miaomuNumTextField.text;
    dic[@"demand"]=self.shuomingTextView.text;
    [ToastView showTopToast:@"添加成功"];
    if (self.MMAry.count==0) {
        [self.MMAry addObject:dic];
    }else{
        [self.MMAry insertObject:dic atIndex:0];
    }
    self.miaoMuNameTextField.text=nil;
    self.miaomuNumTextField.text=nil;
    self.shuomingTextView.text=nil;
    self.shuomingTextView.Rdelegate=self;
    self.textNumLab.text=@"0/70";
    [self.tableView reloadData];
}
-(void)mmCellEditWithDic:(NSMutableDictionary *)dic
{
    YLDFEngineeringMMEidtViewController *vc=[YLDFEngineeringMMEidtViewController new];
    vc.dic=dic;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
//    [self.tableView reloadData];
}
-(void)mmEditSuccessWithDic:(NSDictionary *)dic
{
    [self.tableView reloadData];
}
-(void)mmCellDeleteWithDic:(NSDictionary *)dic
{
    __weak typeof(self)weakSelf=self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除苗木" message:@"您确定要删除该苗木？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.MMAry removeObject:dic];
        [weakSelf.tableView reloadData];
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDFEngineeMMTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDFEngineeMMTableViewCell"];
    if (!cell) {
        cell=[YLDFEngineeMMTableViewCell yldFEngineeMMTableViewCell];
        cell.delegate=self;
    }
    cell.dic=self.MMAry[indexPath.row];
    cell.numLab.text=[NSString stringWithFormat:@"%ld",indexPath.row+1];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.MMAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
    tableView.estimatedRowHeight = 135;
    return tableView.rowHeight;
    
}
-(void)textChangeNowLength:(NSInteger)length{
    self.textNumLab.text=[NSString stringWithFormat:@"%ld/70",length];
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
