//

#import "SubscribedViewController.h"

@class Users;
@interface PinDetailedViewController : SubscribedViewController {
    NSManagedObjectID *objectID;
    UIScrollView *scrollView;

    UIImageView *imageView;
    UILabel *caption;
    UILabel *manPosition;
    UITextView *infoView;
    UIImageView *photo;
}

@property (nonatomic, retain) NSManagedObjectID *objectID;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *caption;
@property (nonatomic, retain) IBOutlet UILabel *manPosition;
@property (nonatomic, retain) IBOutlet UITextView *infoView;
@property (nonatomic, retain) IBOutlet UIImageView *photo;

-(IBAction) close:(id)sender;

@end