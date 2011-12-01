

#import "Resources.h"

//SourceElemets
#import "SourceElement.h"
#import "SourceImages.h"

//SourceProviders
#import "StorageProvider.h"
#import "SourceImagesProvider.h"

//Net
#import "LoadBinaryQuery.h"

@implementation Resources

static id instance = nil;

@synthesize queue;

#pragma mark Static Constructor

+ (Resources*)sharedResources {
    @synchronized(self) {
        if (instance == nil) 
            instance = [[self alloc] init];
    }
    return instance;
}
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (instance == nil) {
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

- (void)dealloc {
    self.queue = nil;
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.queue = [[[NSOperationQueue alloc] init] autorelease];
		[self.queue setMaxConcurrentOperationCount:5];
    }
    return self;
}

#pragma mark -
#pragma mark Private Section

+ (NSString *)documentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (void)loadAndSaveResourceFromSource:(SourceElement*)element commonPath:(NSString*)commonPath withStartBlock:(void (^)(void))startLoad complection:(void (^)(NSData *data))endLoad {
    BOOL useLocalURL = (element.local_url && [[NSFileManager defaultManager] fileExistsAtPath:[Resources fullPathForFileWithName:element.local_url]]); 
    NSString *fileName = element.global_url;
    NSURL *localURL = useLocalURL ? [Resources URLForFileWithName:element.local_url] : [NSURL URLWithString:[QBBlob URLWithUID:element.global_url]];
    
    dispatch_queue_t queue = dispatch_queue_create("com.SS.loadImage", NULL);    
    dispatch_async(queue, ^{
        
        NSData *imageData = [NSData dataWithContentsOfURL:localURL];

        dispatch_async(dispatch_get_main_queue(), ^{
            endLoad(imageData);
            
            if (!useLocalURL) {
                [[NSFileManager defaultManager] createFileAtPath:[Resources fullPathForFileWithName:fileName] contents:imageData attributes:nil];
                
                element.local_url = fileName;
				element.downloadStatus = [NSNumber numberWithInt:DownloadStatusFinished];
                [[StorageProvider sharedInstance] delayedSaveInBackground];
            }
        });
    });
    dispatch_release(queue);
}

#pragma mark -
#pragma mark Public Section

+ (NSString *)fullPathForFileWithName:(NSString*)name {
    //NSLog(@"%@", [NSString stringWithFormat:@"%@/%@", [Resources documentsDirectory], name]);
    return [NSString stringWithFormat:@"%@/%@", [Resources documentsDirectory], name];
}
+ (NSURL *)URLForFileWithName:(NSString*)name {
    //return [[NSBundle mainBundle] URLForResource:name withExtension:@""];
    return [NSURL fileURLWithPath:[Resources fullPathForFileWithName:name]];
}

+ (NSObject<Cancelable>*)loadImageFromSource:(NSManagedObjectID*)object withDelegate:(NSObject<ActionStatusDelegate>*)delegate {
    NSError *error = nil;
    SourceImages *image = [[SourceImagesProvider sharedProvider] imageByID:object error:&error];
    
    BOOL useLocalURL = (image.local_url && [[NSFileManager defaultManager] fileExistsAtPath:[Resources fullPathForFileWithName:image.local_url]]); 
    
    if (useLocalURL)
        return nil;
    
    LoadBinaryQuery *query = [[[LoadBinaryQuery alloc] initWithURL:[NSURL URLWithString:[QBBlob URLWithUID:image.global_url]]] autorelease];
    
    return [query performAsyncWithDelegate:delegate];
}

+ (void)loadImageFromSource:(NSManagedObjectID*)object withStartBlock:(void (^)(void))startLoad complection:(void (^)(NSData *data))endLoad {
    startLoad();
    
    NSError *error = nil;
    SourceImages *image = [[SourceImagesProvider sharedProvider] imageByID:object error:&error];
    
    [Resources loadAndSaveResourceFromSource:image commonPath:@"Cach" withStartBlock:startLoad complection:endLoad];
}

@end
