//
//  URLJumpConfigure.m
//  yintaiwang
//
//  Created by 细 Dee on 16/8/31.
//  Copyright © 2016年 IntimeE-CommerceCo. All rights reserved.
//

#import "URLJumpConfigure.h"
#import "URLJumpManager.h"


/**
 *  Protocols
 */
NSString *const URLJumpProtocol = @"protocol";

@implementation URLJumpConfigure

- (NSArray *)supportProtocols
{
    if (!_supportProtocols) {
        _supportProtocols = [[NSArray alloc] init];
        _supportProtocols = @[URLJumpProtocol];
    }
    return _supportProtocols;
}

#pragma mark - 协议具体配置 (重写配置的setting方法)

- (URLJumpModel *)pageA
{
    if(!_pageA){
        _pageA = [[URLJumpModel alloc] init];
        _pageA.jumpType = URLJump_PageJumps;
        _pageA.targetCalss = NSStringFromClass([UIViewController class]);
        _pageA.needSignIn = NO;
        _pageA.necessaryParameters = @[@"paramA"];
        _pageA.propertyMappingDic = @{@"paramA":@"propertyA"};
    }
    return _pageA;
}

- (URLJumpModel *)eventA
{
    if (!_eventA) {
        _eventA = [[URLJumpModel alloc] init];
        _eventA.jumpType = URLJump_ActionEvent;
        _eventA.necessaryParameters = @[@"paramA"];
        _eventA.targetEvent = @"eventA:";
    }
    return _eventA;
}

#pragma mark - 功能性事件具体实现

/**
 *  event
 */
- (void)eventA:(NSDictionary *)paramsDic
{
   // to do
}

@end
