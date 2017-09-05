//
//  DeviceEntity.m
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//

#import "DeviceEntity.h"

@implementation DeviceEntity

+ (DeviceEntity *)deviceWithName:(NSString *)name ip:(NSString *)ip ports:(NSArray *)ports type:(DeviceEntityScanType)type  {
    DeviceEntity * device = [[DeviceEntity alloc] initWithName:name ip:ip ports:ports type:type];
    return device;
}

- (DeviceEntity *)initWithName:(NSString *)name ip:(NSString *)ip ports:(NSArray *)ports type:(DeviceEntityScanType)type  {
    self = [super init];
    if (self) {
        self.name = name;
        self.ip = ip;
        self.ports = ports;
        self.type = type;
    }
    return self;
}

@end
