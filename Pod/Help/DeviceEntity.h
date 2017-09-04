//
//  DeviceEntity.h
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, DeviceEntityScanType) {
    DeviceEntityScanTypeUnKnow      = 0,
    DeviceEntityScanTypeServise     = 1<<0,
    DeviceEntityScanTypeControll    = 1<<1,
    DeviceEntityScanTypeSDK         = 1<<2,
    DeviceEntityScanTypeADB         = 1<<3,
    DeviceEntityScanTypeInstall     = 1<<4,
    DeviceEntityScanTypeDLNA        = 1<<5,
    DeviceEntityScanTypeGoogleCsat  = 1<<6,
    DeviceEntityScanTypeFireTV      = 1<<7,
};

@interface DeviceEntity : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * ip;
@property (nonatomic, strong) NSArray * ports;
@property (nonatomic, assign) DeviceEntityScanType type;

+ (DeviceEntity *)deviceWithName:(NSString *)name ip:(NSString *)ip ports:(NSArray *)ports type:(DeviceEntityScanType)type;

@end
