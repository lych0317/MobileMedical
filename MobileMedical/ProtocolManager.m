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
#import "DeviceModel.h"
#import "QueryDeviceResult.h"
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

- (void)setupHeaderWithManager:(RKObjectManager *)manager {
    [manager.HTTPClient setDefaultHeader:@"access_token" value:@"cmn0sb6wq0v6zjx2ief64l9p4kxhdej28stt"];
    [manager.HTTPClient setDefaultHeader:@"pId" value:@"110108197610286325"];
    [manager.HTTPClient setDefaultHeader:@"Accept-Encoding" value:@"gzip, deflate"];
}

- (void)postLoginWithUserModel:(UserModel *)userModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    RKObjectMapping *requestMapping = [self createLoginRequestMapping];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[UserModel class] rootKeyPath:nil method:RKRequestMethodPOST];

    RKObjectMapping *responseMapping = [self createLoginResponseMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
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
    [mapping addAttributeMappingsFromDictionary:@{@"name": @"username", @"password": @"password"}];
    return mapping;
}

- (RKObjectMapping *)createLoginResponseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[LoginResult class]];
    [mapping addAttributeMappingsFromDictionary:@{@"return_code": @"code", @"access_token": @"token", @"pId": @"identifier"}];
    return mapping;
}

- (void)postQueryDeviceWithSuccess:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
//    RKObjectMapping *requestMapping = nil;
//    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:nil rootKeyPath:nil method:RKRequestMethodPOST];

    RKObjectMapping *responseMapping = [self createQueryDeviceResponseMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[AppModel sharedAppModel].baseUrl];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
//    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];

    [manager getObjectsAtPath:QUERY_DEVICE_URL parameters:@{@"access_token": @"cmn0sb6wq0v6zjx2ief64l9p4kxhdej28stt", @"pId": @"110108197610286325"} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success(mappingResult.firstObject);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];

//    [manager postObject:nil path:QUERY_DEVICE_URL parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        if (success) {
//            success(mappingResult.firstObject);
//        }
//    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(operation, error);
//        }
//    }];
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

- (void)postQueryHospitalWithSuccess:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {

}

- (void)postQueryDoctorWithHospital:(HospitalModel *)hospitalModel success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {

}

@end
