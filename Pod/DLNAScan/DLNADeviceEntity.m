//
//  DLNADeviceEntity.m
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//

#import "DLNADeviceEntity.h"

@implementation DLNADeviceEntity

- (instancetype)initWithid:(NSString *)ID
                      UUID:(NSString *)uuid
                        ip:(NSString *)ip
                      addr:(NSString *)addr
                      name:(NSString *)name
                  facturer:(NSString *)facturer
                 modelName:(NSString *)modelName {
    if (self = [super init]) {
        self.ID = ID;
        self.uuid = uuid;
        self.ip = ip;
        self.addr = addr;
        self.name = name;
        self.facturer = facturer;
        self.modelName = modelName;
    }
    return self;
}

- (NSString *)getPort {
    if (!self.addr) return @"";
    NSString * tempStr = self.addr;
    if ([[tempStr substringFromIndex:self.addr.length] isEqualToString:@"/"]) {
        tempStr = [self.addr substringWithRange:NSMakeRange(0, self.addr.length-1)];
    }
    NSString * portStr = [self.addr componentsSeparatedByString:@":"].lastObject;
    return portStr;
}

@end
