//
//  YLDShengJiViewViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShengJiViewViewController.h"
#import "UIDefines.h"
#import "YLDShenFenShuoMingCell.h"
#import "YLDGCGSZiZhiTiJiaoViewController.h"
#import "ZIKHelpfulHintsViewController.h"
#import "YLDJJRSHZViewController.h"
#import "YLDJJRenShenQing1ViewController.h"
#import "HttpClient.h"
#import "YLDJJRNotPassViewController.h"
@interface YLDShengJiViewViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation YLDShengJiViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"特权介绍";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView=tableView;
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        self.tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
        self.tableView.estimatedRowHeight = 180;
        return tableView.rowHeight;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDShenFenShuoMingCell *cell=[YLDShenFenShuoMingCell yldShenFenShuoMingCell];
//    if (indexPath.row==0) {
//        NSMutableDictionary *dic=[NSMutableDictionary new];
//        dic[@"title"]=@"全国苗木交易工作站";
//        dic[@"detial"]=@"成功申请工作站站长，您可享有：\n\n  1.工作站站长身份——有效化解苗木行业信任危机；\n\n  2.稀缺身份标识——苗木主产区，每个乡镇只设立一个分站，每个县区只设立五个乡镇；\n  3.统一制式的站长名片、工作站牌匾、站长工作证；\n  4.工作站六大盈利模式，有效提升站长苗木销售业绩；\n\n  5.工作站系统提供全国各地大量工程采购订单；\n\n  6.苗小二专属客服，不需要您发工资的苗木推销员；\n\n  7.获赠APP点花木求购信息定制费；\n\n  8.全国大量苗木行业经纪人求购订单；\n\n  9.站长内部专刊精准投放；\n\n  10.共享工作站、合作苗企、金牌供应商、苗木帮大量稀缺、低价货源；\n\n  工作站宗旨：在苗木行业出现严重信任危机的情况下，筛选一部分讲诚信的人，大家共同诚信做事儿，逐渐引领苗木行业走向诚信！\n工作站目标：协助您成为当地诚信、赚钱的苗木经经人！\n工作站口号：我是站长我骄傲、我是站长我自豪、我是站长我赚钱！";
//        cell.dic=dic;
//        
//    }

//    if (indexPath.row==2) {
//        NSMutableDictionary *dic=[NSMutableDictionary new];
//        dic[@"title"]=@"金牌供应商";
//        dic[@"detial"]=@"成功申请金牌供应商，您可享有：\n\n  1.获赠点花木求购信息定制费；\n\n  2.点花木金牌供应商苗店宣传；\n\n  3.所发布全部供应信息带有金牌供应商标识；\n\n  4.点花木店铺及供应信息免费分享至微信群、朋友圈、好友、QQ、QQ群；\n\n  5.查看金牌订单并享有联系采购商与报价；\n\n  6.共享工作站、合作苗企、金牌供应商、苗木帮大量稀缺、低价货源；";
//        cell.dic=dic;
//        
//  
//    }
    if (indexPath.row==0) {
        NSMutableDictionary *dic=[NSMutableDictionary new];
        dic[@"title"]=@"苗木经纪人";
        dic[@"detial"]=@"苗木经纪人五大优势\n\n1.诚信档案  证明你靠谱；\n\n2.能力标签  突出你长项；\n\n3.专属标识  彰显你身份；\n\n4.专业培训  提升你能力；\n\n5.资源共享  发挥你优势；";
        cell.dic=dic;
        
    }
    if (indexPath.row==1) {
        NSMutableDictionary *dic=[NSMutableDictionary new];
        dic[@"title"]=@"园林绿化工程公司";
        dic[@"detial"]=@"成功申请工程公司，您可享有：\n\n  1.全国各地大量优秀苗木供应商资源；\n\n\n  2.众多合作苗企、苗木交易工作站、苗木帮、金牌供应商，苗木数据资源；\n\n  3.工作站站长诚信保证金体系保驾护航，降低交易风险；\n\n  4.通过工程采购系统，快速采购到性价比最高的苗木；\n\n  5.让您的苗木采购：\n       省时、省力、省钱！\n       快捷、高效、优质！";
        cell.dic=dic;
        
    }
//    if (indexPath.row==4) {
//        NSMutableDictionary *dic=[NSMutableDictionary new];
//        dic[@"title"]=@"合作苗企";
//        dic[@"detial"]=@"成功申请合作苗企，您可享有：\n\n  1.点花木系统提供全国各地大量工程采购订单；\n\n  2.苗木帮，一对一专属客服，及时、精准对接苗企；\n\n  3.点花木APP内大量最新求购信息；\n\n  4.全国苗木交易工作站站长团队采购，苗企的苗木采购团；\n\n  5.众多苗木帮、金牌供应商采购订单；\n\n  6.站长内部专刊精准投放；\n\n  7.全国苗木行业经经人大量采购订单；";
//        cell.dic=dic;
//        
//    }
    [cell.shengjiBtn addTarget:self action:@selector(shengjiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.shengjiBtn.tag=indexPath.row;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)shengjiBtnAction:(UIButton *)sender
{
//    if (sender.tag==0) {
//        ZIKHelpfulHintsViewController *helpfulVC = [[ZIKHelpfulHintsViewController alloc] initWithNibName:@"ZIKHelpfulHintsViewController" bundle:nil];
//        helpfulVC.qubie = @"站长";
//        [self.navigationController pushViewController:helpfulVC animated:YES];
//    }
    if (sender.tag==1) {
        ShowActionV();
        [HTTPCLIENT projectCompanyStatusSuccess:^(id responseObject) {
            if([[responseObject objectForKey:@"success"] integerValue])
            {
                APPDELEGATE.userModel.projectCompanyStatus=[[[responseObject objectForKey:@"result"] objectForKey:@"projectCompanyStatus"] integerValue];
                if (APPDELEGATE.userModel.projectCompanyStatus==-1) {
                    [ToastView showTopToast:@"暂未审核，请耐心等待"];
                    return;
                }
                
                if (APPDELEGATE.userModel.projectCompanyStatus==0) {
                    [ToastView showTopToast:@"审核未通过"];
                    YLDGCGSZiZhiTiJiaoViewController *yldsda=[[YLDGCGSZiZhiTiJiaoViewController alloc]init];
                    
                    [self.navigationController pushViewController:yldsda animated:YES];
                    return;
                }
                YLDGCGSZiZhiTiJiaoViewController *yldVC=[[YLDGCGSZiZhiTiJiaoViewController alloc]init];
                [self.navigationController pushViewController:yldVC animated:YES];
            }
            else
            {
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            RemoveActionV();
        } failure:^(NSError *error) {
            RemoveActionV();
        }];


    }

    if (sender.tag==0) {
        ShowActionV();
        [HTTPCLIENT jjrshenheStatueSuccess:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary  *result=[responseObject objectForKey:@"result"];
                NSInteger xx=[[result objectForKey:@"status"] integerValue];
                if (xx==-1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        YLDJJRenShenQing1ViewController *vc=[YLDJJRenShenQing1ViewController new];
                        
                        vc.type=xx;
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                }
                
                if (xx==-2) {
   
                    dispatch_async(dispatch_get_main_queue(), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            YLDJJRenShenQing1ViewController *vc=[YLDJJRenShenQing1ViewController new];
                            
                            vc.type=xx;
                            [self.navigationController pushViewController:vc animated:YES];
                            
                            
                        });
                        
                    });
                }
                if (xx==0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        YLDJJRSHZViewController *vc=[YLDJJRSHZViewController new];
                        
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                }
                if (xx==1){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                    });
                }
                if (xx==2) {
                    dispatch_async(dispatch_get_main_queue(), ^{

                        YLDJJRNotPassViewController *vc=[[YLDJJRNotPassViewController alloc]init];
                        
                        NSString *msg=[result objectForKey:@"msg"];
                        vc.wareStr=msg;
                        [self.navigationController pushViewController:vc animated:YES];
                        //                        [ToastView showTopToast:@"未通过"];
                    });
                }
                if (xx==3) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        YLDJJRenShenQing1ViewController *vc=[YLDJJRenShenQing1ViewController new];
                   
                        vc.type=xx;
                        [self.navigationController pushViewController:vc animated:YES];
                        //                        [ToastView showTopToast:@"已过期"];
                    });
                }
                
            }
        } failure:^(NSError *error) {
            
        }];
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
