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

//Status
@property (nonatomic, assign) BOOL isRunning;
//Manager
@property (nonatomic, strong) DLNAScanManager * dlna;
//DataSource
@property (nonatomic, strong) NSMutableArray <DeviceEntity *>* devices;

@end

@implementation ScanManager

#pragma mark- lifeCycle
+ (ScanManager *)manager {
    ScanManager * manager = [[ScanManager alloc] init];
    return manager;
}

#pragma mark- Prative
/**
    新增Device 到 devices 表中， 自动去重
 */
- (void)upDateWithAddDevice:(DeviceEntity *)device {
    [self listAddDevices:device];
    if (_delegate && [_delegate respondsToSelector:@selector(scanManager:upDateWithAllDevice:)]) {
        [_delegate scanManager:self upDateWithAllDevice:[self.devices copy]];
    }
}

- (void)upDateWithRmDevice:(DeviceEntity *)device {
    [self listRmDevice:device];
    if (_delegate && [_delegate respondsToSelector:@selector(scanManager:upDateWithAllDevice:)]) {
        [_delegate scanManager:self upDateWithAllDevice:[self.devices copy]];
    }
}

- (void)listAddDevices:(DeviceEntity *)device {
    for (int i = 0; i< _devices.count; i++) {
        if ([_devices[i].ip isEqualToString:device.ip]) {
            [_devices replaceObjectAtIndex:i withObject:device];
            return;
        }
    }
    [self.devices addObject:device];
}

- (void)listRmDevice:(DeviceEntity *)device {
    for (int i = 0; i< _devices.count; i++) {
        if ([_devices[i].ip isEqualToString:device.ip]) {
            [_devices removeObjectAtIndex:i];
            return;
        }
    }
}

#pragma mark- Action
- (void)statrScan {
    if (_isRunning) return;
    [self.dlna startMediaControl];
    _isRunning = YES;
}

- (void)stopScan {
    [self.dlna stopMediaControll];
    _isRunning = NO;
}

#pragma mark- DLNA-
- (DLNAScanManager *)dlna {
    if (!_dlna) {
        _dlna = [[DLNAScanManager alloc] init];
        _dlna.delegate = self;
    }
    return _dlna;
}

#pragma mark- DLNAScanDelegate
- (void)DLNAScanManager:(DLNAScanManager *)manager findDevice:(DLNADeviceEntity *)device {
    NSString * port = [device getPort];
    DeviceEntity * deviceIterm = [DeviceEntity deviceWithName:device.name ip:device.ip ports:@[port] type:DeviceEntityScanTypeDLNA];
    [self upDateWithAddDevice:deviceIterm];
}

- (void)DLNAScanManager:(DLNAScanManager *)manager updateDevice:(DLNADeviceEntity *)device {
    NSString * port = [device getPort];
    DeviceEntity * deviceIterm = [DeviceEntity deviceWithName:device.name ip:device.ip ports:@[port] type:DeviceEntityScanTypeDLNA];
    [self upDateWithAddDevice:deviceIterm];
}

- (void)DLNAScanManager:(DLNAScanManager *)manager removeDevice:(DLNADeviceEntity *)device {
    NSString * port = [device getPort];
    DeviceEntity * deviceIterm = [DeviceEntity deviceWithName:device.name ip:device.ip ports:@[port] type:DeviceEntityScanTypeDLNA];
    [self upDateWithRmDevice:deviceIterm];
}

- (void)DLNAScanManager:(DLNAScanManager *)manager error:(NSError *)error {
    NSLog(@"error == %@", error);
    [self.dlna stopMediaControll];
    self.isRunning = NO;
}

#pragma mark- 懒加载
- (NSMutableArray<DeviceEntity *> *)devices {
    if (!_devices) {
        _devices = [NSMutableArray array];
    }
    return _devices;
}
@end
