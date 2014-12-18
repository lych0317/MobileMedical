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

@class UserModel, RegisterModel, HospitalModel, StaffModel, OtherDataModel, BloodSugarModel, ETCModel;

@interface ProtocolManager : NSObject

+ (instancetype)sharedManager;

- (void)postLoginWithUserModel:(UserModel *)userModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;
- (void)postRegisterWithRegisterModel:(RegisterModel *)registerModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;
- (void)postQueryHospitalWithSuccess:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;
- (void)postQueryDoctorWithHospital:(HospitalModel *)hospitalModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;
- (void)postStaffWithStaffModel:(StaffModel *)staffModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;
- (void)postUpdatePasswordWithOldPwd:(NSString *)oldPwd updatePwd:(NSString *)updatePwd success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;
- (void)postQueryStaffListWithSuccess:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;
- (void)postOtherDataWithOtherDataModel:(OtherDataModel *)otherDataModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;
- (void)postQueryBloodSugar:(NSDate *)date pId:(NSString *)pId success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;
- (void)postQueryETC:(NSDate *)date pId:(NSString *)pId success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;
- (void)postBloodSugarModel:(BloodSugarModel *)model success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;
- (void)postETCModel:(ETCModel *)model success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;





- (void)postQueryDeviceWithSuccess:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure;

@end
