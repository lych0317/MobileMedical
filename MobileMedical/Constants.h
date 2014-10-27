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

#define QUERY_DEVICE_URL @"queryDevice"
#define QUERY_HOSPITAL_URL @"queryHospital"
#define QUERY_DOCTOR_URL @"queryDoctor"

#define ADD_FAMILY_URL @"addFamily"


// 血氧——1，血压——3，血糖——6，心电——2
typedef enum {
    DeviceTypeBloodOxy = 1,
    DeviceTypeETC = 2,
    DeviceTypeBloodPressure = 3,
    DeviceTypeBloodSugar = 6
} DeviceType;

#endif
