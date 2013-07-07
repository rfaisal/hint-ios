//
//  EntityProvider.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/9/11.
//  Copyright 2011 YAS. All rights reserved.
//
    
@interface EntityProvider : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSString *entityName;

+ (id)sharedProvider;

- (NSUInteger)entityesCount;

- (NSManagedObject*)addNewObject;
- (NSManagedObject*)addNewObjectInContext:(NSManagedObjectContext*)context;

- (void)clearWithError:(NSError **)error;
- (void)deleteObject:(NSManagedObject *)object;

- (NSManagedObject*)objectByObjectID:(NSManagedObjectID *)objectID;

- (NSManagedObject*)modelByID:(NSString*)uid context:(NSManagedObjectContext*)context;
- (BOOL)deleteModelByID:(NSString*)uid context:(NSManagedObjectContext*)context ;
- (void)deleteChild:(NSManagedObject*)parent;

@end