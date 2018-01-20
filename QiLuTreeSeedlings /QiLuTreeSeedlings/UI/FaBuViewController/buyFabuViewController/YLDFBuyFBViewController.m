//
//  YLDFBuyFBViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/25.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFBuyFBViewController.h"
#import "YLDFAddressManagementViewController.h"
#import "YLDFAddressListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YLDFYYSURUView.h"
@interface YLDFBuyFBViewController ()<YLDFAddressListViewControllerDelegate,YLDFAddressManagementDelegate,AVAudioPlayerDelegate>
@property (nonatomic,copy)NSString *addressId;
@property (nonatomic,strong)UIButton *baojiaTypeBtn;
@property (nonatomic,strong)UIButton *roundBtn;
@property (nonatomic,strong)AVAudioSession *session;
@property (nonatomic,strong)AVAudioRecorder *recorder;
@property (nonatomic,strong)AVAudioPlayer *player;
@property (nonatomic,strong) NSURL *recordFileUrl;
@property (nonatomic,copy) NSString *filePath;
@property (nonatomic,copy) NSString *recordOssUrl;
@end

@implementation YLDFBuyFBViewController
@synthesize filePath;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    [self creatYYBtnView];
    if (APPDELEGATE.addressModel.addressId) {
        self.addressId=APPDELEGATE.addressModel.addressId;
        self.addBGV.hidden=YES;
        self.addressPersonLab.text=APPDELEGATE.addressModel.linkman;
        self.addressPhoneLab.text=APPDELEGATE.addressModel.phone;
        self.addressLab.text=APPDELEGATE.addressModel.area;
    }
    self.vcTitle=@"求购发布";
    self.guigeTextFiled.placeholder=@"请输入苗木规格说明";
    self.addLineV.image =   [ZIKFunction imageWithSize:self.addLineV.frame.size borderColor:kLineColor borderWidth:1];
    self.addAddressBGImageV.image=[ZIKFunction  imageWithSize:self.addAddressBGImageV.frame.size borderColor:kLineColor borderWidth:1];
    [self.shangchejiaBtn addTarget:self action:@selector(baojiayaoqiuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.shangchejiaBtn.selected=YES;
    self.baojiaTypeBtn=self.shangchejiaBtn;
    [self.daohuojiaBtn addTarget:self action:@selector(baojiayaoqiuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.maimiaojiaBtn addTarget:self action:@selector(baojiayaoqiuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fabuBtn addTarget:self action:@selector(fabuAction) forControlEvents:UIControlEventTouchUpInside];
    if (self.buyIdstr.length>0) {
        __weak typeof(self) weakSelf=self;
        [HTTPCLIENT myBuyDetialWithbuyIds:self.buyIdstr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *dic=[responseObject objectForKey:@"data"] ;
                self.model=[YLDFBuyModel YLDFBuyModelWithDic:dic];
                self.nameTextField.text=self.model.productName;
                self.guigeTextFiled.text=self.model.demand;
                if (self.model.quantity>0) {
                    self.numTextField.text=[NSString stringWithFormat:@"%@",self.model.quantity];
                }
                self.baojiaTypeBtn.selected=NO;
                if ([self.model.quoteTypeId isEqualToString:@"car_price"]) {
                    self.baojiaTypeBtn=self.shangchejiaBtn;
                }else if ([self.model.quoteTypeId isEqualToString:@"arrival_price"])
                {
                    self.baojiaTypeBtn=self.daohuojiaBtn;
                }else if ([self.model.quoteTypeId isEqualToString:@"buy_price"])
                {
                    self.baojiaTypeBtn=self.maimiaojiaBtn;
                }
                self.baojiaTypeBtn.selected=YES;
                self.addressId=self.model.addressId;
               YLDFAddressModel *addressModel = [ZIKFunction GetAddressModelWithAddressId:self.addressId];
                if (addressModel.addressId.length>0) {
                    self.addressLab.text=addressModel.area;
                    self.addressPersonLab.text=addressModel.linkman;
                    self.addressPhoneLab.text=addressModel.phone;
                }
                for (NSDictionary *dic in _model.attacs) {
                      self.recordOssUrl=dic[@"path"];
                        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                        filePath = [path stringByAppendingString:@"/RRecord.wav"];
                        self.GGH.constant=115+55;
                        self.YYBGView.hidden=NO;
                        //2.获取文件路径
                        _recordFileUrl = [NSURL fileURLWithPath:filePath];
                        [HTTPCLIENT downNetFileWithdownUrl:self.recordOssUrl savePath:filePath Success:^(id responseObject) {
                            
                        } failure:^(NSError *error) {
                            
                        }];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
                    
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                      CGFloat yytime = [weakSelf audioSoundDuration:weakSelf.recordFileUrl];
                        weakSelf.YYtimeLab.text=[NSString stringWithFormat:@"%.0lf'",yytime];
                    });
                    

                }

            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)baojiayaoqiuBtnAction:(UIButton *)sender
{
    if(sender.selected)
    {
        return;
    }
    sender.selected=YES;
    self.baojiaTypeBtn.selected=NO;
    self.baojiaTypeBtn=sender;
}
-(void)fabuAction
{
    if (self.nameTextField.text.length<=0) {
        [ToastView showTopToast:@"请输入苗木名称"];
        return;
    }
    if (self.guigeTextFiled.text.length<=0) {
        [ToastView showTopToast:@"请输入苗木规格"];
        return;
    }
    if (self.numTextField.text.length<=0) {
        [ToastView showTopToast:@"请输入求购数量"];
        return;
    }
    if (self.addressId.length<=0) {
        [ToastView showTopToast:@"请选择地址"];
        return;
    }
    NSMutableDictionary *party=[NSMutableDictionary dictionary];
    [party setObject:self.nameTextField.text forKey:@"productName"];
    [party setObject:self.guigeTextFiled.text forKey:@"demand"];
    if (self.baojiaTypeBtn) {
        NSString *baojiatype=nil;
        if (self.baojiaTypeBtn.tag==1) {
            baojiatype=@"car_price";
        }
        if (self.baojiaTypeBtn.tag==2) {
            baojiatype=@"arrival_price";
        }
        if (self.baojiaTypeBtn.tag==3) {
            baojiatype=@"buy_price";
        }
        party[@"quoteTypeId"]=baojiatype;
    }
    if (self.numTextField.text.length>0) {
        [party setObject:self.numTextField.text forKey:@"quantity"];
    }
    [party setObject:self.addressId forKey:@"addressId"];
    if (self.recordOssUrl.length>0) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"attaType"]=@"audio";
        dic[@"path"]=self.recordOssUrl;
        NSArray *attas=@[dic];
        [party setObject:attas forKey:@"attas"];
    }
    NSString *partyStr=[ZIKFunction convertToJsonData:party];
    ShowActionV();
    if(!self.buyIdstr)
    {
        [HTTPCLIENT buyNewPushWithBody:partyStr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"发布成功"];
                [APPDELEGATE getdefaultAddress];
                [self.navigationController popViewControllerAnimated:NO];
                if (self.delegate) {
                    [self.delegate fabuSuccessWithbuyId:[responseObject objectForKey:@"data"]];
                }
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [HTTPCLIENT buyNewUpDataWithBody:partyStr WithBuyId:self.buyIdstr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"修改成功"];
                [APPDELEGATE getdefaultAddress];
            [self.navigationController popViewControllerAnimated:NO];
            if (self.delegate) {
                [self.delegate fabuSuccessWithbuyId:[responseObject objectForKey:@"data"]];
            }
            }
        } failure:^(NSError *error) {
            
        }];
    }
   
}
-(void)deleteWithYLDFAddressModel:(YLDFAddressModel *)model{
    if ([self.addressId isEqualToString:model.addressId]) {
        self.addressPersonLab.text=@"请选择地址";
        self.addressPhoneLab.text=@"请选择地址";
        self.addressLab.text=@"请选择地址";
        self.addressId=nil;
    }
}
- (IBAction)YYdeleteBtnAction:(UIButton *)sender {
    self.GGH.constant=115;
    self.YYBGView.hidden=YES;
    self.recordOssUrl=nil;
    self.filePath=nil;
    self.recordFileUrl=nil;
    [self.YYPlayImageV stopAnimating];
}
- (IBAction)addAdressBtnAction:(id)sender {
    YLDFAddressManagementViewController *vc=[YLDFAddressManagementViewController new];
    vc.delegate=self;
    vc.isDefault=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)addSuccessWithaddressDic:(NSDictionary *)addressdic
{
    self.addBGV.hidden=YES;
    self.addressId=addressdic[@"addressId"];
    
    self.addressPersonLab.text=addressdic[@"linkman"];
    self.addressPhoneLab.text=addressdic[@"phone"];
    self.addressLab.text=addressdic[@"area"];
}
-(IBAction)selectAddressBtnAction
{
    YLDFAddressListViewController *vc=[YLDFAddressListViewController new];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)selectWithYLDFAddressModel:(YLDFAddressModel *)model{
    self.addressPersonLab.text=model.linkman;
    self.addressId=model.addressId;
    self.addressPhoneLab.text=model.phone;
    self.addressLab.text=model.area;
}
-(void)longGesture:(UILongPressGestureRecognizer *)gesture

{
    
    int sendState = 0;
    
    CGPoint  point = [gesture locationInView:_roundBtn];
    
    if (point.y<0)
        
    {
        
        NSLog(@"松开手指，取消发送");
        
        sendState = 1;
        
    }
    
    else
        
    {
        
        //重新进入长按录音范围内
        
        sendState = 0;
        
    }
    
    //手势状态
    
    switch (gesture.state) {
            
        case UIGestureRecognizerStateBegan:
            
        {
            
            //NSLog(@"开始");
            
            NSLog(@"这里开始录音");
            [self startRecord];
        }
            
            break;
            
        case UIGestureRecognizerStateEnded:
            
        {
            
            //NSLog(@"长按手势结束");
            
            if (sendState == 0)
                
            {
                
                NSLog(@"结束录音并发送录音");
                [self stopRecord];
                [self upDataWithFieldPath:nil];
                self.GGH.constant=170;
                self.YYBGView.hidden=NO;
                
            }
            
            else
                
            {
                
                //向上滑动取消发送
                [ToastView showTopToast:@"您已取消发送"];
                [self stopRecord];
                self.filePath=nil;
                self.recordFileUrl=nil;
                NSLog(@"取消发送删除录音");
                
            }
            
        }
            
            break;
            
        case UIGestureRecognizerStateFailed:
            
            //NSLog(@"长按手势失败");
            
            break;
            
        default:
            
            break;
            
    }
    
}
-(void)startRecord
{
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if (session == nil) {
        
        NSLog(@"Error creating session: %@",[sessionError description]);
        
    }else{
        [session setActive:YES error:nil];
        
    }
    
    self.session = session;
    
    
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
     filePath = [path stringByAppendingString:@"/RRecord.wav"];
    
    //2.获取文件路径
    _recordFileUrl = [NSURL fileURLWithPath:filePath];
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 11025.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityMedium],AVEncoderAudioQualityKey,
                                   nil];
    
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:_recordFileUrl settings:recordSetting error:nil];
    
    if (_recorder) {
        
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self
            [self stopRecord];
        });
        
        
        
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
        
    }
    

}
-(void)stopRecord
{
//    NSLog(@"停止录音");
    
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){

//        _noticeLabel.text = [NSString stringWithFormat:@"录了 %ld 秒,文件大小为 %.2fKb",COUNTDOWN - (long)countDown,[[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1024.0];

    }else{

//        _noticeLabel.text = @"最多录60秒";
//        YYtimeLab.text

    }
   CGFloat yytime = [self audioSoundDuration:_recordFileUrl];
    self.YYtimeLab.text=[NSString stringWithFormat:@"%.0lf'",yytime];
}
- (IBAction)playBtnAction:(UIButton *)sender {
    [self YYPlayAction];
}
-(void)YYPlayAction
{
    NSLog(@"播放录音");
    [self.recorder stop];

    if ([self.player isPlaying])return;
    
    [self.YYPlayImageV startAnimating];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:nil];
    self.player.delegate=self;

//    NSLog(@"%li",self.player.data.length/1024);
    
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player play];
//    NSURL * url  = [NSURL URLWithString:@""];
//    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
//    AVPlayer * player = [[AVPlayer alloc]initWithPlayerItem:songItem];
//    [player play];


}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.YYPlayImageV stopAnimating];
//         [timer invalidate]; //NSTimer暂停   invalidate  使...无效;
}
- (void)upDataWithFieldPath:(NSString *)fieldPath
{
    //  [ToastView showTopToast:@"正在上传图片"];
    
    //    ShowActionV();
    //先把图片转成NSData
    NSData *feildData =[NSData dataWithContentsOfURL:self.recordFileUrl];
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = @"miaoxintong";
    
    NSString * nameStr =  [ZIKFunction creatFilePathWithHeardStr:[NSString stringWithFormat:@"buys/record/%@",APPDELEGATE.userModel.access_token] WithTypeStr:@"buy"];
    
    NSString *urlstr;

        put.objectKey = [NSString stringWithFormat:@"%@.wav",nameStr];


    urlstr=[NSString stringWithFormat:@"http://img.miaoxintong.cn/%@",put.objectKey];


    put.uploadingData = feildData; // 直接上传NSData
    // 可选字段，可不设置
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
    };
    
    OSSTask * putTask = [APPDELEGATE.client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.recordOssUrl=urlstr;
            });
            
        }
        return nil;
    }];
    
}
-(void)creatYYBtnView
{
    
    NSMutableArray
    * animateArray = [[NSMutableArray alloc]initWithCapacity:3];
    [animateArray addObject:[UIImage imageNamed:@"fabuYuYin3"]];
    [animateArray addObject:[UIImage imageNamed:@"fabuYuYin2"]];
    [animateArray addObject:[UIImage imageNamed:@"fabuYuYin1"]];
    
    self.YYPlayImageV.animationImages=animateArray;
    self.YYPlayImageV.animationRepeatCount=0;
    self.YYPlayImageV.animationDuration=0.8;
    UIView *GGInputAccessoryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 80)];
    self.guigeTextFiled.inputAccessoryView =GGInputAccessoryView;
    
    UIView *GGWCV=[[UIView alloc]initWithFrame:CGRectMake(0, 40, kWidth, 40)];
    [GGWCV setBackgroundColor:[UIColor whiteColor]];
    UIButton *wanchengBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 0, 70, 40)];
    [wanchengBtn setTitle:@"完成" forState: UIControlStateNormal];
    [wanchengBtn setTitleColor:kRGB(0,121,253,1) forState:UIControlStateNormal];
    [wanchengBtn addTarget:self action:@selector(textViewDownAction) forControlEvents:UIControlEventTouchUpInside];
    [GGWCV addSubview:wanchengBtn];
    [GGInputAccessoryView addSubview:GGWCV];
    UILongPressGestureRecognizer * longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGesture:)];
    YLDFYYSURUView *view=[YLDFYYSURUView yldFYYSURUView];
    CGRect frame=view.frame;
    frame.size.width=kWidth;
    view.frame=frame;
    self.roundBtn=view.YYSRBtn;
    [GGInputAccessoryView addSubview:view];
    [view.YYSRBtn addGestureRecognizer:longGesture];
    self.YYPlayBtn.layer.masksToBounds=YES;
    self.YYPlayBtn.layer.cornerRadius=20;
    self.YYBGView.hidden=YES;
}
-(void)textViewDownAction
{
    [self.guigeTextFiled resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(float)audioSoundDuration:(NSURL *)fileUrl{
    NSDictionary *options = @{AVURLAssetPreferPreciseDurationAndTimingKey: @YES};
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:fileUrl options:options];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
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
