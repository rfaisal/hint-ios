//
//  StorageProvider.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/3/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface StorageProvider : NSObject {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistantStorageCoordinator;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistantStorageCoordinator;

+ (StorageProvider*)sharedInstance;

+ (NSManagedObjectContext*)threadSafeContext;
+ (void)saveContext:(NSManagedObjectContext*)context;
- (void)mergeChanges:(NSNotification *)notification;

- (void)delayedSaveInBackground;
- (void)saveBase;
- (void)addEntry:(NSManagedObject *)object;
- (NSArray*)allEntities:(NSString *)name;

@end
