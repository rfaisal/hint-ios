//
//

#import "EntityProvider.h"

@class SourceImages;

@interface SourceImagesProvider : EntityProvider {
    
}

- (SourceImages*)imageByID:(NSManagedObjectID*)mid error:(NSError**)error;

- (SourceImages*)addImageWithUID:(NSString*)uid globalURL:(NSString*)gURL localURL:(NSString*)lURL;
- (SourceImages*)addImageWithUID:(NSString*)uid 
					   globalURL:(NSString*)gURL 
						localURL:(NSString*)lURL 
						 context:(NSManagedObjectContext*)context;

- (SourceImages *)sourceImageWithID:(NSString*)uid 
						thumbnailId:(NSString*)thumbnailId 					   
						  operation:(NSString *)operation
							context:(NSManagedObjectContext*)context;

- (UIImage*)sourceThumbnailWithUID:(NSString*)uid 
								  globalURL:(NSString*)gURL 
								  operation:(NSString*)operation
									context:(NSManagedObjectContext*)context;

@end
