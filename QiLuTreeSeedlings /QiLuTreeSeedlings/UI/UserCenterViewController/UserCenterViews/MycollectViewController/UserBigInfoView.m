//
//  UserBigInfoView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/1.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "UserBigInfoView.h"
#import "UIDefines.h"
#import "UIImageView+AFNetworking.h"
@interface UserBigInfoView()
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIImageView *userImageV;
@property (nonatomic,strong) UILabel *phoneLab;
@property (nonatomic,strong) UILabel *gongyiDLab;
@end

@implementation UserBigInfoView
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView *backImageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, frame.size.height)];
        [backImageV setImage:[UIImage imageNamed:@"YLDSUserCBG"]];
        [self addSubview:backImageV];
        UIButton *setingBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-40, 20, 30, 30)];
        [setingBtn setImage:[UIImage imageNamed:@"settingBtnImage"] forState:UIControlStateNormal];
        [self addSubview:setingBtn];
        self.setingBtn=setingBtn;
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-130, 20, 260, 30)];
        [titleLab setTextColor:[UIColor whiteColor]];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setText:@"我的"];
        //[titleLab setText:@"未登录"];
        [self addSubview:titleLab];
        [titleLab setFont:[UIFont systemFontOfSize:19]];
        
        UIImageView *jiantouImageV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-40, frame.size.height/2+5, 20, 20)];
        jiantouImageV.image=[UIImage imageNamed:@"rightArr"];
        [self addSubview:jiantouImageV];
        self.userImageV=[[UIImageView alloc]initWithFrame:CGRectMake(35, frame.size.height/2-25, 90, 90)];
        self.userImageV.layer.masksToBounds=YES;
        self.userImageV.layer.cornerRadius=self.userImageV.frame.size.width/2;
        self.userImageV.layer.borderWidth=1.0;
        
        self.userImageV.layer.borderColor=[[UIColor whiteColor] CGColor];
        [self.userImageV setImage:[UIImage imageNamed:@"UserImageV"]];
        [self addSubview:self.userImageV];
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 100, kWidth,frame.size.height-100)];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(userImageBtnAction) forControlEvents:UIControlEventTouchUpInside];
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userImageV.frame)+10, frame.size.height/2-1, 120, 16)];
        [nameLab setTextAlignment:NSTextAlignmentCenter];
        self.titleLab = nameLab;
        [nameLab setFont:[UIFont systemFontOfSize:16]];
        [nameLab setTextColor:[UIColor whiteColor]];
//        [nameLab setText:@"登录"];
        [self addSubview:nameLab];
        UILabel *phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userImageV.frame)+10, frame.size.height/2+21, 120, 15)];
        [phoneLab setTextAlignment:NSTextAlignmentCenter];
        self.phoneLab = phoneLab;
        [phoneLab setFont:[UIFont systemFontOfSize:15]];
        [phoneLab setTextColor:[UIColor whiteColor]];
        [phoneLab setText:@"登录"];
        [self addSubview:phoneLab];
        
        UILabel *gongyishangLab=[[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.userImageV.frame)+4, 150, 20)];
        self.gongyiDLab=gongyishangLab;
        [gongyishangLab setTextColor:[UIColor whiteColor]];
        [gongyishangLab setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:gongyishangLab];
        [gongyishangLab setFont:[UIFont systemFontOfSize:14]];
    }
    return self;
}
-(void)userImageBtnAction
{
    if ([self.userDelegate respondsToSelector:@selector(clickedHeadImage)]) {
        [self.userDelegate clickedHeadImage];
    }
}
-(void)setModel:(UserInfoModel *)model
{
    _model=model;
    if (model.name.length>0) {
        self.titleLab.text=model.name;
        [self.userImageV setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"UserImageV"]];
        self.phoneLab.text=model.phone;
        if (model.goldsupplierStatus==5) {
            self.gongyiDLab.text=@"工作站总站";
        }else if(model.goldsupplierStatus==6){
            self.gongyiDLab.text=@"工作站分站";
        }else{
          self.gongyiDLab.text=model.goldsupplier;
        }

    }else
    {
        self.titleLab.text=@"";
        [self.userImageV setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"UserImageV"]];
        self.phoneLab.text=@"未登录";
        self.gongyiDLab.text=@"";

    }
   
}
//self.titleLab.text=model.name;
//[self.userImageV setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"UserImageV"]];
//self.phoneLab.text=model.phone;
//self.gongyiDLab.text=model.goldsupplier;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
