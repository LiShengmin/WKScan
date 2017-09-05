//
//  DLNADeviceEntity.h
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLNADeviceEntity : NSObject

@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * uuid;          //  UUID

@property (nonatomic, strong) NSString * ip;
@property (nonatomic, strong) NSString * addr;          //  设备地址  http://ip + port/

@property (nonatomic, strong) NSString * name;          //  设备名称
@property (nonatomic, strong) NSString * facturer;      //  生产商
@property (nonatomic, strong) NSString * modelName;     //  设备串号

- (instancetype)initWithid:(NSString *)ID
                     UUID:(NSString *)uuid
                       ip:(NSString *)ip
                     addr:(NSString *)addr
                     name:(NSString *)name
                 facturer:(NSString *)facturer
                modelName:(NSString *)modelName;

- (NSString *)getPort;
@end
