//
//  URLJumpModel.h
//  yintaiwang
//
//  Created by 细 Dee on 16/8/31.
//  Copyright © 2016年 IntimeE-CommerceCo. All rights reserved.
//  模型化的JumpURL 协议

#import <Foundation/Foundation.h>

/**
 *  JumpURL跳转类型
 */
typedef enum : NSUInteger {
    URLJump_PageJumps = 0,      //页面跳转
    URLJump_ActionEvent = 1     //功能性事件
} URLJumpType;

@interface URLJumpModel : NSObject

/**
 *  跳转类型（必须）
 */
@property (nonatomic ,assign) URLJumpType jumpType;
/**
 *  跳转目标类（若为页面跳转，则此参数为必须）
 */
@property (nonatomic ,copy) NSString *targetCalss;
/**
 *  功能性事件（若为功能性事件，则此参数为必须）
 */
@property (nonatomic ,copy) NSString *targetEvent;
/**
 *  目标类的必须参数(可为空)
 */
@property (nonatomic ,strong) NSArray *necessaryParameters;
/**
 *  目标是否需要登录（必须）
 */
@property (nonatomic ,assign) BOOL needSignIn;
/**
 *  属性映射 （url参数名 替换成本地的参数名）
 */
@property (nonatomic ,strong) NSDictionary *propertyMappingDic;

@end
