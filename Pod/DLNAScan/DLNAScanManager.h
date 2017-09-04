//
//  DLANScanManager.h
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLNADeviceEntity.h"

@class DLNAScanManager;

@protocol DLNAScanDelegate <NSObject>

- (void)DLNAScanManager:(DLNAScanManager *)manager findDevice:(DLNADeviceEntity *)device;
- (void)DLNAScanManager:(DLNAScanManager *)manager removeDevice:(DLNADeviceEntity *)device;

@end

@interface DLNAScanManager : NSObject

@property (nonatomic, weak ) id <DLNAScanDelegate> delegate;

- (void)startMediaControl;
- (void)stopMediaControll;

@end

