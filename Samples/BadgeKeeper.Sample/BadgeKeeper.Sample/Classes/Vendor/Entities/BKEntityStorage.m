//
//  BKEntityStorage.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 29.09.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import "BKEntityStorage.h"

#import <CoreData/CoreData.h>

#import "BKEntityRewards.h"

// Table names
NSString *const kBKEntityTableNameRewards = @"BKEntityRewards";

@interface BKEntityStorage ()

#pragma mark - Core Data

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation BKEntityStorage

@synthesize managedObjectContext       = _managedObjectContext;
@synthesize managedObjectModel         = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - Root

- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialization
        [self managedObjectContext];
    }
    return self;
}


#pragma mark - Core Data

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        }
    }
}

- (NSURL *)applicationDocumentsDirectory {
    NSArray<NSURL *> *urls = [[NSFileManager defaultManager]
                              URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return [urls lastObject];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BadgeKeeper" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *url = [[self applicationDocumentsDirectory] URLByAppendingPathComponent: @"BadgeKeeper.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:url
                                                         options:nil
                                                           error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSArray *)getEntitiesFromTable:(NSString *)table withPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequestList = [[NSFetchRequest alloc] init];
    [fetchRequestList setEntity:[NSEntityDescription
                                 entityForName:table
                                 inManagedObjectContext:self.managedObjectContext]];
    [fetchRequestList setPredicate: predicate];
    [fetchRequestList setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequestList error:&error];
    return result;
}


#pragma mark - General

- (BOOL)saveRewardValueForName:(NSString *)name withValue:(double)value {
    BKEntityRewards *entity = [NSEntityDescription
                               insertNewObjectForEntityForName:kBKEntityTableNameRewards
                               inManagedObjectContext:self.managedObjectContext];
    if (entity == nil)
    {
        return NO;
    }

    entity.name = name;
    entity.value = [NSNumber numberWithDouble:value];
    [self saveContext];
    
    return YES;
}

- (NSArray *)readRewardValuesForName:(NSString *)name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    NSArray *array = [self getEntitiesFromTable:kBKEntityTableNameRewards withPredicate:predicate];
    return array;
}

@end
