//
//  DLNAPlatinumManager.h
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLNAPlatinumManager;
@class DLNADeviceEntity;

@protocol DLNAPlatinumDelegate <NSObject>

- (void)DLNAPlatinumManageer:(DLNAPlatinumManager *)manager findDevice:(DLNADeviceEntity *)device;
- (void)DLNAPlatinumManageer:(DLNAPlatinumManager *)manager removeDevice:(DLNADeviceEntity *)device;

@end
@interface DLNAPlatinumManager : NSObject

@property (nonatomic, weak) id<DLNAPlatinumDelegate> delegate;

- (void)startMediaControl;
- (void)reStartMediaControll;
- (void)stopMediaControll;


#pragma mark- Prative
- (void)finded_device;
- (void)remove_device;

@end
