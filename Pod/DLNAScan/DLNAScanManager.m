//
//  DLANScanManager.m
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//

#import "DLNAScanManager.h"
#import <ConnectSDK.h>
#import <DiscoveryManager.h>
#import <DLNAService.h>
#import <SSDPDiscoveryProvider.h>
#import <DLNAHTTPServer.h>

@interface DLNAScanManager () <DiscoveryManagerDelegate>

@property (nonatomic, strong) DiscoveryManager * manager;

@end

@implementation DLNAScanManager

- (void)startMediaControl {
    [self.manager startDiscovery];
}

- (void)stopMediaControll {
    [self.manager stopDiscovery];
    self.manager = nil;
}


#pragma mark- DiscoveryManagerDelegate
- (void)discoveryManager:(DiscoveryManager *)manager didFindDevice:(ConnectableDevice *)device {
    if (_delegate && [_delegate respondsToSelector:@selector(DLNAScanManager:findDevice:)]) {
        [_delegate DLNAScanManager:self findDevice:[self getDLNADeviceWithConnecttableDevice:device]];
    }
}

- (void)discoveryManager:(DiscoveryManager *)manager didLoseDevice:(ConnectableDevice *)device {
    if (_delegate && [_delegate respondsToSelector:@selector(DLNAScanManager:removeDevice:)]) {
        [_delegate DLNAScanManager:self removeDevice:[self getDLNADeviceWithConnecttableDevice:device]];
    }
}

- (void)discoveryManager:(DiscoveryManager *)manager didUpdateDevice:(ConnectableDevice *)device {
    if (_delegate && [_delegate respondsToSelector:@selector(DLNAScanManager:updateDevice:)]) {
        [_delegate DLNAScanManager:self updateDevice:[self getDLNADeviceWithConnecttableDevice:device]];

    }
}
- (void)discoveryManager:(DiscoveryManager *)manager didFailWithError:(NSError*)error {
    if (_delegate && [_delegate respondsToSelector:@selector(DLNAScanManager:error:)]) {
        [_delegate DLNAScanManager:self error:error];
    }
}

#pragma mark- Prative
- (DLNADeviceEntity *)getDLNADeviceWithConnecttableDevice:(ConnectableDevice *)device {
    DLNADeviceEntity * dlnaDevice = [[DLNADeviceEntity alloc] initWithid:device.id
                                                                    UUID:device.serviceDescription.UUID
                                                                      ip:device.address
                                                                    addr:[device.serviceDescription.commandURL absoluteString]
                                                                    name:device.friendlyName
                                                                facturer:device.serviceDescription.manufacturer
                                                               modelName:device.modelName];
    return dlnaDevice;
}

#pragma mark- 懒加载
- (DiscoveryManager *)manager {
    if (!_manager) {
        _manager = [DiscoveryManager sharedManager];
        _manager.delegate = self;
        [_manager registerDeviceService:[DLNAService class] withDiscovery:[SSDPDiscoveryProvider class]];
        [_manager registerDeviceService:[DLNAHTTPServer class] withDiscovery:[SSDPDiscoveryProvider class]];
    }
    return _manager;
}

@end
