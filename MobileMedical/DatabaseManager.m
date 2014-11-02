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
#import "ETCModel.h"
#import "BloodSugarModel.h"

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
        NSString *etcColumn = @" (identifier INTEGER PRIMARY KEY AUTOINCREMENT, simple INTEGER, status INTEGER, bpm INTEGER, ecg BLOB, date TEXT, time TEXT)";
        NSString *bloodSugarColumn = @" (identifier INTEGER PRIMARY KEY AUTOINCREMENT, type INTEGER, simple INTEGER, style INTEGER, value REAL, date TEXT, time TEXT)";

        [db executeUpdate:[@"CREATE TABLE IF NOT EXISTS staff" stringByAppendingString:staffColumn]];
        [db executeUpdate:[@"CREATE TABLE IF NOT EXISTS collection" stringByAppendingString:collectionColumn]];
        [db executeUpdate:[@"CREATE TABLE IF NOT EXISTS etc" stringByAppendingString:etcColumn]];
        [db executeUpdate:[@"CREATE TABLE IF NOT EXISTS blood_sugar" stringByAppendingString:bloodSugarColumn]];
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

- (void)loadETCWith:(NSString *)date {
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *etcModels = [NSMutableArray array];
        FMResultSet *etcResultSet = [db executeQuery:@"SELECT * FROM etc WHERE date=?", date];
        while ([etcResultSet next]) {
            ETCModel *etcModel = [[ETCModel alloc] init];
            etcModel.identifier = [NSNumber numberWithInt:[etcResultSet intForColumnIndex:0]];
            etcModel.isSimpleTestModel = [NSNumber numberWithBool:[etcResultSet boolForColumnIndex:1]];
            etcModel.status = [NSNumber numberWithInt:[etcResultSet intForColumnIndex:2]];
            etcModel.bpm = [NSNumber numberWithInt:[etcResultSet intForColumnIndex:3]];
            etcModel.ecgData = [etcResultSet dataForColumnIndex:4];
            etcModel.date = [etcResultSet stringForColumnIndex:5];
            etcModel.time = [etcResultSet stringForColumnIndex:6];
            [etcModels addObject:etcModel];
        }
        [AppModel sharedAppModel].etcModels = etcModels;
    }];
}

- (void)insertETC:(ETCModel *)model {
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL result = [db executeUpdate:@"INSERT OR REPLACE INTO etc VALUES (?, ?, ?, ?, ?, ?)", model.isSimpleTestModel, model.status, model.bpm, model.ecgData, model.date, model.time];
        CHECK_RESULT
    }];
}

- (void)loadBloodSugar:(NSString *)date {
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *bloodSugarModels = [NSMutableArray array];
        FMResultSet *bloodSugarSet = [db executeQuery:@"SELECT * FROM blood_sugar WHERE date=?", date];
        while ([bloodSugarSet next]) {
            BloodSugarModel *bloodSugarModel = [[BloodSugarModel alloc] init];
            bloodSugarModel.identifier = [NSNumber numberWithInt:[bloodSugarSet intForColumnIndex:0]];
            bloodSugarModel.testType = [NSNumber numberWithInt:[bloodSugarSet intForColumnIndex:1]];
            bloodSugarModel.isSimpleTestModel = [NSNumber numberWithBool:[bloodSugarSet boolForColumnIndex:2]];
            bloodSugarModel.style = [NSNumber numberWithInt:[bloodSugarSet intForColumnIndex:3]];
            bloodSugarModel.value = [NSNumber numberWithFloat:[bloodSugarSet doubleForColumnIndex:4]];
            bloodSugarModel.date = [bloodSugarSet stringForColumnIndex:5];
            bloodSugarModel.time = [bloodSugarSet stringForColumnIndex:6];
            [bloodSugarModels addObject:bloodSugarModel];
        }
        [AppModel sharedAppModel].bloodSugarModels = bloodSugarModels;
    }];
}

- (void)insertBloodSugar:(BloodSugarModel *)model {
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL result = [db executeUpdate:@"INSERT OR REPLACE INTO blood_sugar VALUES (?, ?, ?, ?, ?, ?)", model.testType, model.isSimpleTestModel, model.style, model.value, model.date, model.time];
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
