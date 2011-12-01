//
//

@interface Resources : NSObject {
    NSOperationQueue *queue;
}

@property (nonatomic, retain) NSOperationQueue *queue;

+ (Resources*)sharedResources;

+ (NSString *)fullPathForFileWithName:(NSString*)name;
+ (NSURL *)URLForFileWithName:(NSString*)name;

+ (NSObject<Cancelable>*)loadImageFromSource:(NSManagedObjectID*)object withDelegate:(NSObject<ActionStatusDelegate>*)delegate;

+ (void)loadImageFromSource:(NSManagedObjectID*)object withStartBlock:(void (^)(void))startLoad complection:(void (^)(NSData *data))endLoad;

@end
