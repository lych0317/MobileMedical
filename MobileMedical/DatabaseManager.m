//
//  DatabaseManager.m
//  MobileMedical
//
//  Created by 远超李 on 14-10-26.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "DatabaseManager.h"
#import <FMDB/FMDatabase.h>
#import <FMDB/FMDatabaseQueue.h>
#import "AppModel.h"
#import "StaffModel.h"
#import "CollectionModel.h"

#define CHECK_RESULT if(!result){*rollback=YES;return;}

static DatabaseManager *sDatabaseManager = nil;

@interface DatabaseManager ()

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@end

@implementation DatabaseManager

+ (instancetype)sharedManager {
    if (sDatabaseManager == nil) {
        sDatabaseManager = [[DatabaseManager alloc] init];
    }
    return sDatabaseManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createTablesIfNotExists];
    }
    return self;
}

- (void)createTablesIfNotExists {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        db.logsErrors = YES;

        NSString *staffColumn = @" (identifier TEXT PRIMARY KEY, name TEXT, gender TEXT, relation TEXT, phone TEXT, birthday NUMERIC, payType TEXT, hospital TEXT, doctor TEXT)";
        NSString *collectionColumn = @" (identifier TEXT, type TEXT, device TEXT)";

        [db executeUpdate:[@"CREATE TABLE IF NOT EXISTS staff" stringByAppendingString:staffColumn]];
        [db executeUpdate:[@"CREATE TABLE IF NOT EXISTS collection" stringByAppendingString:collectionColumn]];
    }];
}

- (void)loadAllData {
    [self loadAllStaffModels];
}

- (void)loadAllStaffModels {
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *staffModels = [NSMutableArray array];
        FMResultSet *staffResultSet = [db executeQuery:@"SELECT * FROM staff"];
        while ([staffResultSet next]) {
            StaffModel *staffModel = [[StaffModel alloc] init];
            staffModel.identifier = [staffResultSet stringForColumnIndex:0];
            staffModel.name = [staffResultSet stringForColumnIndex:1];
            staffModel.gender = [staffResultSet stringForColumnIndex:2];
            staffModel.relation = [staffResultSet stringForColumnIndex:3];
            staffModel.phone = [staffResultSet stringForColumnIndex:4];
            staffModel.birthday = [staffResultSet dateForColumnIndex:5];
            staffModel.payType = [staffResultSet stringForColumnIndex:6];
            staffModel.hospital = [staffResultSet stringForColumnIndex:7];
            staffModel.doctor = [staffResultSet stringForColumnIndex:8];

            NSMutableArray *collectionModels = [NSMutableArray array];
            FMResultSet *collectionResultSet = [db executeQuery:@"SELECT * FROM collection WHERE identifier=?", staffModel.identifier];
            while ([collectionResultSet next]) {
                CollectionModel *collectionModel = [[CollectionModel alloc] init];
                collectionModel.collectionType = [collectionResultSet stringForColumnIndex:1];
                collectionModel.collectionDevice = [collectionResultSet stringForColumnIndex:2];
                [collectionModels addObject:collectionModel];
            }
            staffModel.collectionModels = collectionModels;

            [staffModels addObject:staffModel];
        }
        [AppModel sharedAppModel].staffModels = staffModels;
    }];
}

- (void)insertStaff:(StaffModel *)model {
    [self insertOrUpdateStaff:model];
}

- (void)updateStaff:(StaffModel *)model {
    [self insertOrUpdateStaff:model];
}

- (void)insertOrUpdateStaff:(StaffModel *)model {
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL result = [db executeUpdate:@"INSERT OR REPLACE INTO staff VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", model.identifier, model.name, model.gender, model.relation, model.phone, model.birthday, model.payType, model.hospital, model.doctor];
        if (result) {
            BOOL result = [db executeUpdate:@"DELETE FROM collection WHERE identifier=?", model.identifier];
            CHECK_RESULT
            [model.collectionModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                CollectionModel *collectionModel = obj;
                BOOL result = [db executeUpdate:@"INSERT OR REPLACE INTO collection VALUES (?, ?, ?)", model.identifier, collectionModel.collectionType, collectionModel.collectionDevice];
                CHECK_RESULT
            }];
        }
        CHECK_RESULT
    }];
}

- (void)deleteStaff:(StaffModel *)model {
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL result = [db executeUpdate:@"DELETE FROM staff WHERE identifier=?", model.identifier];
        CHECK_RESULT
        result = [db executeUpdate:@"DELETE FROM collection WHERE identifier=?", model.identifier];
        CHECK_RESULT
    }];
}

#pragma mark - Getters

- (FMDatabaseQueue *)databaseQueue {
    if (_databaseQueue == nil) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [documentPath stringByAppendingPathComponent:@"medical.cache"];
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return _databaseQueue;
}

@end
