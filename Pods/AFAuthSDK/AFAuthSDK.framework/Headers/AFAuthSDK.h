//
//  AFAuthSDK.h
//  AFAuthSDK
//
//  Created by antfin on 20/09/17.
//  Copyright (c) 2017 www.antfin.com. All rights reserved.
//


//////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// 蚂蚁金服标准版本SDK-授权登录 ///////////////////////////////////
////////////////////////////// version:15.5.1  motify:2017.12.05 /////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>


typedef void(^AFCompletion)(NSDictionary *result);

@interface AFAuthSDK : NSObject

/**
 *  创建单例服务
 *
 *  @return 返回单例对象
 */
+ (AFAuthSDK *)defaultService;

/**
 *  用于设置SDK使用的window，如果没有自行创建window无需设置此接口
 */
@property (nonatomic, weak) UIWindow *targetWindow;

/**
 *  获取当前版本号
 *
 *  @return 当前版本字符串
 */
- (NSString *)currentVersion;


//////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////// 登录授权 2.0（建议接入） //////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  登录授权2.0
 *
 *  @param info             授权请求信息字符串
 *  @param scheme           调用授权的app注册在info.plist中的scheme
 *  @param completion       授权结果回调，若在授权过程中，调用方应用被系统终止，则此block无效，
 需要调用方在appDelegate中调用processAuth_V2Result:standbyCallback:方法获取授权结果
 */
- (void)authv2WithInfo:(NSString *)info
            fromScheme:(NSString *)scheme
              callback:(AFCompletion)completion;

/**
 *  处理授权信息Url
 *
 *  @param resultUrl        钱包返回的授权结果url
 *  @param completion       授权结果回调
 */
- (void)processAuthv2Result:(NSURL *)resultUrl
            standbyCallback:(AFCompletion)completion;

@end
