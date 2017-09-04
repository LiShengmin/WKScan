//
//  ScanManager.m
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//

#import "ScanManager.h"
#import "DLNAScanManager.h"

@interface ScanManager () <DLNAScanDelegate>

@property (nonatomic, copy) Device dlnaDevice;
@property (nonatomic, copy) Device adbDevice;
@property (nonatomic, copy) Device serviceDeviec;
@property (nonatomic, copy) Device sdkDevice;

@property (nonatomic, assign) BOOL isRunning;

@end

@implementation ScanManager

+ (ScanManager *)manager {
    ScanManager * manager = [[ScanManager alloc] init];
    return manager;
}

- (void)statrScan {
    if (_isRunning) return;
    if (_dlnaDevice) {
        DLNAScanManager * dlna = [[DLNAScanManager alloc] init];
        dlna.delegate = self;
        [dlna startMediaControl];
    }
}


#pragma mark- DLNA
- (void)getScanDeviceWithDLNA:(Device)dlnaDevice {
    if (!dlnaDevice) return;
    //注册
    _dlnaDevice = dlnaDevice;
    
}

- (void)DLNAScanManager:(DLNAScanManager *)manager findDevice:(DLNADeviceEntity *)device {
    if (_dlnaDevice) {
        DeviceEntity * deviceIterm = [DeviceEntity deviceWithName:device.name ip:device.addr ports:@[device.addr] type:DeviceEntityScanTypeDLNA];
        _dlnaDevice(deviceIterm);
    }
}

- (void)DLNAScanManager:(DLNAScanManager *)manager removeDevice:(DLNADeviceEntity *)device {
//
}

@end
