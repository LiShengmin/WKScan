//
//  DLNADeviceEntity.h
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLNADeviceEntity : NSObject

@property (nonatomic, strong) NSString * name;          //  设备名称
@property (nonatomic, strong) NSString * uuid;          //  UUID
@property (nonatomic, strong) NSString * model;         //  型号名称
@property (nonatomic, strong) NSString * addr;          //  设备地址  ip + port
@property (nonatomic, strong) NSString * facturer;      //  生产商
@property (nonatomic, strong) NSString * serialNumber;  //  设备串号


-(instancetype)initWithName:(NSString *)name
                       UUID:(NSString *)uuid
               manufacturer:(NSString *)manufacturer
                  modelName:(NSString *)modelName
                modelNumber:(NSString *)modelNumber
               serialNumber:(NSString *)serialNumber
             descriptionURL:(NSString *)descriptionURL;
@end
