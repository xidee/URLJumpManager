//
//  URLJumpManager.h
//  yintaiwang
//
//  Created by 细 Dee on 16/8/31.
//  Copyright © 2016年 IntimeE-CommerceCo. All rights reserved.
//  URLJump管理类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface URLJumpManager : NSObject

/**
 *  @return URLJumpManager单例
 */
+ (instancetype)shared;

/**
 *  跳转方法
 *  @param URLString 执行的URL字符串
 */
- (void)goToURLWithURLString: (NSString *)URLString;

/**
 *  获取当前的导航控制器
 *  @return 当前导航控制器
 */
- (UINavigationController *)getCurrentNavigationController;

@end
