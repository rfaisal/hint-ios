//
//

#import "EntityProvider.h"

@class SourceImages;

@interface SourceImagesProvider : EntityProvider {
    
}

// Get
- (SourceImages *)imageByObjectID:(NSManagedObjectID*)mid error:(NSError**)error;

- (SourceImages *)imageByUID:(NSUInteger)uid error:(NSError**)error;
- (SourceImages *)imageByUID:(NSUInteger)uid error:(NSError**)error context:(NSManagedObjectContext*)context;

// Add
- (SourceImages *)addImage:(UIImage *) image withUID:(NSUInteger)uid globalURL:(NSString*)gURL localURL:(NSString*)lURL;
- (SourceImages *)addImage:(UIImage *) image
                   withUID:(NSUInteger)uid 
                 globalURL:(NSString*)gURL 
                  localURL:(NSString*)lURL 
                   context:(NSManagedObjectContext*)context;

@end