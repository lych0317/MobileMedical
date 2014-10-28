//
//  ProtocolManager.h
//  MobileMedical
//
//  Created by 远超李 on 14-10-27.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectRequestOperation;

typedef void(^ProtocolSuccessBlock)(id data);
typedef void(^ProtocolFailureBlock)(RKObjectRequestOperation *operation, NSError *error);

@class UserModel, HospitalModel;

@interface ProtocolManager : NSObject

+ (instancetype)sharedManager;

- (void)postLoginWithUserModel:(UserModel *)userModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;

- (void)postQueryDeviceWithSuccess:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;
- (void)postQueryHospitalWithSuccess:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;
- (void)postQueryDoctorWithHospital:(HospitalModel *)hospitalModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;

@end
