//
//  ZIKMyHonorCollectionViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMyHonorCollectionViewCell.h"
#import "ZIKStationHonorListModel.h"
#import "UIImageView+AFNetworking.h"
@interface ZIKMyHonorCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@end

@implementation ZIKMyHonorCollectionViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backView.alpha = 1;
    self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.isEditState = NO;
    self.levelLabel.layer.masksToBounds = YES;
    self.levelLabel.layer.cornerRadius = 6.0f;
}

- (void)loadData:(id <ZIKCertificateAdapterProtocol>)data {
    self.name             = [data name];
    self.time             = [data time];
    self.imageString      = [data imageString];
    self.issuingAuthority = [data issuingAuthority];
    self.level            = [data level];
    self.uid              = [data uid];
    self.type             = [data type];
}

#pragma mark - 重写setter,getter方法
@synthesize name             = _name;
@synthesize time             = _time;
@synthesize imageString      = _imageString;
@synthesize issuingAuthority = _issuingAuthority;
@synthesize level            = _level;
@synthesize uid              = _uid;
@synthesize type            = _type;
-(void)setName:(NSString *)name {
    _name = name;
    _honorTitleLabel.text = name;
}

-(NSString *)name {
    return _name;
}

-(void)setTime:(NSString *)time {
    _time = time;
    _honorTimeLabel.text = time;
}

-(NSString *)time {
    return _time;
}

-(void)setImageString:(NSString *)imageString {
    _imageString = imageString;
    NSURL *honorUrl = [NSURL URLWithString:imageString];
    [_honorImageView setImageWithURL:honorUrl placeholderImage:[UIImage imageNamed:@"MoRentu"]];
}

-(NSString *)imageString {
    return _imageString;
}

-(void)setIssuingAuthority:(NSString *)issuingAuthority {
    _issuingAuthority = issuingAuthority;
}

-(NSString *)issuingAuthority {
    return _issuingAuthority;
}

-(void)setLevel:(NSString *)level {
    _level = level;
    if (level.length>0) {
        _levelLabel.hidden = NO;
        _levelLabel.text = [NSString stringWithFormat:@"%@",level];
    } else {
        _levelLabel.hidden = YES;
    }
}
-(void)setType:(NSString *)type {
    _type = type;
    self.honorTypeLab.text = type;
}

- (NSString *)type {
    return _type;
}
-(NSString *)level {
    return _level;
}

-(void)setUid:(NSString *)uid {
    _uid = uid;
}

- (NSString *)uid {
    return _uid;
}

//-(void)setZZmodel:(GCZZModel *)ZZmodel
//{
//    _ZZmodel = ZZmodel;
//    NSURL *honorUrl = [NSURL URLWithString:ZZmodel.attachment];
//    [self.honorImageView setImageWithURL:honorUrl placeholderImage:[UIImage imageNamed:@"MoRentu"]];
//    self.honorTimeLabel.text = ZZmodel.acqueTime;
//    self.honorTitleLabel.text = ZZmodel.companyQualification;
//}

- (void)setIsEditState:(BOOL)isEditState {
    _isEditState = isEditState;
    if (_isEditState) {
        self.backView.hidden = NO;
    } else {
        self.backView.hidden = YES;
    }
}

-(void)setEditButtonBlock:(EditButtonBlock)editButtonBlock {
    _editButtonBlock = editButtonBlock;
    [self.editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)editButtonClick {
    _editButtonBlock(self.indexPath);
}

-(void)setDeleteButtonBlock:(DeleteButtonBlock)deleteButtonBlock {
    _deleteButtonBlock = deleteButtonBlock;
    [self.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteButtonClick {
    _deleteButtonBlock(self.indexPath);
}
@end
