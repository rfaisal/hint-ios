//
//
//


#import "SourceImagesProvider.h"
#import "SourceImages.h"
#import "UsersProvider.h"

@implementation SourceImagesProvider

static id instance = nil;

+ (id)sharedProvider {
	@synchronized (self){
		if (instance == nil){
			instance = [[self alloc] init];
		}
	}
    
	return instance;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self){
		if (instance == nil){
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

- (NSString *)entityName {
    return @"SourceImages";
}


#pragma mark
#pragma mark Get image
#pragma mark

- (SourceImages *)imageByObjectID:(NSManagedObjectID *)mid error:(NSError**)error {
    SourceImages *image = (SourceImages *)[self.managedObjectContext existingObjectWithID:mid error:error];
	
    if(error){
        NSLog(@"[SourceImages imageByObjectID], error=%@", error);
	}

	return image;
}

- (SourceImages *)imageByUID:(NSUInteger)uid error:(NSError **)error {
    return  [self imageByUID:uid error:error context:self.managedObjectContext];
}

- (SourceImages *)imageByUID:(NSUInteger)uid error:(NSError **)error context:(NSManagedObjectContext *)context{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] 
											  inManagedObjectContext:context];
	[request setEntity:entity];
	[request setPredicate:[NSPredicate predicateWithFormat:@"uid = %u", uid]];
	NSArray* results = [context executeFetchRequest:request error:nil];
    [request release];
	
	SourceImages *image = nil;
	if(nil != results && [results count] > 0){
		image = (SourceImages *)[results objectAtIndex:0];
	}
	
	return image;
}


#pragma mark
#pragma mark Add image
#pragma mark

- (SourceImages *)addImage:(UIImage *) image withUID:(NSUInteger)uid globalURL:(NSString*)gURL localURL:(NSString*)lURL{
	return [self addImage:image
                  withUID:uid 
                globalURL:gURL 
                 localURL:lURL 
                  context:self.managedObjectContext];
}

- (SourceImages *)addImage:(UIImage *) image
                   withUID:(NSUInteger)uid 
                 globalURL:(NSString*)gURL 
                  localURL:(NSString*)lURL 
                   context:(NSManagedObjectContext*)context{
    
    SourceImages *model = (SourceImages *)[NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                            inManagedObjectContext:context];
    
    model.image = UIImagePNGRepresentation(image);
    model.user = [[UsersProvider sharedProvider] currentUserWithContext:context];
	model.uid = [NSNumber numberWithUnsignedInt:uid];
    model.global_url = gURL;
    model.local_url = lURL;
    
	NSError **error=nil;
	if (![context save:error]) {
		return nil;
	}
	
	return model;
}

@end