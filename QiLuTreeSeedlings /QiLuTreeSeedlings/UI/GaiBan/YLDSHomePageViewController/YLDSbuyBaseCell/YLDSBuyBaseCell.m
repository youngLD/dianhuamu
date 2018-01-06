//
//  YLDSBuyBaseCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/1/12.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSBuyBaseCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIDefines.h"
#import "HttpClient.h"
@implementation YLDSBuyBaseCell
+(YLDSBuyBaseCell *)yldSBuyBaseCell
{
    YLDSBuyBaseCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDSBuyBaseCell" owner:self options:nil] lastObject];
    [cell.contentView setBackgroundColor:BGColor];
    YLDSbuyBaseView *view1=[YLDSbuyBaseView yldSbuyBaseView];
    CGRect r=view1.frame;
    r.origin.x=5;
    r.origin.y=5;
    view1.frame=r;
    view1.tag=1;
    [cell.contentView addSubview:view1];

    cell.view1=view1;
    YLDSbuyBaseView *view2=[YLDSbuyBaseView yldSbuyBaseView];
    r=view2.frame;
    r.origin.x=kWidth/2+2.5;
    r.origin.y=5;
    view2.frame=r;
    [cell.contentView addSubview:view2];
    cell.view2=view2;
    view2.tag=1;

    return cell;
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, kWidth, 190);
        [self.contentView setBackgroundColor:BGColor];
        YLDSBuyADView *adView1=[YLDSBuyADView yldSBuyADView];
        self.adview1=adView1;
        adView1.hidden =YES;
        [self.contentView addSubview:adView1];
        YLDSbuyBaseView *view1=[YLDSbuyBaseView yldSbuyBaseView];
        [self.contentView addSubview:view1];
        self.view1=view1;
        
        
        YLDSBuyADView *adView2=[YLDSBuyADView yldSBuyADView];
        self.adview2=adView2;
        adView2.hidden =YES;
        [self.contentView addSubview:adView2];
        
        YLDSbuyBaseView *view2=[YLDSbuyBaseView yldSbuyBaseView];

        [self.contentView addSubview:view2];
        self.view2=view2;
        
        UIButton *btn1=[[UIButton alloc]init];
        [btn1 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn1];
        self.btn1=btn1;
        UIButton *btn2=[[UIButton alloc]init];
        [btn2 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn2];
        self.btn2=btn2;

    }
    return self;
}
-(void)tapAction:(UIButton *)sender
{
   
    if (self.delegate) {
        if (sender.tag==1) {
            if (self.model1) {
                self.model1.isRead=YES;
                [self.view1.titleLab setTextColor:readColor];
                [self.delegate actionWithbuyModel:self.model1];
            }
        }
        if (sender.tag==2) {
            if (self.model2) {
                self.model2.isRead=YES;
                [self.view2.titleLab setTextColor:readColor];
                [self.delegate actionWithbuyModel:self.model2];
            }
        }
        if (sender.tag==3) {
            if (self.admodel1) {
                
                [HTTPCLIENT adReadNumWithAdUid:self.admodel1.uid Success:^(id responseObject) {
                    
                } failure:^(NSError *error) {
                    
                }];
                NSString *ttt;
                if ([APPDELEGATE isNeedLogin]) {
                    ttt=@"0";
                }else{
                    ttt=@"1";
                }

                [HTTPADCLIENT adClickAcitionWithADuid:self.admodel1.uid WithMemberUid:APPDELEGATE.userModel.access_id WithBrowsePage:nil WithBrowseUserType:ttt withiosClientId:APPDELEGATE.IDFVSTR Success:^(id responseObject) {
                    //                        [ToastView showTopToast:responseObject obgect]
                } failure:^(NSError *error) {
                    
                }];
                [self.delegate actionWithadModel:self.admodel1];
            }
        }
        if (sender.tag==4) {
            if (self.admodel2) {
                [HTTPCLIENT adReadNumWithAdUid:self.admodel2.uid Success:^(id responseObject) {
                    
                } failure:^(NSError *error) {
                    
                }];
                NSString *ttt;
                if ([APPDELEGATE isNeedLogin]) {
                    ttt=@"0";
                }else{
                    ttt=@"1";
                }
         
                [HTTPADCLIENT adClickAcitionWithADuid:self.admodel2.uid WithMemberUid:APPDELEGATE.userModel.access_id WithBrowsePage:nil WithBrowseUserType:ttt withiosClientId:APPDELEGATE.IDFVSTR Success:^(id responseObject) {
                    //                        [ToastView showTopToast:responseObject obgect]
                } failure:^(NSError *error) {
                    
                }];
                [self.delegate actionWithadModel:self.admodel2];
            }
        }
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect r=self.view1.frame;
    r.origin.x=5;
    r.origin.y=5;
    r.size.width=self.frame.size.width/2-7.5;
    r.size.height=180;
    self.view1.frame=r;
    self.adview1.frame=r;
    self.btn1.frame=r;

    
    r=self.view2.frame;
    r.origin.x=kWidth/2+2.5;
    r.size.width=self.frame.size.width/2-7.5;
    r.origin.y=5;
    r.size.height=180;
    self.view2.frame=r;
    self.adview2.frame=r;
    self.btn2.frame=r;

    
}
-(void)setModel1:(HotBuyModel *)model1
{
    _model1=model1;
    self.view1.hidden=NO;
    self.adview1.hidden=YES;
    self.btn1.tag=1;
    self.view1.titleLab.text=model1.title;
    [self.view1.titleLab sizeToFit];
    self.view1.cityLab.text=model1.area;
    if (self.model1.isRead) {
        [self.view1.titleLab setTextColor:readColor];
    }else{
        [self.view1.titleLab setTextColor:MoreDarkTitleColor];
    }
    if ([model1.price isEqualToString:@"面议"]) {
        self.view1.moneLab.text=model1.price;
    }else{
        self.view1.moneLab.text=[NSString stringWithFormat:@"¥%@",model1.price];
    }
    self.view1.timeLab.text=model1.timeAger;
   
    self.view1.countLab.text=model1.countS;
 
    self.view1.nameLab.text=model1.name;
    self.view1.nameLW.constant=45/320.f*kWidth;
    self.view1.danweiLab.text=model1.unit;
    if (model1.goldsupplier == 0 || model1.goldsupplier == 10) {
        self.view1.shenfenVW.constant=0.1;
      self.view1.shenfenImagV.image = [UIImage imageNamed:@""];
    } else if (model1.goldsupplier == 1) {
        self.view1.shenfenVW.constant=20;
        self.view1.shenfenImagV.image = [UIImage imageNamed:@"列表-金牌供应商2"];
    } else if (model1.goldsupplier == 2) {
        self.view1.shenfenVW.constant=20;
        self.view1.shenfenImagV.image = [UIImage imageNamed:@"列表-银牌供应商2"];
    } else if (model1.goldsupplier == 3) {
        self.view1.shenfenVW.constant=20;
        self.view1.shenfenImagV.image = [UIImage imageNamed:@"列表-铜牌供应商2"];
    } else if (model1.goldsupplier == 4) {
        self.view1.shenfenVW.constant=20;
        self.view1.shenfenImagV.image = [UIImage imageNamed:@"列表-认证供应商"];
    } else if (model1.goldsupplier == 5) {
        self.view1.shenfenVW.constant=20;
        self.view1.shenfenImagV.image = [UIImage imageNamed:@"列表-总站"];
    } else if (model1.goldsupplier == 6) {
        self.view1.shenfenVW.constant=20;
        self.view1.shenfenImagV.image = [UIImage imageNamed:@"列表-分站"];
    } else if (model1.goldsupplier == 7) {
        self.view1.shenfenVW.constant=20;
        self.view1.shenfenImagV.image = [UIImage imageNamed:@"列表-工程公司"];
    }else if (model1.goldsupplier == 8) {
        self.view1.shenfenVW.constant=20;
        self.view1.shenfenImagV.image = [UIImage imageNamed:@"合作苗企43x43"];
    }else if(model1.goldsupplier == 9)
    {
        self.view1.shenfenVW.constant=20;
        self.view1.shenfenImagV.image = [UIImage imageNamed:@"列表-苗小二"];
    }else if (model1.goldsupplier == 11) {
        self.view1.shenfenVW.constant=20;
        self.view1.shenfenImagV.image = [UIImage imageNamed:@"jingjiren"];
    }
}
-(void)setModel2:(HotBuyModel *)model2{
    _model2=model2;
    self.view2.hidden=NO;
    self.adview2.hidden=YES;
    self.btn2.tag=2;
    self.view2.titleLab.text=model2.title;
    [self.view2.titleLab sizeToFit];
    self.view2.cityLab.text=model2.area;
    self.view2.moneLab.text=model2.price;
    if (self.model2.isRead) {
        [self.view2.titleLab setTextColor:readColor];
    }else{
        [self.view2.titleLab setTextColor:MoreDarkTitleColor];
    }
    if ([model2.price isEqualToString:@"面议"]) {
        self.view2.moneLab.text=model2.price;
    }else{
        self.view2.moneLab.text=[NSString stringWithFormat:@"¥%@",model2.price];
    }
    self.view2.timeLab.text=model2.timeAger;
    self.view2.countLab.text=model2.countS;
    
    self.view2.nameLab.text=model2.name;
    self.view2.nameLW.constant=45/320.f*kWidth;
    self.view2.danweiLab.text=model2.unit;
    if (model2.goldsupplier == 0 || model2.goldsupplier == 10) {
        self.view2.shenfenImagV.image = [UIImage imageNamed:@""];
    } else if (model2.goldsupplier == 1) {
        self.view2.shenfenImagV.image = [UIImage imageNamed:@"列表-金牌供应商2"];
    } else if (model2.goldsupplier == 2) {
        self.view2.shenfenImagV.image = [UIImage imageNamed:@"列表-银牌供应商2"];
    } else if (model2.goldsupplier == 3) {
        self.view2.shenfenImagV.image = [UIImage imageNamed:@"列表-铜牌供应商2"];
    } else if (model2.goldsupplier == 4) {
        self.view2.shenfenImagV.image = [UIImage imageNamed:@"列表-认证供应商"];
    } else if (model2.goldsupplier == 5) {
        self.view2.shenfenImagV.image = [UIImage imageNamed:@"列表-总站"];
    } else if (model2.goldsupplier == 6) {
        self.view2.shenfenImagV.image = [UIImage imageNamed:@"列表-分站"];
    } else if (model2.goldsupplier == 7) {
        self.view2.shenfenImagV.image = [UIImage imageNamed:@"列表-工程公司"];
    }else if (model2.goldsupplier == 8) {
        self.view2.shenfenImagV.image = [UIImage imageNamed:@"合作苗企43x43"];
    }else if(model2.goldsupplier == 9)
    {
        self.view2.shenfenImagV.image = [UIImage imageNamed:@"列表-苗小二"];
    }else if (model2.goldsupplier == 11) {
        self.view2.shenfenImagV.image = [UIImage imageNamed:@"jingjiren"];
        
    }

}
-(void)setAdmodel1:(YLDSadvertisementModel *)admodel1{
    _admodel1 = admodel1;
    
    self.adview1.hidden=NO;
    self.view1.hidden=YES;
    self.btn1.tag=3;
    [self.adview1.ggImageV setImageWithURL:[NSURL URLWithString:admodel1.attachment] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    self.adview1.typeLab.text=@"推广";
}
-(void)setAdmodel2:(YLDSadvertisementModel *)admodel2
{
    _admodel2 = admodel2;
    self.adview2.hidden=NO;
    self.view2.hidden=YES;
    self.btn2.tag=4;
    [self.adview2.ggImageV setImageWithURL:[NSURL URLWithString:admodel2.attachment] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    self.adview2.typeLab.text=@"推广";
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
