//
//  DLNADeviceEntity.m
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//

#import "DLNADeviceEntity.h"

@implementation DLNADeviceEntity

-(instancetype)initWithName:(NSString *)name
                       UUID:(NSString *)uuid
               manufacturer:(NSString *)manufacturer
                  modelName:(NSString *)modelName
                modelNumber:(NSString *)modelNumber
               serialNumber:(NSString *)serialNumber
             descriptionURL:(NSString *)descriptionURL
{
    if (self = [super init]) {
        self.name = name;
        self.uuid = uuid;
        self.facturer = manufacturer;
        self.model = modelName;
        self.serialNumber = serialNumber;
        self.addr = descriptionURL;
    }
    return self;
}

@end
