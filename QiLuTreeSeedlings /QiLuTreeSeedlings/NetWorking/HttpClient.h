//
//  HttpClient.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/25.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "HttpDefines.h"
#import "ZIKFunction.h"
@interface HttpClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
+ (instancetype)sharedADClient;
#define HTTPCLIENT [HttpClient sharedClient]
#define HTTPADCLIENT [HttpClient sharedADClient]
#pragma mark -网络异常判断
+(void)HTTPERRORMESSAGE:(NSError *)errorz;


#pragma mark -版本检测
-(void)getVersionSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

#pragma mark -修改个人信息
-(void)changeUserInfoWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
                  WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
                      withName:(NSString *)name
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

#pragma mark-修改密码
-(void)changeUserPwdWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
              WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
               WithOldPassWord:(NSString *)oldPwd
               WithNewPassWord:(NSString *)newPwd
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

#pragma mark-取消苗圃
-(void)cancelMiaoPuWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
              WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
               WithIds:(NSString *)ids
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark-上传个人头像
-(void)upDataUserImageWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
              WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
                       WithUserIamge:(UIImage *)image
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark-上传图片
-(void)upDataIamge:(UIImage *)image
           Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
#pragma mark-站长信息列表
-(void)getWrokStationListWithToken:(NSString *)token
                      WithAccessID:(NSString *)accessID
                      WithClientID:(NSString *)clientID
                  WithClientSecret:(NSString *)clientSecret
                      WithDeviceID:(NSString *)deviceID
                WithWorkstationUId:(NSString *)workstationUId
                      WithAreaCode:(NSString *)areaCode
                          WithPage:(NSString *)page
                      WithPageSize:(NSString *)pageSize
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;

#pragma mark-求购信息收藏列表
-(void)collectBuyListWithToken:(NSString *)token
                   WithAccessID:(NSString *)accessID
                   WithClientID:(NSString *)clientID
               WithClientSecret:(NSString *)clientSecret
                   WithDeviceID:(NSString *)deviceID
                       WithPage:(NSString *)page
                   WithPageSize:(NSString *)pageSize
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
#pragma mark-供应信息收藏列表
-(void)collectSellListWithPage:(NSString *)page
                  WithPageSize:(NSString *)pageSize
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark-供应信息列表
-(void)SellListWithWithPageSize:(NSString *)pageSize
                    WithPage:(NSString *)page
               Withgoldsupplier:(NSString *)goldsupplier
                 WithSerachTime:(NSString *)searchTime
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark-求购信息列表
-(void)BuyListWithWithPageSize:(NSString *)pageSize
                    WithStatus:(NSString *)status
               WithStartNumber:(NSString *)startNumber
                withSearchTime:(NSString *)searchTime
              WithSearchStatus:(NSString *)searchStatus
                       Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark-求购检索
-(void)buySearchWithPage:(NSString *)page
            WithPageSize:(NSString *)pageSize
        Withgoldsupplier:(NSString *)goldsupplier
          WithproductUid:(NSString *)productUid
         WithproductName:(NSString *)productName
            WithProvince:(NSString *)province
                WithCity:(NSString *)city
              WithCounty:(NSString *)county
          WithsearchTime:(NSString *)searchTime
        WithSearchStatus:(NSString *)searchStatus
               WithAry:(NSArray *)ary
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
#pragma mark-求购详情
-(void)buyDetailWithUid:(NSString *)uid
           WithAccessID:(NSString *)access_id
               WithType:(NSString *)type
    WithmemberCustomUid:(NSString *)memberCustomUid
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark-我的求购编辑
-(void)myBuyEditingWithUid:(NSString *)uid
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
#pragma mark-供应详情
-(void)sellDetailWithUid:(NSString *)uid
            WithAccessID:(NSString *)access_id
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
#pragma mark-热门搜索
-(void)hotkeywordWithkeywordCount:(NSString *)keyWordCount
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

#pragma mark-供应检索
-(void)sellSearchWithPage:(NSString*)page
             WithPageSize:(NSString *)pageSize
         Withgoldsupplier:(NSString *)goldsupplier
           WithProductUid:(NSString *)productUid
          WithProductName:(NSString *)productName
             WithProvince:(NSString *)province
                 WithCity:(NSString *)city
               WithCounty:(NSString *)county
           WithSearchTime:(NSString *)searchTime
                  WithAry:(NSArray *)ary
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
#pragma mark-根据苗木名称获取规格属性
-(void)getMmAttributeWith:(NSString *)name
                 WithType:(NSString *)type
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;


#pragma mark-检查用户名是否已存在
-(void)checkUserNameByloginName:(NSString *)loginName
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
#pragma mark-个人信息
-(void)getUserInfoByToken:(NSString *)token
               byAccessId:(NSString *)accessId
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;




#pragma mark -保存供应信息收藏
-(void)collectSupplyWithSupplyNuresyid:(NSString *)nuresyid
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
#pragma mark -保存求购信息收藏
-(void)collectBuyWithSupplyID:(NSString *)supply_id
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

#pragma mark -我的求购列表
-(void)myBuyInfoListWtihPage:(NSString *)page
                   WithState:(NSString *)state
              WithsearchTime:(NSString *)searchTime
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
#pragma mark-个人积分
-(void)getMyIntegralListWithPageNumber:(NSString *)pageNumber
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
#pragma mark -我的求购信息保存
-(void)fabuBuyMessageWithUid:(NSString *)uid
                   Withtitle:(NSString *)title
                    WithName:(NSString *)name
              WithProductUid:(NSString *)productUid
                   WithCount:(NSString *)count
                   WithPrice:(NSString *)price
           WithEffectiveTime:(NSString *)effectiveTime
                  WithRemark:(NSString *)remark
                WithusedArea:(NSString *)usedArea
                     WithAry:(NSArray  *)ary
                    WithRuid:(NSString *)ruid
                withurlSring:(NSString *)urlSring
           withcompressSring:(NSString *)compressSring
         withimageDetailUrls:(NSString *)imageDetailUrls
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
#pragma mark -获取企业信息
-(void)getCompanyInfoSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
#pragma mark -保存企业信息
-(void)saveCompanyInfoWithUid:(NSString *)uid
              WithCompanyName:(NSString *)name
           WithCompanyAddress:(NSString *)companyAddress
                         WithcompanyAreaProvince:(NSString *)companyAreaProvince
          WithcompanyAreaCity:(NSString *)companyAreaCity
        WithcompanyAreaCounty:(NSString *)companyAreaCounty
          WithcompanyAreaTown:(NSString *)companyAreaTown
              WithlegalPerson:(NSString *)legalPerson
                    Withphone:(NSString *)phone
                  Withzipcode:(NSString *)zipcode
                    Withbrief:(NSString *)brief
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

#pragma mark -苗圃列表信息
-(void)getNurseryListWithPage:(NSString *)page
                 WithPageSize:(NSString *)pageSize
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
#pragma mark -苗圃详情
-(void)nurseryDetialWithUid:(NSString *)uid
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
#pragma mark -添加/修改苗圃信息
-(void)saveNuresryWithUid:(NSString *)uid
          WithNurseryName:(NSString *)nurseryName
  WithnurseryAreaProvince:(NSString *)nurseryAreaProvince
      WithnurseryAreaCity:(NSString *)nurseryAreaCity
    WithnurseryAreaCounty:(NSString *)nurseryAreaCounty
      WithnurseryAreaTown:(NSString *)nurseryAreaTown
       WithnurseryAddress:(NSString *)nurseryAddress
        WithchargelPerson:(NSString *)chargelPerson
                WithPhone:(NSString *)phone
                Withbrief:(NSString *)brief
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;


#pragma mark ---------- 供求发布限制 -----------
/**
 *  发布求购和供应信息时，需要判断是否可发布
 *
 *  @param token        AccessToken
 *  @param accessID     用户id
 *  @param clientID     应用的API Key
 *  @param clientSecret 应用的API Secret
 *  @param deviceID     设备ID
 *  @param typeInt      1:求购；2：供应
 *  @param success      success description
 *  @param failure      failure description
 */
- (void)getSupplyRestrictWithToken:(NSString *)token
                            withId:(NSString *)accessID
                      withClientId:(NSString *)clientID
                  withClientSecret:(NSString *)clientSecret
                      withDeviceId:(NSString *)deviceID
                          withType:(NSString *)typeInt
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 我的供应列表 -----------
/**
 *  我的供应信息列表
 *
 *  @param token        AccessToken
 *  @param accessID     用户id
 *  @param clientID     应用的API Key
 *  @param clientSecret 应用的API Secret
 *  @param deviceId     设备ID
 *  @param page         当前页码（默认显示第一页）
 *  @param pageSize     每页显示条数，（默认15条）
 *  @param success      success description
 *  @param failure      failure description
 */
- (void)getMysupplyListWithToken:(NSString *)token
                    withAccessId:(NSString *)accessID
                    withClientId:(NSString *)clientID
                withClientSecret:(NSString *)clientSecret
                    withDeviewId:(NSString *)deviceId
                       withState:(NSString *)state
                        withPage:(NSString *)page
                    withPageSize:(NSString *)pageSize
                  WithsearchTime:(NSString *)searchTime
success:(void (^)(id))success failure:(void (^)(NSError *))failure;

#pragma mark-上传图片
-(void)upDataImage:(UIImage *)image
           Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 上传图片 -----------

-(void)upDataImageIOS:(NSString *)imageString
       workstationUid:(NSString *)workstationUid
           companyUid:(NSString *)companyUid
                 type:(NSString *)type
             saveTyep:(NSString *)saveType
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 获取产品分类列表 -----------
- (void)getTypeInfoSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 获取产品列表 -----------
- (void)getProductWithTypeUid:(NSString *)typeUid
                         type:(NSString *)type
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我的供应信息保存 -----------
- (void)saveSupplyInfoWithruid:(NSString *)ruid                             accessId:(NSString *)accessId
                             clientId:(NSString *)clientId
                         clientSecret:(NSString *)clientSecret
                             deviceId:(NSString *)deviceId
                                  uid:(NSString *)uid
                                title:(NSString *)title
                                 name:(NSString *)name
                           productUid:(NSString *)productUid
                                count:(NSString *)count
                                price:(NSString *)price
                        effectiveTime:(NSString *)time
                               remark:(NSString *)remark
                           nurseryUid:(NSString *)nurseryUid
                            imageUrls:(NSString *)imageUrls
                    imageCompressUrls:(NSString *)imageCompressUrls
          withSpecificationAttributes:(NSArray *)etcAttributes
                      imageDetailUrls:(NSString *)imageDetailUrls
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure ;
#pragma mark ---------- 我的供应信息详情 -----------
- (void)getMySupplyDetailInfoWithAccessToken:(NSString *)accesToken
                                    accessId:(NSString *)accessId
                                    clientId:(NSString *)clientId
                                clientSecret:(NSString *)clientSecret
                                    deviceId:(NSString *)deviceId
                                         uid:(NSString *)uid
                                     Success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))failure ;
#pragma mark ---------- 收到的我的订制信息 -----------
- (void)getMyCustomizedListInfoWithPageNumber:(NSString *)pageNumber
                                     pageSize:(NSString *)pageSize
                                      Success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure ;
#pragma mark ---------- 我的定制信息列表 -----------
- (void)getCustomSetListInfo:(NSString *)pageNumber
                    pageSize:(NSString *)pageSize
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 消费记录 -----------
- (void)getConsumeRecordInfoWithPageNumber:(NSString *)pageNumber
                                  pageSize:(NSString *)pageSize
                                   Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure ;
#pragma mark ---------- 微信支付 -----------
/**
 *  微信支付
 *
 *  @param price        总金额
 *  @param supplyBuyUid Type=1 时必传，求购ID
 *  @param recordUid    购买的记录的UID
 *  @param type         不传默认为0;代表充值1代表微信单条购买;2代表工程采购单条购买3苗小二开通
 *  @param success      success description
 *  @param failure      failure description
 */
- (void)weixinPayOrder:(NSString *)total_fee
          supplyBuyUid:(NSString *)supplyBuyUid
             recordUid:(NSString *)recordUid
                  type:(NSString *)type
               Success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;
;
#pragma mark ---------- 银联获取tn交易号方法 -----------
- (void)getUnioPay:(NSString *)price
           Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
- (void)getUnioPayTnString:(NSString *)price
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我的供应信息修改 -----------
-(void)mySupplyUpdataWithUid:(NSString *)uid
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我的订制设置保存 -----------
- (void)saveMyCustomizedInfo:(NSString *)uid
                  productUid:(NSString *)productUid
                usedProvince:(NSString *)usedProvince
                    usedCity:(NSString *)usedCity
 withSpecificationAttributes:(NSArray *)etcAttributes
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我的订制设置修改信息 -----------
- (void)getMyCustomsetEditingWithUid:(NSString *)uid
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我的供应信息批量删除 -----------
- (void)deleteMySupplyInfo:(NSString *)uid
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
#pragma mark 我的求购信息批量删除
- (void)deleteMyBuyInfo:(NSString *)uids
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我的定制信息批量删除 -----------
- (void)deleteCustomSetInfo:(NSString *)uids
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;

#pragma mark 我的苗圃信息批量删除
- (void)deleteMyNuseryInfo:(NSString *)uids
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 获得当前用户余额 -----------
- (void)getAmountInfo:(NSString *)nilString
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 是否首次充值 -----------
- (void)isFirstRecharge:(NSString *)nilString
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark 我的收藏猜你喜欢供应列表
-(void)myCollectionYouLikeSupplyWithPage:(NSString *)pageNum
                            WithPageSize:(NSString *)pageSize
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
#pragma mark 求购联系方式购买
-(void)payForBuyMessageWithBuyUid:(NSString *)uid
                             type:(NSString *)type
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
#pragma mark 我的求购信息关闭
-(void)closeMyBuyMessageWithUids:(NSString *)uids
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
#pragma mark 我的求购信息打开
-(void)openMyBuyMessageWithUids:(NSString *)uids
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
#pragma mark 我的求购退回原因
-(void)MyBuyMessageReturnReasonWihtUid:(NSString *)Uid
                                Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 购买记录 -----------
- (void)purchaseHistoryWithPage:(NSString *)page  Withtype:(NSString *)type
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 购买记录删除 -----------
- (void)purchaseHistoryDeleteWithUid:(NSString *)uid
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 手动刷新供应 -----------
- (void)sdsupplybuyrRefreshWithUid:(NSString *)uid
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 分享等单条非手动刷新供应 -----------
- (void)supplybuyrRefreshWithUid:(NSString *)uid
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;


#pragma mark ---------- 消息列表 -----------
-(void)messageListWithPage:(NSString *)page
              WithPageSize:(NSString *)pageSize
                 WithReads:(NSString *)reads
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 单条消息设置已读 -----------
-(void)myMessageReadingWithUid:(NSString *)uid
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 批量消息删除 -----------
-(void)myMessageDeleteWithUid:(NSString *)uids
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 验证手机号是否存在 -----------
-(void)checkPhoneNum:(NSString *)phone
             Success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 忘记密码，验证手机验证码是否正确 -----------
-(void)checkChongzhiPassWorldWihtPhone:(NSString *)phone
                              WithCode:(NSString *)code
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 设置新密码 -----------
-(void)setNewPassWordWithPhone:(NSString *)phone
                  WithPassWord:(NSString *)password
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 我的供应详情-分享供应 -----------
-(void)supplyShareWithUid:(NSString *)uid
               nurseryUid:(NSString *)nurseryUid
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 我的订制信息 -----------
-(void)customizationUnReadWithPageSize:(NSString *)pageSize
                            PageNumber:(NSString *)pageNumber
                              infoType:(NSInteger)infoType
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 按产品ID查询订制信息 -----------
- (void)recordByProductWithProductUid:(NSString *)productUid
                             infoType:(NSInteger)infoType
                            pageSize:(NSString *)pageSize
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 批量删除订制信息（按条） -----------
- (void)deleterecordWithIds:(NSString *)ids
                   infoType:(NSInteger)infoType
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 批量删除订制信息（按树种） -----------
- (void)deleteprorecordWithIds:(NSString *)ids
                      infoType:(NSInteger)infoType
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 按树名获取苗木规格属性 -----------
-(void)huoqumiaomuGuiGeWithTreeName:(NSString *)name
                            andType:(NSString *)type andMain:(NSString *)main
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 求购分享 -----------
/**
 *  求购分享
 *
 *  @param uid     求购UID
 *  @param state   用于求购中 1:热门求购（热门求购中除去已定制和已购买的）；2：我的求购；3：已定制；4：已购买
 *  @param success success description
 *  @param failure failure description
 */
- (void)buyShareWithUid:(NSString *)uid
                  state:(NSString *)state
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;



#pragma mark ---------- 根据关联规格ID获取下一级 -----------
-(void)huoquxiayijiguigeWtithrelation:(NSString *)relation
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;



#pragma mark ---------- 积分兑换规则 -----------
- (void)integraRuleSuccess:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 积分兑换 -----------
- (void)integralrecordexchangeWithIntegral:(NSString *)integral
                                 withMoney:(NSString *)money
                                   Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;

/*******************工程助手API*******************/

#pragma mark ---------- 使用帮助 -----------
-(void)userHelpSuccess:(void (^)(id responseObject))success
failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 我的订单列表 -----------
/**
 *  我的订单列表
 *
 *  @param status     订单状态 1：报价中；0：已结束
 *  @param keywords   检索词
 *  @param pageNumber 当前页码， 默认1
 *  @param pageSize   每页显示数，默认15
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)projectGetMyOrderListWithStatus:(NSString *)status
                         keywords:(NSString *)keywords
                       pageNumber:(NSString *)pageNumber
                         pageSize:(NSString *)pageSize
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;


/******************* end --工程助手API--  end *******************/

/*******************站长助手API*******************/
#pragma mark ---------- 检索工程订单 -----------
/**
 *  检索工程订单
 *
 *  @param orderBy      排序，发布时间：orderDate,截止日期：endDate,默认orderDate
 *  @param orderSort    排序，升序：asc,降序：desc,默认desc
 *  @param status       0:已结束，1：报价中，2：已报价
 *  @param orderTypeUid 订单类型ID
 *  @param area         用苗地，Json格式， [{"provinceCode":"11", "cityCode":"110101"},{"provinceCode":"11", "cityCode":"110102"}]
 *  @param pageNumber   当前页码， 默认1
 *  @param pageSize     每页显示数，默认15
 *  @param success      success description
 *  @param failure      failure description
 */
- (void)stationGetOrderSearchWithOrderBy:(NSString *)orderBy
                               orderSort:(NSString *)orderSort
                                  status:(NSString *)status
                            orderTypeUid:(NSString *)orderTypeUid
                                    area:(NSString *)area
                              pageNumber:(NSString *)pageNumber
                                pageSize:(NSString *)pageSize
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 获取订单类型 -----------
- (void)stationGetOrderTypeSuccess:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
/******************* end--站长助手API--end *******************/
#pragma mark ---------- 获取质量要求、报价要求、订单类型 -----------
-(void)huiquZhiliangYaoQiuBaoDingSuccess:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 发布工程订单 -----------
-(void)fabuGongChengDingDanWithUid:(NSString *)uid WithprojectName:(NSString *)projectName
                           WithorderName:(NSString *)orderName
                        WithorderTypeUid:(NSString *)orderTypeUid
                        WithusedProvince:(NSString *)usedProvince
                            WithusedCity:(NSString *)usedCity
                             WithendDate:(NSString *)endDate
                        WithchargePerson:(NSString *)chargePerson
                               Withphone:(NSString *)phone
                  WithqualityRequirement:(NSString *)qualityRequirement
                   WithquotationRequires:(NSString *)quotationRequires
                                 Withdbh:(NSString *)dbh
                      WithgroundDiameter:(NSString *)groundDiameter
                         Withdescription:(NSString *)description
                                    With:(NSString *)itemjson
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我的订单详情 -----------
-(void)myDingDanDetialWithUid:(NSString *)uid
                 WithPageSize:(NSString *)pageSize
                 WithPageNum:(NSString *)pageNumber
                 Withkeyword:(NSString *)keyword
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我的分享 -----------
-(void)getMyShareSuccess:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 报价管理-----------
-(void)baojiaGuanLiWithStatus:(NSString *)status
                  Withkeyword:(NSString *)keyword
               WithpageNumber:(NSString *)pageNumber
                 WithpageSize:(NSString *)pageSize
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 报价详情-苗木信息-----------
-(void)baojiaDetialMiaoMuWtihUid:(NSString *)uid
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 报价详情-报价信息-----------
-(void)baojiaDetialMessageWithUid:(NSString *)uid
                      WithkeyWord:(NSString *)keyword
                   WithpageNumber:(NSString *)pageNumber
                     WithpageSize:(NSString *)pageSize
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 站长助手-我的报价 -----------
/**
 *  我的报价
 *
 *  @param status     状态1：已报价；2：已合作；3:已过期；默认所有
 *  @param keyword    检索词
 *  @param pageNumber 页码，默认1
 *  @param pageSize   每页显示数，默认15
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)stationMyQuoteListWithStatus:(NSString *)status
                         Withkeyword:(NSString *)keyword
                      WithpageNumber:(NSString *)pageNumber
                        WithpageSize:(NSString *)pageSize
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 站长助手-检索订单详情 -----------
/**
 *  检索订单详情
 *
 *  @param orderUid 订单ID
 *  @param keyword  检索关键词
 *  @param success  success description
 *  @param failure  failure description
 */
- (void)stationGetOrderDetailWithOrderUid:(NSString *)orderUid
                                  keyword:(NSString *)keyword
                                  Success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 建立合作 -----
-(void)jianliHezuoWithBaoJiaID:(NSString *)uid   Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 合作详情 -----
-(void)hezuoDetialWithorderUid:(NSString *)orderUid withitemUid:(NSString *)itemUid
                   WithPageNum:(NSString *)pageNumber
                  WithPageSize:(NSString *)pageSize
                   WithKeyWord:(NSString *)keyword
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 报价详情-苗木信息 -----
//-(void)hezuoDetialMiaoMuXiXi

#pragma mark ---------- 站长助手-报价 -----------
/**
 *  报价
 *
 *  @param uid          订单苗木ID
 *  @param orderUid     订单ID
 *  @param price        报价价格
 *  @param quantity     报价数量
 *  @param province     苗圃 省
 *  @param city         苗圃 市
 *  @param county       苗圃 县
 *  @param town         苗圃 镇
 *  @param description  描述
 *  @param imags        大图‘,’分割
 *  @param compressImgs 缩略图‘,’分割
 *  @param success      success description
 *  @param failure      failure description
 */
- (void)stationQuoteCreateWithUid:(NSString *)uid
                         orderUid:(NSString *)orderUid
                            price:(NSString *)price
                         quantity:(NSString *)quantity
                         province:(NSString *)province
                             city:(NSString *)city
                           county:(NSString *)county
                             town:(NSString *)town
                      description:(NSString *)description
                             imgs:(NSString *)imags
                     compressImgs:(NSString *)compressImgs
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
//#pragma mark ---------- APP设置首次充值最低额度 -----------
//- (void)getLimitChargeSuccess:(void (^)(id responseObject))success
//failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 站长中心 -----------
- (void)stationMasterSuccess:(void (^)(id responseObject))success
failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 站长中心编辑 -----------
/**
 *  站长中心编辑
 *
 *  @param chargePerson 负责人
 *  @param phone        电话
 *  @param brief        简介，说明
 *  @param success      success description
 *  @param failure      failure description
 */
- (void)stationMasterUpdateWithChargePerson:(NSString *)chargePerson
                                      phone:(NSString *)phone
                                      brief:(NSString *)brief
                                    Success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure;


#pragma mark ---------- 金牌供应 -----------
- (void)GoldSupplrWithPageSize:(NSString *)pageSize WithPage:(NSString *)page
              Withgoldsupplier:(NSString *)goldsupplier
                Success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 我的荣誉列表 -----------
/**
 *  我的荣誉列表
 *
 *  @param workstationUid 工作站ID
 *  @param pageNumber     页码，默认1
 *  @param pageSize       每页显示数。默认10
 *  @param success        success description
 *  @param failure        failure description
 */
- (void)stationHonorListWithWorkstationUid:(NSString *)workstationUid
                                pageNumber:(NSString *)pageNumber
                                  pageSize:(NSString *)pageSize
                                   Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 荣誉详情与编辑页信息共用接口 -----------
/**
 *  荣誉详情与编辑页信息共用接口
 *
 *  @param uid     荣誉ID
 *  @param success success description
 *  @param failure failure description
 */
- (void)stationHonorDetailWithUid:(NSString *)uid
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 荣誉添加 -----------
/**
 *  荣誉添加
 *
 *  @param uid             新增是为空，更新是必传
 *  @param workstationUid  工作站ID
 *  @param name            荣誉名称
 *  @param acquisitionTime 获取时间，格式：yyyy-MM-dd
 *  @param image           荣誉图片
 *  @param success         success description
 *  @param failure         failure description
 */
- (void)stationHonorCreateWithUid:(NSString *)uid
                   workstationUid:(NSString *)workstationUid
                             name:(NSString *)name
                  acquisitionTime:(NSString *)acquisitionTime
                            image:(NSString *)image
                             Type:(NSString *)type
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 荣誉删除 -----------
/**
 *  荣誉删除
 *
 *  @param uid     荣誉ID
 *  @param success success description
 *  @param failure failure description
 */
- (void)stationHonorDeleteWithUid:(NSString *)uid
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 我的团队 -----------
/**
 *  我的团队
 *
 *  @param uid        工作站ID
 *  @param pageNumber 页码，默认1
 *  @param pageSize   每页显示数。默认10
 *  @param keyword    检索词
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)stationTeamWithUid:(NSString *)uid
                pageNumber:(NSString *)pageNumber
                  pageSize:(NSString *)pageSize
                   keyword:(NSString *)keyword
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－提交资质升级 -----------
-(void)shengjiGCGSWithcompanyName:(NSString *)companyName WithlegalPerson:(NSString *)legalPerson Withphone:(NSString *)phone
                      Withzipcode:(NSString *)zipcode
                        Withbrief:(NSString *)brief
                     Withprovince:(NSString *)province
                         Withcity:(NSString *)city
                       Withcounty:(NSString *)county
                      Withaddress:(NSString *)address
                     WithqualJson:(NSString *)qualJson
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－工程中心----------
-(void)gongchengZhongXinInfoSuccess:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－企业信息编辑----------
-(void)gongchengZhongXinInfoEditWithUid:(NSString *)uid WithcompanyName:(NSString *)companyName WithlegalPerson:(NSString *)legalPerson Withphone:(NSString *)phone Withbrief:(NSString *)brief Withprovince:(NSString *)province WithCity:(NSString *)city Withcounty:(NSString *)county
                            WithAddress:(NSString *)address
                                Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－我的资质----------
-(void)GCZXwodezizhiWithuid:(NSString *)uid
             WithpageNumber:(NSString *)pageNumber
               WithpageSize:(NSString *)pageSize
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－工程助手首页--------
-(void)GCGSshouyeWithPageSize:(NSString *)pageSize WithsupplyCount:(NSString *)supplyCount
             WithsupplyNumber:(NSString *)supplyNumber
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－我的资质保存--------
-(void)GCGSRongYuTijiaoWithuid:(NSString *)uid
      WtihcompanyQualification:(NSString *)companyQualification
           WithacquisitionTime:(NSString *)acquisitionTime
                          With:(NSString *)level
                WithcompanyUid:(NSString *)companyUid
          WithissuingAuthority:(NSString *)issuingAuthority
                      WithType:(NSString *)Type
                Withattachment:(NSString *)attachment   Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－我的资质删除-------
-(void)GCZXDeleteRongYuWithuid:(NSString *)uid
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 工作站列表 -----------
/**
 *  工作站列表
 *
 *  @param province   省
 *  @param city       市
 *  @param county     县
 *  @param keyword    检索词
 *  @param pageNumber 页码，默认1
 *  @param pageSize   每页显示数，默认15
 *  @param success    {
 "result":{
 "workStationList":[
 {
 "area":"山东临沂河东区汤河镇",	--地区
 "chargelPerson":"邢明龙",	--联系人
 "phone":"18265391071",	--联系电话
 "uid":"4A367CD4-8B46-4279-B7D1-015E9FECAEE6",	--工作站ID
 "viewNo":"鲁 第0001号",	--工作站编号
 "workstationName":"0001"	--工作站名称
 },
 {
 ......
 }
 ]
 },
 "success":true
 }

 *  @param failure    {
	"error_code":"500",
	"msg":"",
	"success":false
 }

 */
- (void)stationListWithProvince:(NSString *)province
                           city:(NSString *)city
                         county:(NSString *)county
                        keyword:(NSString *)keyword
                     pageNumber:(NSString *)pageNumber
                       pageSize:(NSString *)pageSize
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工作站详情-----------
//{
//    "result":{
//        "supplyList":[	--供应信息
//                      {
//                          "count":"1",
//                          "createTime":"2016-05-28 09:20:31",
//                          "edit":false,
//                          "goldsupplier":0,
//                          "image":"http://123.56.229.197:8082/qlmm//static/upload/attachment/member/image/201605/d7f3abe0-b220-411a-b2f3-1b6c547c2a57-compress.jpg",
//                          "price":"面议",
//                          "reason":"",
//                          "shuaxin":false,
//                          "state":0,
//                          "title":"湖北地区8-15公分栾树",
//                          "tuihui":false,
//                          "uid":"FCFF44D3-D6F0-44F7-872A-26FBE1A9CFA8"
//                      },
//                      {
//                          ......
//                      }
//                      ],
//        "masterInfo":{	--工作站信息，第一页返回数据，其他页不返回
//            "area":"山东省临沂市莒南县板泉镇",	--地区
//            "brief":"",	--简介
//            "chargelPerson":"李传刚",	--联系人
//            "creditMargin":"0.00",	--保证金
//            "phone":"18265391071",
//            "type":"分站",
//            "uid":"68699F89-D71C-4B84-A728-416A47F9A57D",
//            "viewNo":"鲁 第0003号",	--工作站编号
//            "workstationName":"012",	--工作站名称
//            "workstationPic":""	--工作站头像
//        }
//    },
//    "success":true
//}
-(void)workstationdetialWithuid:(NSString *)uid
                 WithpageNumber:(NSString *)pageNumber
                   WithpageSize:(NSString *)pageSize
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 进入资质审核信息填写页面，获取之前的审核数据-----------
-(void)gongchenggongsiShengheTuiHuiBianJiSuccess:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－我的订单基本信息编辑-----------
-(void)wodedingdanbianjiWithUid:(NSString *)uid Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－订单苗木编辑信息-----------
-(void)dingdanMMbianjiWithUid:(NSString *)uid Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－订单苗木更新-----------
-(void)dingdanMMgengxinWithUid:(NSString *)uid
                      WithName:(NSString *)name
                  Withquantity:(NSString *)quantity
                      Withunit:(NSString *)unit
                Withdecription:(NSString *)decription Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－站长供应信息列表-----------
-(void)zhanzhanggongyingListWithPageNum:(NSString *)pageNumber WithPageSize:(NSString *)pageSize WithsearchTime:(NSString *)searchTime
                                Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－站长供应信息检索---------
-(void)ZhanZhanggongyingListWithPage:(NSString*)page
                        WithPageSize:(NSString *)pageSize
                    Withgoldsupplier:(NSString *)goldsupplier
                      WithProductUid:(NSString *)productUid
                     WithProductName:(NSString *)productName
                        WithProvince:(NSString *)province
                            WithCity:(NSString *)city
                          WithCounty:(NSString *)county
                             WithAry:(NSArray *)ary
                      WithSearchTime:(NSString *)searchTime
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 站长中心分享 -----------
- (void)stationShareSuccess:(void (^)(id responseObject))success
failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 店铺分享 -----------
- (void)shopShareWithMemberUid:(NSString *)memberUid
                       Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 工程中心分享 -----------
- (void)GCZXShareSuccess:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 站长助手－报价获取苗木信息 -----------
- (void)getstationBaoJiaMessageWithUid:(NSString *)uid Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 站长助手－审核工程订单 -----------
- (void)shenhedingdanWithUid:(NSString *)uid WithauditStatus:(BOOL)auditStatus Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 店铺首页 -----------
-(void)getMyShopHomePageMessageSuccess:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 店铺基本信息 -----------
-(void)getMyShopBaseMessageSuccess:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 店铺基本信息修改-----------
-(void)getMyShopBaseMessageUpDataWithType:(NSString *)type value:(NSString *)value Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 店铺地址信息修改-----------
-(void)UpDataMyShopAddressWithshopProvince:(NSString *)shopProvince
                              WithshopCity:(NSString *)shopCity
                            WithshopCounty:(NSString *)shopCounty
                           WithshopAddress:(NSString *)shopAddress
                                   Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 后台店铺上传图片-----------
-(void)updataShopImageWithType:(NSString *)type WithImageStr:(NSString *)imageStr
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 添加店铺分享记录-----------
-(void)shareShopMessageViewNumWithmemberUid:(NSString *)memberUid
                                            Success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 店铺装修-----------
-(void)getShopInoterMessageSuccess:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 未通过审核订单删除-----------
-(void)deleteOrderByUids:(NSString *)uids Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 未通过审核订单苗木删除-----------
-(void)deleteOrderMMByUid:(NSString *)uid Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
#pragma mark ---------- APP店铺全部求购 -----------
- (void)shopBuyList:(NSString *)memberUid
               page:(NSString *)page
           pageSize:(NSString *)pageSize
      selfrecommend:(NSString *)selfrecommend
            Success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;
#pragma mark ---------- APP店铺全部供应 -----------
- (void)shopSupplyList:(NSString *)memberUid
               page:(NSString *)page
           pageSize:(NSString *)pageSize
      selfrecommend:(NSString *)selfrecommend
            Success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;
#pragma mark ---------- APP后台店铺供应信息推荐 -----------
/**
 *  APP后台店铺供应信息推荐
 *
 *  @param supplyUid 供求id(List<String>)
 *  @param success   {"result":true,"success":true}
 *  @param failure   {
	"error_code":"500",
	"msg":"保存店铺推荐供应信息失败",
	"success":false
 }
 */
- (void)shopAddSupply:(NSString *)supplyUid
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;
#pragma mark ---------- APP后台店铺求购信息推荐 -----------
- (void)shopAddBuy:(NSString *)supplyUid
           Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;


#pragma mark ---------- 分组分享 -----------
/**
 *  分组分享
 *
 *  @param porductUid  产品ID，根据规格查询必传
 *  @param productName 产品名称
 *  @param province    省
 *  @param city        市
 *  @param county      县
 *  @param startTime   选择时间
 *  @param spec        填写的规格参数值
 *  @param success     {
 "result":{
 "pic":"http://192.168.1.5:8080//static/images/ic_launcher-web.png",
 "text":"23日00时至16时,采购的树种：白蜡 测试树种 串钱柳",
 "title":"23日最新求购",
 "url":"http://192.168.1.5:8080//wap/group/list?uid=040F0BC0-9DB6-44B5-8BF8-6E4D990B92A0"
 },
 "success":true
 }

 *  @param failure     {
	"error_code":"500",
	"msg":"",
	"success":false
 }

 */
- (void)groupShareWithProductUid:(NSString *)porductUid
                     productName:(NSString *)productName
                        province:(NSString *)province
                            city:(NSString *)city
                          county:(NSString *)county
                       startTime:(NSString *)startTime
                    searchStatus:(NSString *)searchStatus
                     spec_XXXXXX:(NSArray *)spec
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 采购详情 -----------
/**
 *  站长中心定制信息的采购详情
 *
 *  @param uid     求购UID
 *  @param success success description
 *  @param failure failure description
 */
- (void)workstationPushPurchaseInfo:(NSString *)uid type:(NSString *)type                             Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 推送信息求购联系方式购买 -----------
/**
 *  推送信息求购联系方式购买
 *
 *  @param recordUid 推送信息UID
 *  @param success   success description
 *  @param failure   failure description
 */
- (void)wrokstationPurchasePushBuy:(NSString *)recordUid
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 站长求购 -----------
/**
 *  站长求购
 *
 *  @param pageSize   每页显示条数，（默认15条）
 *  @param page       当前页：默认为1
 *  @param searchTime 检索时间，当前页的最后一条数据的searchTime，不传时，默认是第一页
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)workstationBuyWithPageSize:(NSString *)pageSize
                              page:(NSString *)page
                        searchTime:(NSString *)searchTime
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 站长晒单-我的晒单列表 -----------
- (void)workstationMyShaiDanWithPageNumber:(NSString *)pageNumber
                                pageSize:(NSString *)pageSize
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 站长晒单-全部晒单列表 -----------
- (void)workstationAllShaiDanWithThpe:(NSInteger )type
                           PageNumber:(NSString *)pageNumber
                             pageSize:(NSString *)pageSize
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;


#pragma mark ---------- 站长晒单-评论删除 -----------
- (void)workStationShaiDanPingLunDeleteWithPingLunUid:(NSString *)pingLunUid//评论ID
                                              Success:(void (^)(id responseObject))success
                                              failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 站长晒单-评论 -----------
/**
 *  站长晒单-评论
 *
 *  @param shaiDanUid 晒单ID
 *  @param content    评论内容内容
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)workstationShaiDanPIngLunWithShaiDanUid:(NSString *)shaiDanUid
                                        content:(NSString *)content
                                        Success:(void (^)(id responseObject))success
                                        failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 站长晒单-晒单详情 -----------
/**
 * 站长晒单-晒单详情( 返回结果中，有dianZanUid字段表示已点赞；del=1表示为当前用户所评论，可删除，否则不可删除 )
 *
 *  @param uid        晒单ID
 *  @param pageNumber 页码，默认1
 *  @param pageSize   每页显示数。默认15
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)workstationShaiDanDetailWithUid:(NSString *)uid
                             pageNumber:(NSString *)pageNumber
                               pageSize:(NSString *)pageSize
                                Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 站长晒单-点赞取消点赞 -----------
/**
 *  站长晒单-点赞取消点赞
 *
 *  @param shaiDanUid 晒单ID
 *  @param dianZanUid 点赞ID，不传时，表示点赞，传入时，表示取消点赞
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)workStationShaiDaDianzanWithShaiDanUid:(NSString *)shaiDanUid
                                    dianZanUid:(NSString *)dianZanUid
                                       Success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 站长晒单编辑信息 -----------
/**
 *  站长晒单编辑信息
 *
 *  @param uid     晒单ID
 *  @param success success description
 *  @param failure failure description
 */
- (void)workstationShaiDanUpdateWithUid:(NSString *)uid
                                Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 站长晒单删除 -----------
/**
 *  站长晒单删除
 *
 *  @param uids    晒单ID, 单个或多个
 *  @param success success description
 *  @param failure failure description
 */
- (void)workstationShaiDanDeleteWithUids:(NSString *)uids
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 站长晒单 -----------
/**
 *  站长晒单(图片上传原图和缩略图，使用图片上传接口，type=3,saveType=1)
 *
 *  @param uid     晒单ID，编辑时不为空
 *  @param title   晒单名称
 *  @param content 晒单内容
 *  @param images  晒单图片，只传缩略图，多张以,分开
 *  @param success success description
 *  @param failure failure description
 */
- (void)workstationShaiDanSaveWithUid:(NSString *)uid
                                title:(NSString *)title
                              content:(NSString *)content
                               images:(NSString *)images
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;




#pragma mark ---------- 合作苗企-合作苗企首页 -----------
- (void)cooperationCompanyIndexSuccess:(void (^)(id responseObject))success
failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 合作苗企-苗企供应信息列表 -----------
- (void)cooperationCompanySupplyWithPage:(NSString *)page
                                pageSize:(NSString *)pageSize
                              searchTime:(NSString *)searchTime
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 合作苗企-苗企求购 -----------
- (void)cooperationCompanyBuyWithPageSize:(NSString *)pageSize
                                     page:(NSString *)page
                               searchTime:(NSString *)searchTime
                             goldsupplier:(NSString *)goldsupplier
                                  Success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 合作苗企-苗企详情 -----------
- (void)cooperationCompanyDetailWithUid:(NSString *)uid
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 合作苗企-苗企中心 -----------
- (void)cooperationCompanuCenterWithSuccess:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 合作苗企-合作苗企列表 -----------
/**
 *  合作苗企列表
 *
 *  @param searchTime 查询时间
 *  @param starLevel  星级，值：1、2、3、4、5
 *  @param province   省
 *  @param city       市
 *  @param county     县
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)cooperationCompanyListWithSearchTime:(NSString *)searchTime
                                   starLevel:(NSString *)starLevel
                                    province:(NSString *)province
                                        city:(NSString *)city
                                      county:(NSString *)county
                                        page:(NSString *)page
                                    pageSize:(NSString *)pageSize
                                     Success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 合作苗企-合作苗企荣誉列表 -----------
/**
 *  合作苗企荣誉列表
 *
 *  @param memberUid 供应商（会员ID）
 *  @param page      类型，不传时，表示查询全部
 *  @param page      页码，默认1
 *  @param pageSize  每页条数，默认10
 *  @param success   success description
 *  @param failure   failure description
 */
- (void)cooperationCompanyHonorsWithMemberUid:(NSString *)memberUid
                                         type:(NSString *)type
                                         page:(NSString *)page
                                     pageSize:(NSString *)pageSize
                                      Success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 合作苗企-荣誉详情 -----------
- (void)cooperationCompanyHonorWithUid:(NSString *)uid
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 合作苗企-新增荣誉 -----------
- (void)cooperationCompanyHonorsCreateWithUid:(NSString *)uid
                                         type:(NSString *)type
                                         name:(NSString *)name
                              acquisitionTime:(NSString *)acquisitionTime
                                        image:(NSString *)image
                                      Success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 合作苗企-荣誉删除 -----------
- (void)cooperationCompanyHonorDeleteWithUid:(NSString *)uid
                                     Success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))failure;


#pragma mark ---------- 金牌供应商-金牌供应商列表-----------
-(void)goldSupplyListWithprovince:(NSString *)province withcity:(NSString *)city withcounty:(NSString *)county WithKeyWord:(NSString *)keyword withPage:(NSString *)page withPageSize:(NSString *)pageSize  Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 金牌供应商-金牌中心-----------
-(void)goldSupplierInfoSuccess:(void (^)(id responseObject))success
failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 金牌供应商-金牌详情-----------
-(void)goldSupplyDetialWithUid:(NSString *)memberUid Success:(void (^)(id responseObject))success
failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 金牌供应商-金牌供应商荣誉列表----------
-(void)goldSupplierHonorListWithMemberUid:(NSString *)memberUid withPage:(NSString *)page withPageSize:(NSString *)pageSize Success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 金牌供应商-金牌供应商荣誉详情----------
-(void)goldSupplierHonordetialUid:(NSString *)uid Success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 金牌供应商-金牌供应商新增荣誉----------
-(void)updatagoldSupplierHonordetialUid:(NSString *)Uid withName:(NSString *)name withacquisitionTime:(NSString *)acquisitionTime withimage:(NSString *)image withType:(NSString *)type Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 金牌供应商-荣誉删除----------
-(void)deletegoldSupplierHonordetialUid:(NSString *)Uid Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 金牌供应商-自我介绍修改----------
-(void)goldSupplierUpdatebrief:(NSString *)brief Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 金牌供应商-金牌中心分享----------
-(void)goldsupplierShareSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 工程公司-订单开启与关闭----------
-(void)GCGSOrderOpenWithUid:(NSString *)uid Withstatus:(NSString *)status Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程公司-订单明细释放----------
-(void)GCGSOrderitemReleaseWithUid:(NSString *)uid Withstatus:(NSString *)status Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程公司-订单明细开启与关闭----------
-(void)GCGSOrderItemOpenWithUid:(NSString *)uid andOrdeUid:(NSString *)orderUid Withstatus:(NSString *)status Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 搜索店铺----------
-(void)shopSearchWithPage:(NSString *)page WithpageSize:(NSString *)pageSize Withkeyword:(NSString *)keyword Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 机器人客服模糊查询 -----------
- (void)robotReplysWithKeyword:(NSString *)keyword
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 机器人客服详情 -----------
- (void)robotReplysDetailWithUid:(NSString *)uid
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 获取群成员 -----------
- (void)getGroupmembersWithGroupUid:(NSString *)uid
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;


#pragma mark -供求评论发布
- (void)gongqiucommentsFabuWithsupplybuyUid:(NSString *)supplybuyUid withcomment:(NSString *)comment
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
#pragma mark -供求评论点赞
- (void)gongqiucommentsZanWithUid:(NSString *)commentUid
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
#pragma mark -供求评论列表
-(void)gouqiucommentsListWithsupplybuyUid:(NSString *)supplybuyUid
                           WithpageNumber:(NSString *)pageNumber
                             WithpageSize:(NSString *)pageSize
                                  Success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure;
#pragma mark -新闻列表
-(void)getNewsListWitharticleCategory:(NSString *)articleCategory pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize keywords:(NSString *)keywords
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;
#pragma mark -新闻评论
-(void)newsCommentWithUid:(NSString *)uid
                  comment:(NSString *)comment
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
#pragma mark -新闻收藏
-(void)newsCollectActionArticle_uid:(NSString *)article_uid
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
#pragma mark -新闻取消收藏
-(void)newsUnCollectActionArticle_uid:(NSString *)article_uid
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
#pragma mark -新闻收藏查看
-(void)newsCollectcheckArticle_uid:(NSString *)article_uid
                            Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark -新闻收藏列表
-(void)newsCollectListWithPageSize:(NSString *)pageSize
                          WithPage:(NSString *)page
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark -供求评论删除
-(void)commentDeleteWithCommentUid:(NSString *)commentUid
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark -未读消息数量获取
-(void)getunReadSuccess:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
#pragma mark -新闻点击数统计
-(void)adReadNumWithAdUid:(NSString *)uid
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
#pragma mark -新闻部分信息
-(void)newsDetialWithAritleUid:(NSString *)adid
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

#pragma mark -求购简易发布
-(void)simplebuyWithUid:(NSString *)Uid
              Wtihtitle:(NSString *)title
      WitheffectiveTime:(NSString *)effectiveTime
            Withdetails:(NSString *)details
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark -简易求购详情
-(void)simplebuyWithUid:(NSString *)adid
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark -作者详情
-(void)AuthorDetialWithUid:(NSString *)adid
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark -作者关注or取消关注
-(void)followAuthorActionWithUid:(NSString *)uid type:(NSInteger)type
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
#pragma mark -作者文章分页
-(void)articleListWithAuthorUid:(NSString *)uid
                    withKeyWord:(NSString *)keyWord
                   WithSortType:(NSString *)sortType
                       WithPage:(NSString *)page WithPageSize:(NSString *)pageSize
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
#pragma mark -我的关注
-(void)myFollowListWithPage:(NSString *)page
               WithPageSize:(NSString *)pageSize
                WithKeyWord:(NSString *)keyword
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
#pragma mark -订单分享
-(void)orderShareWithuid:(NSString *)uid
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
#pragma mark -苗商圈发布
-(void)MiaoshangquanFabuWithContent:(NSString *)content WithPics:(NSString *)pics Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
#pragma mark -苗商圈删除
-(void)MiaoshangquanShanChuWithUid:(NSString *)uid
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark -苗商圈列表
-(void)MiaoshanglistWithPage:(NSString*)page
                WithPageSize:(NSString *)pagesize
                 WithKeyWord:(NSString *)keyword
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

#pragma mark -经纪人审核费用获取
-(void)jjrshenheGetMoneyNumSuccess:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
#pragma mark -经纪人详情分享
-(void)jjrGetDetialShareWithBrokerUid:(NSString *)uid Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark -经纪人列表分享
-(void)jjrGetListShareSuccess:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;

#pragma mark -经纪人供求列表
-(void)jjrgqListWithUid:(NSString *)uid
               WtihType:(NSString *)type
               Withpage:(NSString *)page
           WithpageSize:(NSString *)pageSize
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark -经纪人获取申请信息
-(void)jjrSHInfoListSuccess:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
#pragma mark-经纪人供应推送设置已读接口
-(void)jjrReadUid:(NSString *)uid
          Success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure;
#pragma mark-会员单位
///excellentEnterprise
-(void)huiyuanDanweiWithPageSize:(NSString *)pageSize
                    WithlastTime:(NSString *)lastTime
                     WithentType:(NSString *)entType
                   WithparentUid:(NSString *)parentUid
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
/*   
    广告相关接口
 */
#pragma mark -广告费充值记录
-(void)adChongZhiJiLuWithUid:(NSString *)member_uid
                   WithStart:(NSString *)start
                     WithEnd:(NSString *)end
               WithPage_size:(NSString *)page_size
              WithPage_index:(NSString *)page
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
#pragma mark -广告扣费记录
-(void)adkoufeiJiLuWithUid:(NSString *)member_uid
                   WithStart:(NSString *)start
                     WithEnd:(NSString *)end
               WithPage_size:(NSString *)page_size
              WithPage_index:(NSString *)page
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
#pragma mark -广告费余额  
-(void)adYueEWithUid:(NSString *)member_uid
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
#pragma mark -我的广告列表
-(void)myADListWithUid:(NSString *)member_uid
                 WithStart:(NSString *)start
                   WithEnd:(NSString *)end
             WithPage_size:(NSString *)page_size
            WithPage_index:(NSString *)page
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
#pragma mark -我的广告点击
-(void)adClickListWithUid:(NSString *)member_uid
             WithStart:(NSString *)start
               WithEnd:(NSString *)end
         WithPage_size:(NSString *)page_size
        WithPage_index:(NSString *)page
               Success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;
#pragma mark -广告点击扣费
-(void)adClickAcitionWithADuid:(NSString *)advertisement_uid
                 WithMemberUid:(NSString *)member_uid
                WithBrowsePage:(NSString *)browse_page
            WithBrowseUserType:(NSString *)browse_user_type
               withiosClientId:(NSString *)ios_client_id
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark -开屏广告
// /api/GetAdvertisementAPI/AppHomeStart
-(void)openViewAdSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
#pragma mark -微信充值
-(void)weixinADwithUid:(NSString *)member_uid
                  pice:(NSString *)pice
             Success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;
#pragma mark -广告费退费
-(void)tuifeiWithUid:(NSString *)memberuid
                WithName:(NSString *)rfrequest
                 WithYuE:(NSString *)rfmoney
       Withrfgivingmoney:(NSString *)rfgivingmoney
             Success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;
#pragma mark -添加新地址
-(void)addNewAddressWithStr:(NSString *)addressParty
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
#pragma mark -地址列表
-(void)addressListSuccess:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
#pragma mark -获取默认地址
-(void)getDefaultAddressSuccess:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
#pragma mark -删除地址
-(void)deleteAddressWithaddressId:(NSString *)addressId
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
#pragma mark -修改地址
-(void)editAddressWithaddressId:(NSString *)addressId
                    WithBodyStr:(NSString *)newaddress
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
#pragma mark -地址详情
-(void)getAssressDetialWithAddressId:(NSString *)addressId
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;
#pragma mark -设置默认地址
-(void)setDefaultAddressWithaddressId:(NSString *)addressId
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;

#pragma mark -注册短信验证码
-(void)getregisterCodeWithPhone:(NSString *)phone
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
#pragma mark -new供应发布
-(void)supplyNewPushWithBody:(NSString *)bodyStr
                WithsupplyId:(NSString *)supplyId
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
#pragma mark -new供应列表
-(void)SupplynewLsitWithQuery:(NSString *)query
                         WithlastTime:(NSString *)lastTime
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;
#pragma mark -new我的供应列表
-(void)mySupplynewLsitWithproductName:(NSString *)productName
                           Withstatus:(NSString *)status
                         WithlastTime:(NSString *)lastTime
                         WithsortType:(NSString *)sortType
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;
#pragma mark -new供应删除
-(void)mySupplyDeleteWithSupplyIds:(NSString *)supplyIds
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark -new供应刷新
-(void)mySupplyRefreshWithSupplyIds:(NSString *)supplyIds
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark -获取我的供应详情
-(void)mySupplyDetialWithSupplyId:(NSString *)supplyId
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
#pragma mark -new供应下架
-(void)mySupplyCloseWithSupplyIds:(NSString *)supplyIds
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark -new供应上架
-(void)mySupplyOpenWithSupplyIds:(NSString *)supplyIds
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
#pragma mark -求购详情查看
-(void)supplyDetialViewActionWithSupplyId:(NSString *)supplyId
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
#pragma mark -供应打电话记录
-(void)supplyDetialCallActionWithSupplyId:(NSString *)supplyId
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
#pragma mark -根据拼音匹配树种名称
-(void)getProductNameWithPY:(NSString *)pinyinStr
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
#pragma mark -求购详情查看
-(void)buyDetialViewActionWithBuyId:(NSString *)buyId
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
#pragma mark -求购详情记录拨打电话
-(void)buyDetialCallActionWithBuyId:(NSString *)buyId
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
#pragma mark -求购列表
-(void)BuysNewLsitWithQuery:(NSString *)query
                       WithlastTime:(NSString *)lastTime
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
#pragma mark -new我的求购列表
-(void)myBuysnewLsitWithproductName:(NSString *)productName
                     Withstatus:(NSString *)status
                       Withpage:(NSString *)page
                   WithlastTime:(NSString *)lastTime
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
#pragma mark -new求购发布
-(void)buyNewPushWithBody:(NSString *)bodyStr
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
#pragma mark -求购单条/批量关闭
-(void)buyCloseWithbuyIds:(NSString *)buyIds
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
#pragma mark -求购刷新
-(void)buyRefreshWithbuyIds:(NSString *)buyIds
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
#pragma mark -求购开启
-(void)buyOpenWithbuyIds:(NSString *)buyIds
             withPartyId:(NSString *)partyId
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
#pragma mark -求购删除
-(void)buyDeleteWithbuyIds:(NSString *)buyIds
             withPartyId:(NSString *)partyId
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
#pragma mark -我的求购详情
-(void)myBuyDetialWithbuyIds:(NSString *)buyId
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
#pragma mark -我的求购编辑
-(void)buyNewUpDataWithBody:(NSString *)bodyStr
                  WithBuyId:(NSString *)buyId
                  Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
#pragma mark -修改个人信息
-(void)updataUserNormalInfoWithKey:(NSString *)keyWord
                         WithValue:(NSString *)Value
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark -获取微苗商列表
-(void)weimiaoshangListWithPage:(NSString *)page
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
#pragma mark -发表苗商圈
-(void)weimiaoshangFabuWithBodyStr:(NSString *)bodyStr
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark -实名认证
-(void)realNameWithBodyStr:(NSString *)bodyStr
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
#pragma mark -实名认证审核状态
-(void)getRealNameStateSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark -实名认证退回后编辑
-(void)upDataRealNameWithroleApplyAuditId:(NSString *)roleApplyAuditId
                                  bodyStr:(NSString *)bodyStr
                                  Success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure;
#pragma mark-企业认证
-(void)enterpriseShenQingWithBodyStr:(NSString *)bodyStr
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;
#pragma mark-企业认证信息
-(void)enterpriseInfoSuccess:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;
#pragma mark-修改企业信息
-(void)upDataEnterpriseInfoWithBodyStr:(NSString *)bodyStr
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
#pragma mark-企业审核状态
-(void)getEnterpriseStateSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark-企业认证退回修改
-(void)enterpriseShenQingWithBodyStr:(NSString *)bodyStr
                WithroleApplyAuditId:(NSString *)roleApplyAuditId
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;
#pragma mark-获取重置密码短信验证码
-(void)getCodeShotMessageWtihPhone:(NSString *)phone
                           andType:(NSString *)type
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark-重置密码
-(void)resetPassWordWithPhone:(NSString *)phone
         WithverificationCode:(NSString *)verificationCode
              WithNewPassWord:(NSString *)newPassword
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
#pragma mark -首页
- (void)getHomePageInfoSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark -报价
- (void)quoteActionWithBodyStr:(NSString *)bodyStr
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark -获取我的报价已报价列表
-(void)myQuoteListWithLastTime:(NSString *)lastTime
                         state:(NSString *)state
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

#pragma mark -经纪人提交审核
-(void)jjrshenheWithDic:(NSString *)bodyStr
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark -经纪人审核状态
-(void)jjrshenheStatueSuccess:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
#pragma mark -经纪人退回重新提交
-(void)jjrShenHetuihuiWithRoleApplyAuditId:(NSString *)applyAuditId
                               WithBodyStr:(NSString *)bodyStr
                                   Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 经纪人认证微信下单
-(void)JJRWeChatPayWithroleApplyAuditId:(NSString *)roleApplyAuditId
                         WithoutTradeNo:(NSString *)outTradeNo
                                Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;
#pragma mark -经纪人资料
-(void)jjrDetialWithUid:(NSString *)uid
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark -经纪人修改自我介绍、经营品种、主营区域
-(void)jjrdetialChangeWithbodyStr:(NSString *)bodyStr
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程公司资质申请状态 -----------
- (void)projectCompanyStatusSuccess:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程公司认证
-(void)shengjiGCGSWithqualJson:(NSString *)qualJson
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程公司认证退回后重新提交
-(void)shengjiGCGSWithqualJson:(NSString *)qualJson
          WithroleApplyAuditId:(NSString *)roleApplyAuditId
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 帮助中心-----------
-(void)kefuXiTongSuccess:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 意见反馈 -----------
- (void)yijianfankuiWithBodyStr:(NSString *)bodystr
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程订单发布 -----------
-(void)fabuGongChengDingDanWithBodyStr:(NSString *)bodyStr
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我得工程订单列表 -----------
-(void)myGongChengDingDanWithLastTime:(NSString *)lastTime
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程订单详情 -----------
-(void)MyGongChengDingDanDetialWithorderId:(NSString *)orderId Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 工程订单明细关闭 -----------
-(void)MyGongChengDingDanItemCloseWithitemId:(NSString *)itemId WithorderId:(NSString *)orderId Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程订单明细报价列表 -----------
-(void)MyGongChengDingDanItemQuotesListWithitemId:(NSString *)itemId WithorderId:(NSString *)orderId Success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程订单明细分页
-(void)MyGongChengDingDanItemsListWithengineeringProcurementId:(NSString *)engineeringProcurementId
                                                      lastTime:(NSString *)lastTime
                                                       Success:(void (^)(id responseObject))success
                                          failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程订单列表获取工程订单详情，用于工程订单信息修改
-(void)EOrderListWithLastTime:(NSString *)lastTime
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 获取工程订单详情，用于工程订单信息修改
-(void)EOrderDetialWithengineeringProcurementId:(NSString *)engineeringProcurementId
                                                       Success:(void (^)(id responseObject))success
                                                       failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程订单列表
-(void)getEOrderListWithLastTime:(NSString *)lastTime
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程订单详情
-(void)getEOrderDetialWithEngineeringProcurementId:(NSString *)engineeringProcurementId
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程订单报价
-(void)eOrderBaoJiaWithobodyStr:(NSString *)bodyStr
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
#pragma mark -获取消息列表
-(void)systemMessageListWithType:(NSString *)noticeType
                    WithLastTime:(NSString *)lastTime
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
#pragma mark -设置消息已读
-(void)readedMessageWithmessageIds:(NSString *)messageIds
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark -获取消息未读数量
-(void)messageUnReadNumWithpartyId:(NSString *)partyId
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark-登录
-(void)loginInWithPhone:(NSString *)phone
            andPassWord:(NSString *)passWord
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark-帐号注册
-(void)registeredUserWithPhone:(NSString *)phone
                  withPassWord:(NSString *)password
                withRepassWord:(NSString *)repassword
                      withCode:(NSString *)code
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark -退出登录
-(void)logoutSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 获取新闻分类列表 -----------
- (void)getNewsClassSuccess:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
#pragma mark -经纪人列表
-(void)jjrListWithareaCode:(NSString *)areaCode
                  lastTime:(NSString *)lastTime
            WithproductUid:(NSString *)productUid
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

#pragma mark -经纪人详情
-(void)jjrDetialWithpartyId:(NSString *)partyId
               WithlastTime:(NSString *)lastTime
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
#pragma mark -经纪人求购列表
-(void)jjrbuysWithpartyId:(NSString *)partyId
               WithlastTime:(NSString *)lastTime
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
#pragma mark -取消收藏
-(void)deletesenderCollectWithIds:(NSString *)ids
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
#pragma mark -添加收藏
-(void)collectActionWithIds:(NSString *)ids
       WithcollectionTypeId:(NSString *)collectionTypeId
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
#pragma mark -我的收藏
-(void)myCollectListWithIds:(NSString *)ids
       WithcollectionTypeId:(NSString *)collectionTypeId
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
@end
