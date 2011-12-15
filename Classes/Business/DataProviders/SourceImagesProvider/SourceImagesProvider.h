//
//

#import "EntityProvider.h"

@class SourceImages;

@interface SourceImagesProvider : EntityProvider {
    
}

// Get
- (SourceImages *)imageByID:(NSManagedObjectID*)mid error:(NSError**)error;

// Add
- (SourceImages *)addImage:(UIImage *) image withUID:(NSString*)uid globalURL:(NSString*)gURL localURL:(NSString*)lURL;
- (SourceImages *)addImage:(UIImage *) image
                   withUID:(NSString*)uid 
                 globalURL:(NSString*)gURL 
                  localURL:(NSString*)lURL 
                   context:(NSManagedObjectContext*)context;

@end