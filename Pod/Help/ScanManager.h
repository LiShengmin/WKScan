//
//  ScanManager.h
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceEntity.h"

@class ScanManager;
@protocol ScanDeviceDelegate <NSObject>

- (void)scanManager:(ScanManager *)manager upDateWithAllDevice:(NSArray <DeviceEntity *>*)devices;

@end

@interface ScanManager : NSObject

+ (ScanManager *)manager;

@property (nonatomic, weak) id<ScanDeviceDelegate> delegate;

- (void)statrScan;
- (void)stopScan;

@end
