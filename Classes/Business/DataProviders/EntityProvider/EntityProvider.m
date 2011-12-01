//
//  EntityProvider.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/9/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "EntityProvider.h"

#import "StorageProvider.h"

@implementation EntityProvider

#pragma mark Static Constructor

+ (id)sharedProvider {
    return nil;
}

#pragma mark ReadOnly

- (NSManagedObjectContext *)managedObjectContext {
    return [StorageProvider sharedInstance].managedObjectContext;
}
- (NSString *)entityName {
    return @"<Empty Entity>";
}

#pragma mark Common functions

- (NSUInteger)entityesCount {
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entityDescription];
    [request setResultType:NSManagedObjectIDResultType];
    
    NSError *error = nil;
    
    return [self.managedObjectContext countForFetchRequest:request error:&error];
}

- (NSManagedObject *)addNewObject {
    return [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
}
- (NSManagedObject *)addNewObjectInContext:(NSManagedObjectContext*)context {
    return [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:context];
}


- (void)clearWithError:(NSError **)error {
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entityDescription];
    
    if (entityDescription) {
        NSArray *array = [self.managedObjectContext executeFetchRequest:request error:error];

        if (*error) {
            NSLog(@"No such entity: %@", self.entityName);
            NSLog(@"Unresolved error %@, %@", *error, [*error userInfo]);
            return;
        }
        
        for (NSManagedObject *object in array) {
            [self.managedObjectContext deleteObject:object];
        }
        
        [self.managedObjectContext save:error];
    }
}
- (void)deleteObject:(NSManagedObject *)object {
    NSError *error = nil;
    
    [self.managedObjectContext deleteObject:object];
    
    [self.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (NSManagedObject *)objectByObjectID:(NSManagedObjectID *)objectID {
    return [self.managedObjectContext objectWithID:objectID];
}




- (NSManagedObject*)modelByID:(NSString*)uid context:(NSManagedObjectContext*)context 
{	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:[self entityName] 
								   inManagedObjectContext:context]];
	[request setPredicate:[NSPredicate predicateWithFormat:@"uid == %@", uid]];
	[request setIncludesPendingChanges:YES];		
	
	NSError *error;
	NSArray *result = [context executeFetchRequest:request error:&error];
	[request release];
	
	if (nil == result) 
	{
		NSLog(@"Error getting %@:\n%@", [self entityName], [error localizedDescription]);
	}
	else if([result count] > 0)
	{
		return (NSManagedObject*)[result objectAtIndex:0];
	}
	else 
	{
		NSLog(@"%@ with uid=%@ does not exist!", [self entityName], uid);
	}
	
	return nil;
}

- (BOOL)deleteModelByID:(NSString*)uid context:(NSManagedObjectContext*)context 
{	
	NSManagedObject *model = [self modelByID:uid context:context];
	if(model)
	{
		[self deleteChild:model];
		[context deleteObject:model];
		return YES;
	}
	
	return NO;
}

-(void)deleteChild:(NSManagedObject*)parent
{

}


@end
