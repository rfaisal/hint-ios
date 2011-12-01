
//

#import "SubscribedView.h"

@class SourceImages;

@interface ImageThambnailView : SubscribedView <UIGestureRecognizerDelegate, ASIHTTPRequestDelegate> {
    UIImageView *image;
    UILabel *title;
    UILabel *caption;
    
    NSManagedObject *extra;
    
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *caption;
@property (nonatomic, retain) NSManagedObject *extra;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

- (id) initWithIndex:(NSInteger)index extras:(NSManagedObject*)model;

- (void)setExtras:(NSManagedObject*)model;

- (void)reinitData:(NSManagedObject*)model;
- (void)tapReactionForObject:(NSManagedObject*)model;

#pragma mark Thumbnail Loading

- (SourceImages*)thumbnailForImage;
- (void)reloadThumbnailImage;
- (void)startLoadingForImage;
- (void)endLoadingForImage:(NSData*)imageData;
- (void)failLoadThumbnail;

@end
