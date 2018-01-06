//
//  MiaoXiaoErXieyiViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/11/10.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "MiaoXiaoErXieyiViewController.h"
#import "UIDefines.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface MiaoXiaoErXieyiViewController ()

@end

@implementation MiaoXiaoErXieyiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, kWidth, 44)];
    [titleLab setText:@"苗木帮服务协议"];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLab];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 20, 30, 30)];
    [self.view addSubview:backBtn];
    [backBtn setEnlargeEdgeWithTop:0 right:30 bottom:20 left:10];
    [backBtn addTarget:self action:@selector(ssssss) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"backBtnBlack"] forState:UIControlStateNormal];
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    textView.editable=NO;
    UITapGestureRecognizer *tapss=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ssssss)];
    [textView addGestureRecognizer:tapss];
    NSMutableAttributedString *strs = [[NSMutableAttributedString alloc] initWithString:@"  苗木帮服务协议（以下简称“本协议”）是搜苗(上海)信息科技有限公司（手机APP点花木）与用户（以下简称“您”）所订立的合约。您通过网络页面点击确认或以其他方式（包括但不限于签字或签章确认等方式）接受本协议及附件，即表示您同意接受本协议的全部约定内容以及与本协议有关的已经发布或将来可能发布的各项规则、页面展示、操作流程、公告或通知（一下统称“规则”）。\n\n在接受本协议之前，请您仔细阅读本协议的全部内容(特别是以粗体下划线标注的内容)。如果您不同意本协议的任何内容，或者无法准确理解该条款的含义，请不要进行后续操作。一旦您使用本协议项下的服务（以下简称“本服务”），即表示您同意遵守规则。\n\n您同意，搜苗(上海)信息科技有限公司、点花木有权随时对本协议内容进行单方面的变更，并以公告的方式予以告知，无需另行单独通知您；若您在本协议内容公告变更后继续使用本服务的，表示您已充分阅读、理解并接受修改后的协议内容，也将遵守修改后的协议内容使用本服务；若您不同意修改后的协议内容，您应停止使用本服务。\n您同意，因履行本协议发生纠纷的，任何一方应向被告住所地人民法院提起诉讼。\n\n 特别提醒：在签署本协议后，一旦您使用本服务，即视为：\n 1、您在点花木上成为注册用户；\n 2、您同意缴纳诚信保证金；\n3、您认可点花木为您提供的求购信息、苗帮订单、苗木供应信息等服务；\n鉴于，搜苗(上海)信息科技有限公司是一家在中国境内注册并经合法登记的公司；您为从事苗木生产经营的企业或个人，属于在点花木平台上签订《苗木帮服务协议》的用户。中亿信息、点花木与您达成协议如下：\n\n一、协议成立\n您在中亿信息公司或者点花木点花木平台上通过类似点击确认按钮后，本协议即时成立并生效。本协议以数据电文的形式存储于中亿信息公司或者中亿信息公司合作方服务器中，您对此予以确认并同意。\n\n二、定义\n除本协议另有规定外，本协议中下列用语的定义如下：\n1、苗木帮：指中亿信息公司自主开发的手机APP“点花木”内的一项服务名称；\n2、服务协议：指您通过点花木APP点花木平台签订的《苗木帮服务协议》；\n3、您的诚信保证金：指您交付于搜苗(上海)信息科技有限公司点花木平台，由搜苗(上海)信息科技有限公司保管的诚信保证金。协议期限内，您如出现违约或与第三方客户交易时发生不诚信行为，导致第三方客户投诉的，经查属实后，搜苗(上海)信息科技有限公司有权扣除您全部诚信保证金，并有权将该保证金赔付给第三方客户，保证金不足以赔付第三方全部损失的，第三方客户有权向您继续索赔，与搜苗(上海)信息科技有限公司、点花木平台无涉；\n 4、平台诚信保证金：指点花木平台为您联合承诺的最高额度预备诚信保证金。协议期限内，您如出现违约或与第三方客户交易时发生不诚信行为，导致第三方客户投诉的，经查属实后，搜苗(上海)信息科技有限公司扣除您全部诚信保证金不足以赔付第三方全部损失的，平台预备诚信保证金作为赔付的一部分。如还不足以赔付第三方客户全部损失的，第三方客户有权向您继续索赔，与搜苗(上海)信息科技有限公司、点花木平台无涉；\n 5、交易佣金：是指您通过点花木平台联系的第三方客户，交易成功后实际成交金额3%缴纳；\n6、工作日：指除国家法定假日、公休日以外的中亿信息、点花木对外办理业务的任何一日。\n\n三、服务内容\n1、居间服务：搜苗(上海)信息科技有限公司、点花木平台为您提供居间服务并收取一定数额的居间服务费，包括诚信保证金与交易佣金；\n2、媒介服务：搜苗(上海)信息科技有限公司利用自有资源和平台优势，为您在点花木平台上寻找合适的苗木第三方采购商，以便您与第三方客户信息联络，促进双方苗木交易；\n 3、功能服务：苗木帮服务为您提供苗帮采购、苗帮订单报价、电话联系第三方采购商、发布苗木供应信息、苗木产品店铺等功能服务；\n4、点花木平台为您充值APP点花木求购信息定制费500元，您缴纳诚信保证金后系统自动充值到您在点花木账户内；\n 5、搜苗(上海)信息科技有限公司、点花木平台无法也没有义务保证您与第三方客户苗木交易过程货款收取、运输、价格等合作事宜顺利进行；\n6、合作期限：协议约定合作时间为36个月；\n7、平台联合诚信保证金最高为人民币2000元。\n\n 四、费用\n诚信保证金：\n您向点花木平台缴纳诚信保证金人民币¥ 2000，00元整，大写： 贰仟圆整；\n2、交易佣金比例：\n 按照您通过点花木平台联系的第三方客户，交易成功后实际成交金额3%缴纳。\n付款约定：\n您在点花木平台上成功申请苗木帮服务后，直接通过线上支付诚信保证金；\nB、您与第三方交易成功后的五日内，按照成交额及时、准确、主动、无隐瞒的向搜苗(上海)信息科技有限公司交纳交易佣金。\n\n五、保证金退还及推荐奖励\n诚信保证金退还约定：合作期满点花木平台与您不再继续合作，自到期之日起60日内，点花木未接到第三方客户对您的违约或不诚信行为投诉，由您提交申请，点花木平台在五个工作日内退还您的诚信保证金。自此搜苗(上海)信息科技有限公司、点花木平台不再承担您与任何第三方客户的交易纠纷；\n2、推荐奖励政策：有效合作期内，您为点花木平台推荐一位苗木行业从业人员成功申请点花木平台苗木帮后，奖励您点花木账户求购信息定制费500元，推荐越多奖励越多；\n3、您交纳的诚信保证金不计息，无保管费；\n4、如您要求开具发票的，您需要承担5%税金，届时由退还的诚信保证金中扣除。\n六、中亿信息、点花木的权利和义务\n1、按照本协议约定向您提供各项服务；\n2、在本协议履行过程中，根据实际情况要求您予以相应配合或协助；\n3、对涉及本协议项下服务内容的行为进行监督、检查，有权要求您提供相关资料、合法证明材料，有权要求您对有关问题作出说明，有权要求您改正在平台内发布的一切错误信息；\n4、点花木继续完善平台系统及功能，为您提供苗帮求购、苗帮订单供您联络；\n5、点花木平台有权利对您在点花木平台上发布的苗木供应信息的真实性进行监督核实，并有权利删除您不真实供应信息；为规范市场合作行为，您如有不诚信于第三方采购方行为或拒绝向中亿信息公司缴纳交易佣金的，点花木平台有权单方终止本协议及为您提供的一切服务，并扣除您全部诚信保证金。\n\n七、您的权利和义务\n1、接受并配合点花木平台的各项服务行为；\n2、接受点花木平台的监督，向点花木平台提供符合要求的相关资料、合法证明材料，并应根据点花木平台提出的要求改进其在平台发布的错误信息；\n3、未经中亿信息、点花木平台书面同意，不得转让本协议项下的任何权利义务；\n4、按照《苗木帮服务协议》及本协议约定向搜苗(上海)信息科技有限公司支付各类费用；\n5、您必须在成功加入苗木帮服务7个工作日内，认真、负责、真实完成苗木品种、规格、数量、图片等数据信息的收集，上传至点花木平台数据库。您基地的苗木品种、规格等因销售发生数量变化时，应积极、主动更新至点花木平台数据库；\n6、您完全自主与第三方采购客户接洽谈判，独立进行买卖交易。具体交易过程搜苗(上海)信息科技有限公司、点花木平台并不干涉，交易价款及运输方式等均与搜苗(上海)信息科技有限公司、点花木平台无关。第三方采购客户信誉及财力情况由您自行考察掌握。如第三方采购客户拖欠您的货款，您也应及时按照成交金额向搜苗(上海)信息科技有限公司缴纳交易佣金。\n\n八、陈述和保证\n1、搜苗(上海)信息科技有限公司是合法登记设立的、符合中国法律规定的企业法人；并认可本协议生效即对搜苗(上海)信息科技有限公司具有法律约束力；\n2、您承诺为善意、有权缔约的完全民事行为能力人，并认可本协议生效即对您具有法律约束力。\n\n九、声明与承诺\n1、您承诺不以任何方式攻击中亿信息公司、点花木系统，否则承担由此给中亿信息公司、点花木平台或任何第三方造成的损失；\n2、您承诺，本协议项下所涉及您的所有意思表示均不可变更、撤回、撤销，包括但不限于同意、承诺、授权、认可等形式。但本协议另有约定的除外。\n3、您承诺，对第三方苗木采购客户不欺诈、不隐瞒，诚信经营。否则给第三方客户造成的损失您独立承担责任；\n4、您知晓并同意，搜苗(上海)信息科技有限公司、点花木平台有权保留您网上发布的相关电子数据。\n\n十、风险提示\n您知晓并同意，您通过点花木平台寻找苗木采购客户所存在的一定风险以及求购信息的真实情况，该些风险需由您自行承担；如，第三方采购方与您进行苗木交易时的货款结算、质量要求等。\n\n十一、违约责任\n1、因任何一方的违约行为给另一方造成损失的，应由违约方承担赔偿责任；\n2、不可抗拒的非人为因素影响本协议的执行，此情形不视为违约，相关事宜双方可协商解决。\n\n十二、协议的变更和解除\n1、除本协议另有规定外，搜苗(上海)信息科技有限公司、点花木平台提前通知的情况下，可以单方面终止向您提供服务，并不承担任何赔偿责任；\n2、如遇国家法律、法规或政策变化，致使本协议的全部或部分条款不再符合国家法律、法规或政策的要求，搜苗(上海)信息科技有限公司、点花木平台可根据相关变动修改有关条款；\n3、本协议特殊约定，如您与第三方客户交易过程中发生不诚信或欺诈行为的，点花木平台可以单方面解除本协议；您发生不如实或拒绝向搜苗(上海)信息科技有限公司缴纳本协议约定的交易佣金行为，点花木平台可以单方面解除本协议。\n\n十三、其他\n1、本协议经您在点花木平台上以网络在线点击类似确认的方式签订，本协议一经签署，即视为您向点花木平台发出不可撤销的申请要约；\n2、您委托点花木平台保管所有与本协议有关的书面文件或电子信息；\n3、本协议中所使用的定义，除非另有规定，甲方享有解释权。\n本协议的成立、生效、履行和解释，均适用中华人民共和国法律；法律无明文规定的，应适用点花木平台制定的业务规则和通行的商业惯例。"];
    [strs addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(67,114)];
     [strs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0,[strs length])];
    [strs addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(192,108)];
//    [strs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(191,108)];
    [strs addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(300,195)];
    [strs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(300,195)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 5; //行距
    [strs addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,[strs length])];
    textView.attributedText=strs;
    [self.view addSubview:textView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)ssssss{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
