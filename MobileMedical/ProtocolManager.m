//
//  ProtocolManager.m
//  MobileMedical
//
//  Created by 远超李 on 14-10-27.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "ProtocolManager.h"
#import <RestKit/RestKit.h>
#import "AppModel.h"
#import "BaseResult.h"
#import "UserModel.h"
#import "DeviceModel.h"
#import "QueryDeviceResult.h"
#import "HospitalModel.h"
#import "QueryHospitalResult.h"
#import "DoctorModel.h"
#import "QueryDoctorResult.h"
#import "LoginResult.h"
#import "RegisterModel.h"
#import "RegisterResult.h"
#import "StaffModel.h"
#import "QueryStaffListResult.h"
#import "OtherDataModel.h"
#import "OperatingStaff.h"
#import "BloodSugarModel.h"
#import "BloodSugarResult.h"
#import "ETCModel.h"
#import "ETCResult.h"
#import "BloodSugarModel.h"
#import "Constants.h"
#import "Config.h"
#import "Utils.h"

static ProtocolManager *sProtocolManager = nil;

@implementation ProtocolManager

+ (instancetype)sharedManager {
    if (sProtocolManager == nil) {
        sProtocolManager = [[ProtocolManager alloc] init];
    }
    return sProtocolManager;
}

- (NSIndexSet *)createStatusCodes {
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    [indexSet addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [indexSet addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    [indexSet addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassServerError)];
    return indexSet;
}

- (void)setupHeaderWithManager:(RKObjectManager *)manager {
    [manager.HTTPClient setDefaultHeader:@"Accept-Encoding" value:@"gzip, deflate"];
}

- (void)postLoginWithUserModel:(UserModel *)userModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    RKObjectMapping *requestMapping = [self createLoginRequestMapping];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[UserModel class] rootKeyPath:nil method:RKRequestMethodPOST];

    RKObjectMapping *responseMapping = [self createLoginResponseMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    [self setupHeaderWithManager:manager];

    [manager postObject:userModel path:LOGIN_URL parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (RKObjectMapping *)createLoginRequestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"username", @"password"]];
    return mapping;
}

- (RKObjectMapping *)createLoginResponseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[LoginResult class]];
    [mapping addAttributeMappingsFromArray:@[@"return_code", @"access_token", @"usertype", @"pId", @"name", @"chengwei", @"phone", @"doctorIds", @"paytype"]];
    return mapping;
}

- (void)postRegisterWithRegisterModel:(RegisterModel *)registerModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    RKObjectMapping *requestMapping = [self createRegisterRequestMapping];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[RegisterModel class] rootKeyPath:nil method:RKRequestMethodPOST];

    RKObjectMapping *responseMapping = [self createRegisterResponseMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    [self setupHeaderWithManager:manager];

    [manager postObject:registerModel path:REGISTER_URL parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (RKObjectMapping *)createRegisterRequestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"username", @"password", @"userfrom", @"name", @"intro", @"pId", @"phone"]];
    return mapping;
}

- (RKObjectMapping *)createRegisterResponseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RegisterResult class]];
    [mapping addAttributeMappingsFromArray:@[@"return_code", @"access_token"]];
    return mapping;
}

- (void)postQueryHospitalWithSuccess:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    RKObjectMapping *responseMapping = [self createQueryHospitalResponseMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    [manager addResponseDescriptor:responseDescriptor];

    NSDictionary *parameters = @{@"access_token": [Config sharedConfig].access_token};

    [manager postObject:nil path:QUERY_HOSPITAL_URL parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (RKObjectMapping *)createQueryHospitalResponseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[QueryHospitalResult class]];
    [mapping addAttributeMappingsFromArray:@[@"return_code"]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"hospitals" toKeyPath:@"hospitals" withMapping:[self createHospitalModelMapping]]];
    return mapping;
}

- (RKObjectMapping *)createHospitalModelMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[HospitalModel class]];
    [mapping addAttributeMappingsFromArray:@[@"name", @"hospitalId"]];
    return mapping;
}

- (void)postQueryDoctorWithHospital:(HospitalModel *)hospitalModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    RKObjectMapping *responseMapping = [self createQueryDoctorResponseMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    [manager addResponseDescriptor:responseDescriptor];

    NSDictionary *parameters = @{@"access_token": [Config sharedConfig].access_token, @"hospitalId": hospitalModel.hospitalId};

    [manager postObject:nil path:QUERY_DOCTOR_URL parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (RKObjectMapping *)createQueryDoctorResponseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[QueryDoctorResult class]];
    [mapping addAttributeMappingsFromArray:@[@"return_code"]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"doctors" toKeyPath:@"doctors" withMapping:[self createDoctorModelMapping]]];
    return mapping;
}

- (RKObjectMapping *)createDoctorModelMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[DoctorModel class]];
    [mapping addAttributeMappingsFromArray:@[@"name", @"doctorId"]];
    return mapping;
}

- (void)postStaffWithStaffModel:(StaffModel *)staffModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    RKObjectMapping *requestMapping = [self createAddOrUpdateStaffRequestMapping];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[StaffModel class] rootKeyPath:nil method:RKRequestMethodPOST];

    RKObjectMapping *responseMapping = [self createBaseResponseMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    [self setupHeaderWithManager:manager];

    NSDictionary *parameters = @{@"access_token": [Config sharedConfig].access_token};

    [manager postObject:staffModel path:ADD_OR_UPDATE_STAFF_URL parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (RKObjectMapping *)createAddOrUpdateStaffRequestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"username", @"password", @"pId", @"name", @"chengwei", @"phone", @"doctorIds", @"paytype", @"opr"]];
    return mapping;
}

- (RKObjectMapping *)createBaseResponseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[BaseResult class]];
    [mapping addAttributeMappingsFromArray:@[@"return_code"]];
    return mapping;
}

- (void)postUpdatePasswordWithOldPwd:(NSString *)oldPwd updatePwd:(NSString *)updatePwd success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    RKObjectMapping *responseMapping = [self createBaseResponseMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    [manager addResponseDescriptor:responseDescriptor];

    NSDictionary *parameters = @{@"access_token": [Config sharedConfig].access_token, @"oldPswd": oldPwd, @"newPswd": updatePwd};

    [manager postObject:nil path:UPDATE_GROUP_PWD_URL parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (void)postQueryStaffListWithSuccess:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    RKObjectMapping *responseMapping = [self createQueryStaffListResponseMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    [manager addResponseDescriptor:responseDescriptor];

    NSDictionary *parameters = @{@"access_token": [Config sharedConfig].access_token};

    [manager postObject:nil path:QUERY_STAFF_LIST_URL parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (RKObjectMapping *)createQueryStaffListResponseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[QueryStaffListResult class]];
    [mapping addAttributeMappingsFromArray:@[@"return_code"]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"patients" toKeyPath:@"patients" withMapping:[self createStaffModelMapping]]];
    return mapping;
}

- (RKObjectMapping *)createStaffModelMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[StaffModel class]];
    [mapping addAttributeMappingsFromArray:@[@"username", @"password", @"pId", @"name", @"chengwei", @"phone", @"doctorIds", @"paytype", @"opr"]];
    return mapping;
}

- (void)postOtherDataWithOtherDataModel:(OtherDataModel *)otherDataModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    RKObjectMapping *requestMapping = [self createOtherDataRequestMapping];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[OtherDataModel class] rootKeyPath:nil method:RKRequestMethodPOST];

    RKObjectMapping *responseMapping = [self createBaseResponseMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    [self setupHeaderWithManager:manager];

    NSDictionary *parameters = @{@"access_token": [Config sharedConfig].access_token};

    [manager postObject:otherDataModel path:UPLOAD_OTHER_DATA_URL parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (RKObjectMapping *)createOtherDataRequestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"datatype", @"datetime", @"value", @"pId"]];
    return mapping;
}

- (void)postQueryBloodSugar:(NSDate *)date pId:(NSString *)pId success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    RKObjectMapping *responseMapping = [self createBloodSugarResultMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    [manager addResponseDescriptor:responseDescriptor];
    [self setupHeaderWithManager:manager];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    NSDictionary *parameters = @{@"date": [formatter stringFromDate:date], @"pId": pId};

    [manager postObject:nil path:QUERY_BLOOD_SUGAR parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (RKObjectMapping *)createBloodSugarResultMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[BloodSugarResult class]];
    [mapping addAttributeMappingsFromArray:@[@"return_code"]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"sugars" toKeyPath:@"sugars" withMapping:[self createBloodSugarModelMapping]]];
    return mapping;
}

- (RKObjectMapping *)createBloodSugarModelMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[BloodSugarModel class]];
    [mapping addAttributeMappingsFromArray:@[@"value", @"type", @"mac", @"date"]];
    return mapping;
}

- (void)postQueryETC:(NSDate *)date pId:(NSString *)pId success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    RKObjectMapping *responseMapping = [self createETCResultMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    [manager addResponseDescriptor:responseDescriptor];
    [self setupHeaderWithManager:manager];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    NSDictionary *parameters = @{@"date": [formatter stringFromDate:date], @"pId": pId};

    [manager postObject:nil path:QUERY_ETC parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (RKObjectMapping *)createETCResultMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ETCResult class]];
    [mapping addAttributeMappingsFromArray:@[@"return_code"]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ecgs" toKeyPath:@"ecgs" withMapping:[self createETCModelMapping]]];
    return mapping;
}

- (RKObjectMapping *)createETCModelMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ETCModel class]];
    [mapping addAttributeMappingsFromArray:@[@"pulse", @"ecg", @"mac", @"date"]];
    return mapping;
}

- (void)postBloodSugarModel:(BloodSugarModel *)model success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    RKObjectMapping *responseMapping = [self createBaseResponseMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    [manager addResponseDescriptor:responseDescriptor];
    [self setupHeaderWithManager:manager];

    NSDictionary *parameters = @{@"access_token": [Config sharedConfig].access_token, @"type": model.type, @"value": model.value, @"date": model.date, @"mac": @"44:45:53:54:00:00", @"pId": model.pId};

    [manager postObject:nil path:UPLOAD_BLOOD_SUGAR parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}










- (void)postQueryDeviceWithSuccess:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    RKObjectMapping *responseMapping = [self createQueryDeviceResponseMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    [manager addResponseDescriptor:responseDescriptor];

    [manager postObject:nil path:QUERY_DEVICE_URL parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (RKObjectMapping *)createQueryDeviceResponseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[QueryDeviceResult class]];
    [mapping addAttributeMappingsFromDictionary:@{@"return_code": @"code"}];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"instruments" toKeyPath:@"instruments" withMapping:[self createDeviceModelMapping]]];
    return mapping;
}

- (RKObjectMapping *)createDeviceModelMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[DeviceModel class]];
    [mapping addAttributeMappingsFromDictionary:@{@"type": @"deviceType", @"mac": @"macAddress", @"img_url": @"imageUrl", @"name": @"name", @"company": @"company", @"info": @"information", @"typeForCorrespondWithPhone": @"transferType"}];
    return mapping;
}





@end
