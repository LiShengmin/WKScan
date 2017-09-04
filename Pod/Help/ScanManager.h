//
//  ScanManager.h
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceEntity.h"


typedef void(^Device) (DeviceEntity * device);

@interface ScanManager : NSObject

+ (ScanManager *)manager;

- (void)statrScan;
- (void)stopScan;

- (void)getScanDeviceWithDLNA:(Device)dlnaDevice;
- (void)getScanDeviceWithADB:(Device)adbDevice;
- (void)getScanDeciceWithProtocol:(Device)dlnaDevice;
- (void)getScanDeviceWithSDK:(Device)dlnaDevice;

@end
