//
//  Config.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "Config.h"
#import "Constants.h"

static Config *sConfig = nil;

@implementation Config

+ (instancetype)sharedConfig {
    if (sConfig == nil) {
        sConfig = [[Config alloc] init];
        sConfig.userfrom = @(2);
    }
    return sConfig;
}

- (void)setDoctorIds:(NSString *)doctorIds {
    _doctorIds = doctorIds;
    self.hospitalDoctorMap = nil;
}

- (NSDictionary *)hospitalDoctorMap {
    if (CHECK_STRING_NOT_NULL(self.doctorIds) && _hospitalDoctorMap == nil) {
        NSArray *hospitalAndDoctors = [self.doctorIds componentsSeparatedByString:@","];
        NSMutableDictionary *hospitalDoctorMap = [NSMutableDictionary dictionary];
        [hospitalAndDoctors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *hospitalAndDoctor = obj;
            NSString *hospital = [hospitalAndDoctor componentsSeparatedByString:@"#"][0];
            NSString *doctor = [hospitalAndDoctor componentsSeparatedByString:@"#"][1];
            [self addHospital:hospital doctor:doctor toMap:hospitalDoctorMap];
        }];
        _hospitalDoctorMap = hospitalDoctorMap;
    }
    return _hospitalDoctorMap;
}

- (void)addHospital:(NSString *)hospital doctor:(NSString *)doctor toMap:(NSMutableDictionary *)hospitalDoctorMap {
    NSMutableArray *doctors = hospitalDoctorMap[hospital];
    if (doctors == nil) {
        doctors = [NSMutableArray array];
    }
    [doctors addObject:doctor];
    [hospitalDoctorMap setObject:doctors forKey:hospital];
}

@end
