//
//  StorageProvider.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/3/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "StorageProvider.h"

#import "FileSystemHelper.h"

static StorageProvider *instance = nil;

@implementation StorageProvider

#pragma mark -
#pragma mark Dealloc

- (void) dealloc {
    [managedObjectContext release];
    [managedObjectModel release];
    [persistantStorageCoordinator release];
    
	[super dealloc];
}

#pragma mark -
#pragma mark Singleton Futures

+ (StorageProvider*)sharedInstance { 
	@synchronized (self) {
		if (instance == nil) instance = [[self alloc] init];
	}
	
	return instance;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self)
	{
		if (instance == nil)
		{
			instance = [super allocWithZone:zone];
			return instance;
		}
	}
	return nil;
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)retain {
	return self;
}
- (NSUInteger)retainCount {
	return NSUIntegerMax;
}
- (oneway void)release {    
}
- (id)autorelease {
	return self;
}

#pragma mark -
#pragma mark Init

- (id) init {
	if (self = [super init]) {

	}
	return self;
}

#pragma mark -
#pragma mark Core Data stack

- (NSManagedObjectContext *)managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistantStorageCoordinator];
    if (coordinator != nil) 
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
        [managedObjectContext setMergePolicy:NSOverwriteMergePolicy];
    }
    return managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistantStorageCoordinator {
    
    if (persistantStorageCoordinator != nil) {
        return persistantStorageCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[FileSystemHelper applicationDocumentDirectory] stringByAppendingPathComponent: @"MainData.bin"]];
    
    NSError *error = nil;
    persistantStorageCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistantStorageCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }    
    
    return persistantStorageCoordinator;
}

#pragma mark -
#pragma mark CoreData Operations

- (void) lockedSave {
    [self.managedObjectContext lock];
    [self saveBase];
    [self.managedObjectContext unlock];
}

- (void) doSaveInBackground {
	[self performSelectorInBackground:@selector(lockedSave) withObject:nil];
}

- (void) delayedSaveInBackground {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doSaveInBackground) object:nil];
	[self performSelector:@selector(doSaveInBackground) withObject:nil afterDelay:kManagedObjectContextDelayedSaveInterval];
}

- (void)saveBase {
    NSError *error = nil;
    if (self.managedObjectContext != nil) {
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        } 
    }
}
- (void)addEntry:(NSManagedObject *)object {
    NSManagedObjectContext * context = [[StorageProvider sharedInstance] managedObjectContext];  
    
    NSError * error;
    [context insertObject:object]; 
    [context save:&error];
}
- (NSArray*)allEntities:(NSString *)name {
    NSManagedObjectContext * context = [[StorageProvider sharedInstance] managedObjectContext];  
    
    NSFetchRequest * request = [[[NSFetchRequest alloc] init] autorelease];  
    [request setEntity:[NSEntityDescription entityForName:name inManagedObjectContext:context]];  
    
    NSError * error;
    // Получаем результат  
    NSArray * result = [context executeFetchRequest:request error:&error];
    return result;
}

#pragma mark -
#pragma mark MultyThread CoreData

+ (NSManagedObjectContext *)threadSafeContext {
    NSManagedObjectContext * context = nil;
    NSPersistentStoreCoordinator *coordinator = [[[self class] sharedInstance] persistantStorageCoordinator];
    
    if (coordinator != nil) {
        context = [[[NSManagedObjectContext alloc] init] autorelease];
        [context setPersistentStoreCoordinator:coordinator];
        [context setMergePolicy:NSOverwriteMergePolicy];
        [context setUndoManager:nil];
    }
    
    return context;
}
+ (void)saveContext:(NSManagedObjectContext*)context {
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) { 
        NSDictionary * dict  = [error userInfo]; 
        NSArray * detailedErrors = [dict objectForKey:NSDetailedErrorsKey];

        if (detailedErrors) {  
            for (NSError * detailedError in detailedErrors) {  
                NSLog(@"Error detail : %@", [detailedError userInfo]);  
            }  
        } else {
            NSLog(@"Error description %@ ", [error description]);
        } 
    }
}

- (void)mergeChanges:(NSNotification *)notification {
    NSManagedObjectContext *currentContext = (NSManagedObjectContext *)[notification object];
    if (currentContext == self.managedObjectContext) {
        [currentContext performSelector:@selector(mergeChangesFromContextDidSaveNotification:) 
                               onThread:[NSThread currentThread] 
                             withObject:notification 
                          waitUntilDone:NO];
    } else {
        [self.managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                                    withObject:notification 
                                                 waitUntilDone:YES];
    }
}

@end
