//
//  URLJumpManager.m
//  yintaiwang
//
//  Created by 细 Dee on 16/8/31.
//  Copyright © 2016年 IntimeE-CommerceCo. All rights reserved.
//

#import "URLJumpManager.h"
#import "URLJumpConfigure.h"

@interface URLJumpManager ()

@property (nonatomic ,strong) URLJumpConfigure *configure;

@end

@implementation URLJumpManager

+ (instancetype)shared
{
    static URLJumpManager *instance ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.configure = [[URLJumpConfigure alloc] init];
    });
    return instance;
}

/**
 *  跳转方法 主要做协议校验 参数 校验 和 登录校验
 *  @param URLString 执行的URL字符串
 */
- (void)goToURLWithURLString: (nonnull NSString *)URLString
{
    NSURL *URL = [NSURL URLWithString:URLString];
    //校验协议是否支持 跳转key 是否存在
    if (URL && [self.configure.supportProtocols containsObject:URL.scheme] && URL.host.length) {
        //从配置文件当中取协议模型 （KVC）不存在该协议返回空
        URLJumpModel *jumpModel = [self.configure valueForKey:URL.host];
        if (jumpModel) {
            
            NSDictionary *paramsDic = [self parseStringToDictionaryWithQueryString:URL.query];
            //检查必须参数
            for (NSString *key in jumpModel.necessaryParameters) {
                if (!paramsDic || ![paramsDic objectForKey:key]) {
                    return;
                }
            }
            //检查是否需要登录 未登录登陆后执行动作
            if (jumpModel.needSignIn) {
                //go login
            }else{
                [self goToURLWithURLJumpModel:jumpModel andParamsDic:paramsDic];
            }
            
        }
    }
}

/**
 *  执行URL指令
 *  @param jumpModel 协议模型
 *  @param paramsDic 协议参数
 */
- (void)goToURLWithURLJumpModel :(nonnull URLJumpModel *)jumpModel andParamsDic :(nullable NSDictionary *) paramsDic
{
    //页面跳转 （需要 跟控制器和当前导航控制器 不为空）
    if (jumpModel.jumpType == URLJump_PageJumps  && [self getRootViewController] && [self getCurrentNavigationController]) {
        
        //根据协议对象的目标类创建viewCtrl
        Class objectClass = NSClassFromString(jumpModel.targetCalss);
        UIViewController *targetViewCtrl = [[objectClass alloc] init];
        //属性赋值
        for (NSString *key in paramsDic.allKeys) {
            //需要映射到viewCtrl对应的key
            NSString *mappingKey = [jumpModel.propertyMappingDic objectForKey:key] ? [jumpModel.propertyMappingDic objectForKey:key] : key;
            [targetViewCtrl setValue:[paramsDic objectForKey:key] forKey:mappingKey];
        }
        //遍历tabbar的viewControllers 看目标类是否在栈顶
        for (int i = 0; i < [self getRootViewController].viewControllers.count ; i++) {
            UIViewController *selectedVC = [[self getRootViewController].viewControllers objectAtIndex:i];
            if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navCtrl = (UINavigationController *)selectedVC;
                if ([navCtrl.topViewController isKindOfClass:objectClass]) {
                    //跟tabbar上某个nav的栈顶同一个类 则 直接切换tabar
                    [[self getRootViewController] setSelectedIndex:i];
                    return;
                }
            }
        }
        //不在栈顶 取nav跳转
        [[self getCurrentNavigationController] pushViewController:targetViewCtrl animated:YES];
        
    }else if (jumpModel.jumpType == URLJump_ActionEvent)
    {
        //事件
        SEL event = NSSelectorFromString(jumpModel.targetEvent);
        //判断是否响应事件 然后触发
        if ([self.configure respondsToSelector:event]) {
            [self.configure performSelector:event withObject:paramsDic afterDelay:0];
        }
    }
}

/**
 *  返回当前项目的根控制器
 *  @return 返回当前项目的根控制器 （可能为空）
 */
- (nullable UITabBarController *)getRootViewController
{
    //取得根控制器 
    UIViewController *rootViewCtrl = [UIApplication sharedApplication].delegate.window.rootViewController;
    //仅仅当根控制器为tabbar 才返回 否则返回空
    return [rootViewCtrl isKindOfClass:[UITabBarController class]] ? (UITabBarController *)rootViewCtrl : nil;
}

/**
 *  获取当前的导航控制器
 *  @return 当前导航控制器 （可能为空）
 */
- (nullable UINavigationController *)getCurrentNavigationController
{
    if ([self getRootViewController]) {
        //当前视图控制器不为nav也返回空
        UIViewController *navCtrl = [self getRootViewController].selectedViewController;
        return [navCtrl isKindOfClass:[UINavigationController class]] ? (UINavigationController *) navCtrl : nil;
    }
    return nil;
}

/**
 *  将URL查询参数格式化成键值对
 *  @param parameterString URL的查询参数
 *  @return 返回查询参数的键值对 （可能为空）
 */
- (nullable NSDictionary *)parseStringToDictionaryWithQueryString:(nonnull NSString *)queryString{
    //用“&”分割
    NSArray *paramArray = [queryString componentsSeparatedByString:@"&"];
    if (paramArray.count) {
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
        for (NSString *item in paramArray) {
            NSArray *itemArray = [item componentsSeparatedByString:@"="];
            if (itemArray.count == 2) {
                //仅当个数等于二才认为是标准键值对
                NSString *key = [itemArray firstObject];
                NSString *value = [itemArray lastObject];
                //兼容多平台 转码 .net java 空格转码后是+号
                value = [[value stringByReplacingOccurrencesOfString:@"+" withString:@"%20"] stringByRemovingPercentEncoding];
                [mutableDic setObject:value forKey:key];
            }
        }
        //起码有一个键值对才返回 否则为空
        return mutableDic.allKeys.count ? mutableDic : nil;
    }
    return nil;
}

@end
