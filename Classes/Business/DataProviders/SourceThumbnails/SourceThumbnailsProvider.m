//
//  SourceThumbnailsProvider.m
//  NWEDigital
//
//  Created by Andrey Kozlov on 6/2/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "SourceThumbnailsProvider.h"
#import "SourceThumbnails.h"


@implementation SourceThumbnailsProvider

static id instance = nil;

+ (id)sharedProvider {
	@synchronized (self)
	{
		if (instance == nil)
		{
			instance = [[self alloc] init];
		}
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
- (void)release {
}
- (id)autorelease {
	return self;
}

- (NSString *)entityName {
    return @"SourceThumbnails";
}

- (SourceThumbnails*)thumbnailByID:(NSManagedObjectID*)mid error:(NSError**)error {
    SourceThumbnails* image = (SourceThumbnails*)[self.managedObjectContext existingObjectWithID:mid error:error];
	
    if(error)
	{
	}
    
	return image;
}

- (SourceThumbnails*)addThumbnailWithUID:(NSString*)uid globalURL:(NSString*)gURL localURL:(NSString*)lURL {
    SourceThumbnails *model = (SourceThumbnails *)[NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                                      inManagedObjectContext:self.managedObjectContext];
	model.uid = [NSNumber numberWithLong:[uid integerValue]];
    model.global_url = gURL;
    model.local_url = lURL;
    //model.downloaded = [NSNumber numberWithBool:NO];
    
	NSError **error=nil;
	if (![self.managedObjectContext save:error]) {
		return nil;
	}
	
	return model;
}

- (SourceThumbnails*)sourceThumbnailWithUID:(NSString*)uid 
								  globalURL:(NSString*)gURL 
								  operation:(NSString*)operation
									context:(NSManagedObjectContext*)context 
{
	if(nil == uid)
	{
		return nil;
	}
	
    SourceThumbnails *sourceThumbnail = nil;
			
	if([operation isEqualToString:kNewOperation])
	{
		sourceThumbnail = (SourceThumbnails *)[NSEntityDescription insertNewObjectForEntityForName:[self entityName]
																			inManagedObjectContext:context];
		
		sourceThumbnail.uid = [NSNumber numberWithLong:[uid integerValue]];	
		sourceThumbnail.global_url = gURL;
		
		//[StorageProvider saveContext:context];
	}
	else if([operation isEqualToString:kChangedOperation])
	{
		sourceThumbnail = (SourceThumbnails*)[self modelByID:uid context:context];							
	}
	else 
	{
		[super deleteModelByID:uid context:context];		
	}
	
	return sourceThumbnail;
}

@end
