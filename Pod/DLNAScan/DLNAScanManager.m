//
//  DLANScanManager.m
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//

#import "DLNAScanManager.h"
#import "DLNAPlatinumManager.h"

@interface DLNAScanManager () <DLNAPlatinumDelegate>

@property (nonatomic, strong) DLNAPlatinumManager * manager;

@end

@implementation DLNAScanManager

- (void)startMediaControl {
    [self.manager startMediaControl];
}

- (void)stopMediaControll {
    [self.manager stopMediaControll];
}

- (DLNAPlatinumManager *)manager {
    if (!_manager) {
        _manager = [[DLNAPlatinumManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}

//- (DLNAPlatinumManager *)managerWithDelegate:(id<DLNAScanDelegate>)delegate{
//    if (!_manager) {
//        _manager = [[DLNAPlatinumManager alloc] init];
//        _manager.delegate = self;
//        _delegate = delegate;
//    }
//    return _manager;
//}

#pragma mark- DLNAPlatinumDelegate
- (void)DLNAPlatinumManageer:(DLNAPlatinumManager *)manager findDevice:(DLNADeviceEntity *)device {
    [_delegate DLNAScanManager:self findDevice:device];
}

- (void)DLNAPlatinumManageer:(DLNAPlatinumManager *)manager removeDevice:(DLNADeviceEntity *)device {
    [_delegate DLNAScanManager:self removeDevice:device];
}

@end
