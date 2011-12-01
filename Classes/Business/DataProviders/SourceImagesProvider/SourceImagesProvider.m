//
//
//


#import "SourceImagesProvider.h"
#import "SourceImages.h"

@implementation SourceImagesProvider

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
    return @"SourceImages";
}

- (SourceImages*)imageByID:(NSManagedObjectID*)mid error:(NSError**)error {
    SourceImages* image = (SourceImages*)[self.managedObjectContext existingObjectWithID:mid error:error];
	
    if(error)
	{
	}

	return image;
}

- (SourceImages*)addImageWithUID:(NSString*)uid globalURL:(NSString*)gURL localURL:(NSString*)lURL 
{
	return [self addImageWithUID:uid 
					   globalURL:gURL 
						localURL:lURL 
						 context:self.managedObjectContext];
}

- (SourceImages*)addImageWithUID:(NSString*)uid 
					   globalURL:(NSString*)gURL 
						localURL:(NSString*)lURL 
						 context:(NSManagedObjectContext*)context
{
    SourceImages *model = (SourceImages *)[NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                            inManagedObjectContext:context];
	model.uid = [NSNumber numberWithLong:[uid integerValue]];
    model.global_url = gURL;
    model.local_url = lURL;
    
	NSError **error=nil;
	if (![context save:error]) 
	{
		return nil;
	}
	
	return model;
}

- (SourceImages *)sourceImageWithID:(NSString*)uid
						thumbnailId:(NSString*)thumbnailId 
						  operation:(NSString *)operation
							context:(NSManagedObjectContext*)context 
{
	SourceImages *sourceImage = nil;
		
	if(nil == uid)
	{
		return nil;
	}
	
	if([operation isEqualToString:kNewOperation])
	{
		sourceImage = (SourceImages *)[NSEntityDescription insertNewObjectForEntityForName:[self entityName]
																	inManagedObjectContext:context];
		
		sourceImage.uid = [NSNumber numberWithLong:[uid integerValue]];
		
		//[StorageProvider saveContext:context];
	}
	else if([operation isEqualToString:kChangedOperation])
	{
		sourceImage = (SourceImages*)[self modelByID:uid context:context];							
	}
	else 
	{
		[super deleteModelByID:uid context:context];		
	}
	
	return sourceImage;
}


@end
