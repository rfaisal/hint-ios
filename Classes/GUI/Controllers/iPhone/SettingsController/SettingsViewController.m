//
//  SettingsViewController.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "SettingsViewController.h"

//Data
#import "Users.h"
#import "UsersProvider.h"
#import "StorageProvider.h"
#import "SourceImages.h"
#import "SourceImagesProvider.h"

//Helpers
#import "DeviceHardware.h"
#import "Resources.h"
#import "ImageResize.h"

@implementation SettingsViewController
@synthesize aboutTextView;
@synthesize avatarView;
@synthesize userName, imagePicker;
@synthesize canceler;

- (void)dealloc {
    [userName release];
    [avatarView release];
    [aboutTextView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) startInit{
    Users *user = [[UsersProvider sharedProvider] currentUser];
    [self loadSettinsForUser:user];
}

- (void)loadSettinsForUser:(Users*)user{
    self.userName.text = user.mbUser.login;
}

- (IBAction)choosePicture:(id)sender {

    self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]&&![DeviceHardware simulator]){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imagePicker.showsCameraControls = NO;
//        [self performSelector:@selector(timeToShot:) withObject:nil afterDelay:2];
    }else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentModalViewController:imagePicker animated:YES];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *) picker {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
	[self dismissModalViewControllerAnimated:NO];
	[avatarView setImage:(UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage]];
}

- (IBAction)takePicture:(id)sender {
}

-(IBAction) save: (id)sender{
    [userName resignFirstResponder];
    [aboutTextView resignFirstResponder];
	if(nil == avatarView.image){
		return;
	}
	
	NSData *imageData = UIImagePNGRepresentation(avatarView.image);
	[QBBlobsService TUploadDataAsync:imageData 
							 ownerID:ownerID 
							fileName:@"image.jpeg" 
						 contentType:@"image/jpeg"
							delegate:self];	
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [super viewDidLoad];
	
    Users* user = [[UsersProvider sharedProvider] currentUser];
    
    QBUUser *qbUser = user.mbUser;
    
	if(user.mbUser.website){
		//[MBBBlob URLWithUID:element.[[CurrentUser curentUser].dbUser.photo global_url]]
		[QBBlobsService GetBlobAsync:user.mbUser.website delegate:self];
	}
}

- (void)releseProperties {
    [self setUserName:nil];
    [self setAvatarView:nil];
    self.imagePicker=nil;
    
    [self.canceler cancel];
    self.canceler = nil;
    
    [super releaseProperties];
}

- (void)releaseAll {    
    [super releaseAll];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - ActionStatusDelegate

- (void)completedWithResult:(Result*)result{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
	if([result isKindOfClass:[QBUploadFileTaskResult class]]){
		QBUploadFileTaskResult* res = (QBUploadFileTaskResult*)result;
		if(res.success){
			NSString *blobID = res.uploadedFileBlob.UID;
			[self performSelectorInBackground:@selector(saveAvatarAsync:) withObject:blobID];			
		}else {
			NSLog(@"Error: %@",result.errors);
		}
	}else if([result isKindOfClass:[QBBlobFileResult class]]){
		QBBlobFileResult* res = (QBBlobFileResult*)result;
		if(res.success){
			NSData *avatarData = res.data;
			if(avatarData){
				avatarView.image = [UIImage imageWithData:avatarData];	
			}						
		}else {
			NSLog(@"Error: %@",result.errors);
		}
	}else {
		NSLog(@"Unexpected result %@",result);
	}
}

-(void) saveAvatarAsync:(NSString*)blobID {	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSManagedObjectContext * context = [StorageProvider threadSafeContext];
	
	NSError *error = nil;
	Users* user = [[UsersProvider sharedProvider] currentUser];
    QBUUser *qbUser = user.mbUser;
	NSString* Id = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    SourceImages* sourceImage = [[SourceImagesProvider sharedProvider] addImageWithUID:Id globalURL:blobID localURL:nil context:context];
    
    qbUser.website = blobID;
    
    user.mbUser = qbUser;
    
    [[UsersProvider sharedProvider] saveUser];
    
	if(sourceImage){
		//sourceImage.thumbnail = UIImagePNGRepresentation([ImageResize resizedImage:avatarView.image withRect:CGRectMake(0, 0, 50, 50)]);
		//user.photo = sourceImage;
		
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
		[nc addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:nil];
		[context save:&error];
		[nc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];	
	} 
	
	[pool drain];
}

- (void)mergeChanges:(NSNotification *)notification{	
	NSManagedObjectContext * sharedContext = [StorageProvider sharedInstance].managedObjectContext;
	NSManagedObjectContext * currentContext = (NSManagedObjectContext *)[notification object];
	if ( currentContext == sharedContext) {		
		[currentContext performSelector:@selector(mergeChangesFromContextDidSaveNotification:) 
							   onThread:[NSThread currentThread] 
							 withObject:notification 
						  waitUntilDone:NO];		
	}else {
		[sharedContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
										withObject:notification 
									 waitUntilDone:YES];	
	}
}

- (void)viewDidUnload {
    [self setAboutTextView:nil];
    [super viewDidUnload];
}

@end