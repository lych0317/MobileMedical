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
#import "UserModel.h"
#import "LoginResult.h"
#import "Constants.h"

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

- (void)postLoginWithUserModel:(UserModel *)userModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    RKObjectMapping *requestMapping = [self createUserModelMapping];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[UserModel class] rootKeyPath:nil method:RKRequestMethodPOST];

    RKObjectMapping *responseMapping = nil;
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    [manager addRequestDescriptor:requestDescriptor];
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

- (RKObjectMapping *)createUserModelMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[UserModel class]];
    [mapping addAttributeMappingsFromDictionary:@{@"username": @"name",
                                                  @"password": @"password"
                                                  }];
    return mapping;
}

- (void)postQueryDeviceWithSuccess:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    RKObjectMapping *requestMapping = nil;
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:nil rootKeyPath:nil method:RKRequestMethodPOST];

    RKObjectMapping *responseMapping = nil;
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    [manager addRequestDescriptor:requestDescriptor];
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

- (void)postQueryHospitalWithSuccess:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {

}

- (void)postQueryDoctorWithHospital:(HospitalModel *)hospitalModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {

}

@end
