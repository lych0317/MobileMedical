//
//  Constants.h
//  MobileMedical
//
//  Created by 远超李 on 14-10-23.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#ifndef MobileMedical_Constants_h
#define MobileMedical_Constants_h

#define BASE_URL @"http://beijingsny.eicp.net:91/healthmoni/"

#define LOGIN_URL @"checkLogin"
#define REGISTER_URL ([[Config sharedConfig].usertype intValue] == 1 ? @"groupReg" : @"patientReg")
#define QUERY_HOSPITAL_URL @"queryHospital"
#define QUERY_DOCTOR_URL @"queryDoctor"
#define ADD_OR_UPDATE_STAFF_URL @"addOrUpdatePatient"
#define UPDATE_GROUP_PWD_URL @"updateGroupPwd"
#define QUERY_STAFF_LIST_URL @"queryPatients"
#define UPLOAD_OTHER_DATA_URL @"uploadOtherData"
#define QUERY_BLOOD_SUGAR @"queryBloodSugar"
#define QUERY_ETC @"queryETC"

#define QUERY_DEVICE_URL @"queryDevice"

#define ADD_FAMILY_URL @"addFamily"

#define CHECK_STRING_NOT_NULL(string) (string != nil && string.length > 0)

typedef enum {
    OperationTypeDisplay,
    OperationTypeCollection
} OperationType;

typedef enum {
    TestTypeDevice,
    TestTypeOther
} TestType;

// 血氧——1，血压——3，血糖——6，心电——2
typedef enum {
    DeviceTestTypeBloodOxy = 1,
    DeviceTestTypeETC = 2,
    DeviceTestTypeBloodPressure = 3,
    DeviceTestTypeBloodSugar = 6
} DeviceTestType;

//@"膳食", @"运动量", @"服药", @"抽烟", @"饮酒", @"精神状态"
typedef enum {
    OtherTestTypeDiet = 1,
    OtherTestTypeSport,
    OtherTestTypeMedicine,
    OtherTestTypeSmoke,
    OtherTestTypeDrink,
    OtherTestTypeSpirit
} OtherTestType;

//@"无压力", @"轻微", @"中等", @"严重", @"非常严重"
typedef enum {
    SpiritTypeOne = 1,
    SpiritTypeTwo,
    SpiritTypeThree,
    SpiritTypeFour,
    SpiritTypeFive
} SpiritType;

typedef enum {
    BloodSugarTestTypeEmptyStomach = 1,
    BloodSugarTestTypeBeforMeal,
    BloodSugarTestTypeAfterMeal2h,
    BloodSugarTestTypeRandom
} BloodSugarTestType;

#endif
