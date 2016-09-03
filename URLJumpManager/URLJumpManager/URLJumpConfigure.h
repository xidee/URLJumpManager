//
//  URLJumpConfigure.h
//  yintaiwang
//
//  Created by 细 Dee on 16/8/31.
//  Copyright © 2016年 IntimeE-CommerceCo. All rights reserved.
//  URLJump跳转协议配置类

#import <Foundation/Foundation.h>
#import "URLJumpModel.h"

@interface URLJumpConfigure : NSObject

#pragma mark - 支持的协议

@property (nonatomic ,strong) NSArray *supportProtocols;

#pragma mark - 页面跳转

@property (nonatomic ,strong) URLJumpModel *pageA;

#pragma mark - 功能性事件

@property (nonatomic ,strong) URLJumpModel *eventA;

@end
