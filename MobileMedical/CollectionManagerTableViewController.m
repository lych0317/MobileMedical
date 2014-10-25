//
//  CollectionManagerTableViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/10/25.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "CollectionManagerTableViewController.h"
#import "AppModel.h"
#import "StaffModel.h"
#import "CollectionModel.h"

@interface CollectionManagerTableViewController ()

@property (nonatomic, strong) NSMutableDictionary *selectedIndexPathMap;

@end

@implementation CollectionManagerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [AppModel sharedAppModel].collectionTypeTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AppModel sharedAppModel].collectionDeviceTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = [AppModel sharedAppModel].collectionDeviceTitles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [self.staffModel.collectionModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CollectionModel *model = obj;
        if ([model.collectionDevice isEqualToString:cell.textLabel.text]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectedIndexPathMap setObject:indexPath forKey:[NSString stringWithFormat:@"%d", indexPath.section]];
            *stop = YES;
        }
    }];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [AppModel sharedAppModel].collectionTypeTitles[section];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionKey = [NSString stringWithFormat:@"%d", indexPath.section];
    NSIndexPath *selectedIndexPath = self.selectedIndexPathMap[sectionKey];
    if (selectedIndexPath) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (selectedIndexPath == nil || [selectedIndexPath compare:indexPath] != NSOrderedSame) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedIndexPathMap setObject:indexPath forKey:sectionKey];
    } else if ([selectedIndexPath compare:indexPath] == NSOrderedSame) {
        [self.selectedIndexPathMap removeObjectForKey:sectionKey];
    }
}

#pragma mark - Getters

- (NSMutableDictionary *)selectedIndexPathMap {
    if (_selectedIndexPathMap == nil) {
        _selectedIndexPathMap = [NSMutableDictionary dictionaryWithCapacity:[AppModel sharedAppModel].collectionTypeTitles.count];
    }
    return _selectedIndexPathMap;
}

@end
