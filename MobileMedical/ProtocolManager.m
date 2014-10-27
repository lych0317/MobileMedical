//
//  ProtocolManager.m
//  MobileMedical
//
//  Created by 远超李 on 14-10-27.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "ProtocolManager.h"

static ProtocolManager *sProtocolManager = nil;

@implementation ProtocolManager

+ (instancetype)sharedManager {
    if (sProtocolManager == nil) {
        sProtocolManager = [[ProtocolManager alloc] init];
    }
    return sProtocolManager;
}

@end
