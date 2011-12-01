//
//

#import "EntityProvider.h"

@class SourceThumbnails;

@interface SourceThumbnailsProvider : EntityProvider {
    
}

- (SourceThumbnails*)thumbnailByID:(NSManagedObjectID*)mid error:(NSError**)error;

- (SourceThumbnails*)addThumbnailWithUID:(NSString*)uid 
							   globalURL:(NSString*)gURL 
								localURL:(NSString*)lURL;

- (SourceThumbnails*)sourceThumbnailWithUID:(NSString*)uid 
								  globalURL:(NSString*)gURL 
								  operation:(NSString*)operation
									context:(NSManagedObjectContext*)context ;

@end
