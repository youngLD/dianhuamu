//
//  YLDFAddressListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/12.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFAddressListViewController.h"
#import "YLDFAddressListTableViewCell.h"
#import "YLDFAddressManagementViewController.h"

@interface YLDFAddressListViewController ()<UITableViewDelegate,UITableViewDataSource,YLDFAddressListTableViewCellDelegate,YLDFAddressManagementDelegate>
@property (nonatomic,strong)NSMutableArray *dataAry;
@end

@implementation YLDFAddressListViewController
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [APPDELEGATE getdefaultAddress];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry=[NSMutableArray array];
    self.vcTitle=@"地址管理";
    [self.addBtn addTarget:self action:@selector(addbtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self dataList];
 self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        // Fallback on earlier versions
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)dataList
{
    [HTTPCLIENT addressListSuccess:^(id responseObject) {
        if([[responseObject objectForKey:@"success"] integerValue])
        {
          
            [self.dataAry removeAllObjects];
            NSArray *ary=[responseObject objectForKey:@"data"];
            APPDELEGATE.addressAry=ary;
            NSArray *modelAry=[YLDFAddressModel creatAryWithary:ary];
            if (modelAry.count==0) {
                [ToastView showTopToast:@"您暂无地址"];
            }else{
                
                [self.dataAry addObjectsFromArray:modelAry];
            }
            [self.tableView reloadData];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    [APPDELEGATE getdefaultAddress];
}
-(void)addbtnAction
{
    YLDFAddressManagementViewController *vc=[YLDFAddressManagementViewController new];
    if (self.dataAry.count==0) {
        vc.isDefault=YES;
    }
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDFAddressListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDFAddressListTableViewCell"];
    if (!cell) {
        cell=[YLDFAddressListTableViewCell yldFAddressListTableViewCell];
        cell.delegate=self;
        cell.lineV.image=[ZIKFunction imageWithSize:cell.lineV.frame.size borderColor:kLineColor borderWidth:1];
        
    }
    cell.model=self.dataAry[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YLDFAddressModel *model=self.dataAry[indexPath.row];
    if (self.delegate) {
        
        [self.delegate selectWithYLDFAddressModel:model];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)addressDeleteWithModel:(YLDFAddressModel *)model
{
    if(model.defaultAddress)
    {
        [ToastView showTopToast:@"默认地址不可删除"];
        return;
    }
    __weak typeof(self)weakself =self;
    //在这里呼出下方菜单按钮项
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除地址" message:@"您确定要删除该地址，删除后无法恢复。" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [HTTPCLIENT deleteAddressWithaddressId:model.addressId Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [weakself dataList];
                if (self.delegate) {
                    [self.delegate deleteWithYLDFAddressModel:model];
                }
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
        
    }]];
     [self presentViewController:alertController animated:YES completion:nil];
}
-(void)addressEditWithModel:(YLDFAddressModel *)model
{
    YLDFAddressManagementViewController *vc=[YLDFAddressManagementViewController new];
    if (model.defaultAddress) {
        vc.isDefault=YES;
    }
    vc.model=model;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)addSuccessWithaddressDic:(NSDictionary *)addressdic
{
    [self dataList];
}
-(void)addressSelectWithModel:(YLDFAddressModel *)model
{
    [HTTPCLIENT setDefaultAddressWithaddressId:model.addressId Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [self dataList];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
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
