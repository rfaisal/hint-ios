
//

#import "ImageThambnailView.h"

//Data
#import "Resources.h"
#import "StorageProvider.h"
#import "SourceImages.h"

@interface ImageThambnailView ()

- (void)handleTap:(UITapGestureRecognizer *)sender;

@end


@implementation ImageThambnailView

@synthesize image;
@synthesize title;
@synthesize caption;
@synthesize extra;
@synthesize activityIndicator;

- (void)releaseProperties {
    self.image = nil;
    self.title = nil;
    self.caption = nil;
    self.extra = nil;
    self.activityIndicator = nil;
    
    [super releaseProperties];
}

- (id)initWithIndex:(NSInteger)index extras:(NSManagedObject*)model {
    CGRect rect;
    
    rect = CGRectMake(154 * index, 0, 144, 111);
    
    self = [super initWithFrame:rect];
    if (self) {
        self.frame = rect;

        [self reinitData:model];
    }
    return self;
}

- (void)startInit {
    [super startInit];
    
    CGRect baseFrame = self.bounds;
    

    baseFrame = CGRectMake(-4, -1, 148, 115);
    
    CGRect frame = baseFrame;
    
    // Image
    frame.origin.y = 15;
    frame.size.height -= 30;
    
    self.image = [[[UIImageView alloc] initWithFrame:frame] autorelease];
    [self addSubview:self.image];
    
    // Activity Indecator View
    self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    self.activityIndicator.center = CGPointMake(self.image.frame.size.width / 2, self.image.frame.size.height / 2);
    [self addSubview:self.activityIndicator];
    
    // Title
    frame.origin.y = 0;
    frame.size.height = 15;
    
    self.title = [[[UILabel alloc] initWithFrame:frame] autorelease];
    self.title.textColor = [UIColor colorWithRed:250.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1];
    self.title.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    self.title.backgroundColor = [UIColor clearColor];
    [self addSubview:self.title];
    
    // Caption
    frame.origin.y = baseFrame.size.height - 15;
    frame.origin.x = frame.origin.x + 5;
    frame.size.height = 15;
    
    self.caption = [[[UILabel alloc] initWithFrame:frame] autorelease];
    self.caption.textColor = [UIColor whiteColor];
    self.caption.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    self.caption.backgroundColor = [UIColor clearColor];
    [self addSubview:self.caption];
    
    UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)] autorelease];
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
}

- (void)setExtras:(NSManagedObject*)model {
    [self reinitData:model];
}

- (void)reinitData:(NSManagedObject*)model {
    self.extra = model;
    
    [self reloadThumbnailImage];
}

#pragma mark -
#pragma mark Thumbnail Loading

- (SourceImages*)thumbnailForImage {
    return nil;
}
- (void)reloadThumbnailImage {
    SourceImages *thumbnail = [self thumbnailForImage];
    
    if (thumbnail && thumbnail.local_url) {
        [self endLoadingForImage:[NSData dataWithContentsOfURL:[Resources URLForFileWithName:thumbnail.local_url]]];
    } else if (thumbnail && thumbnail.global_url) {
        ASIHTTPRequest *thumbnailRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[QBBlob URLWithUID:thumbnail.global_url]]];
        [thumbnailRequest setDelegate:self];
        [[Resources sharedResources].queue addOperation:thumbnailRequest];
        
        [self startLoadingForImage];
        
        //[Resources loadThumbnailFromSource:[thumbnail objectID] withStartBlock:^{ 
        //    [self startLoadingForImage];
        //} complection:^ (NSData *data){
        //    [self endLoadingForImage:data];
        //}];
    } else {
        [self failLoadThumbnail];
    }
}
- (void)startLoadingForImage {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.image.image = nil;
}
- (void)endLoadingForImage:(NSData*)imageData {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    
    self.image.image = [UIImage imageWithData:imageData];
}
- (void)failLoadThumbnail {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;

    self.image.image = [UIImage imageNamed:@"example-iphone.jpg"];
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate methods

- (void)requestFinished:(ASIHTTPRequest *)request {
    SourceImages *thumbnail = [self thumbnailForImage];
    
    [[NSFileManager defaultManager] createFileAtPath:[Resources fullPathForFileWithName:thumbnail.global_url] contents:[request responseData] attributes:nil];
    
    thumbnail.local_url = thumbnail.global_url;
    thumbnail.downloadStatus = [NSNumber numberWithInt:DownloadStatusFinished];
    [[StorageProvider sharedInstance] delayedSaveInBackground];

    
    [self endLoadingForImage:[request responseData]];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[self failLoadThumbnail];
}


- (void)tapReactionForObject:(NSManagedObject *)model {
    
}

- (void)handleTap:(UITapGestureRecognizer *)sender {     
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self tapReactionForObject:self.extra];
        
        /*if (self.extra.extrasType == ExtrasTypeVideos) {
         NSURL *url = [NSURL URLWithString:@"http://assets.yas.s3.amazonaws.com/HP/Interactive_Reel_042511-1.mp4"];
         NSURL *subUrl = [NSURL URLWithString:@"http://assets.yas.s3.amazonaws.com/HP/NWEsubs1-1.xml"];
         
         if ([self.extra.urlString length] != 0) {
         url = [NSURL URLWithString:self.extra.urlString];
         subUrl = nil;
         }
         
         
         VideoPlayerViewController *video = [[[VideoPlayerViewController alloc] initWithURL:url subtitlesURL:subUrl forExtras:self.extra] autorelease];
         
         [[NWEDigitalAppDelegate sharedDelegate].mainViewController presentModalViewController:video animated:YES];
         } else if (self.extra.extrasType == ExtrasTypePhotos) {
         
         }*/
    } 
}

@end
