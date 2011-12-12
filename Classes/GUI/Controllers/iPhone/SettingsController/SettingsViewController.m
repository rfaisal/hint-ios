//
//  SettingsViewController.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 QuickBlox. All rights reserved.
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
@synthesize bioTextView, container, avatarView, fullName;
@synthesize imagePicker, canceler;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark 
#pragma mark - View lifecycle
#pragma mark 

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [super viewDidLoad];
    
    // container customization
    container.layer.borderWidth = 1;
    container.layer.borderColor = [[UIColor colorWithRed:173/255.0 green:190/255.0 blue:209/255.0 alpha:1] CGColor];
    container.layer.cornerRadius = 8;
    container.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    
    // bio customization
    bioTextView.layer.cornerRadius = 6;
    bioTextView.layer.borderWidth = 1;
    bioTextView.layer.borderColor = [[UIColor colorWithRed:173/255.0 green:190/255.0 blue:209/255.0 alpha:1] CGColor];
    bioTextView.backgroundColor = [UIColor whiteColor];
	
    Users *user = [[UsersProvider sharedProvider] currentUser];
    
    // temporary fix. Use 'blob_id' instead 'website'
	if(user.mbUser.website){
		[QBBlobsService GetBlobAsync:user.mbUser.website delegate:self];
	}
}

- (void)viewDidUnload {
    self.bioTextView = nil;
    self.container = nil;
    self.avatarView = nil;
    self.fullName = nil;
    
    self.imagePicker = nil;
    
    [canceler cancel];
    self.canceler = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark
#pragma mark IBAction
#pragma mark

- (IBAction)choosePicture:(id)sender {

}

- (IBAction)takePicture:(id)sender {
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

-(IBAction) save: (id)sender{
    [bioTextView resignFirstResponder];
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

- (IBAction)displayOfflineUserSwitchDidChangeState:(id)sender{
    
}

- (IBAction)shareYourLocationSwitchDidChangeState:(id)sender{
    
}


#pragma mark
#pragma mark UIImagePickerControllerDelegate
#pragma mark

- (void) imagePickerControllerDidCancel:(UIImagePickerController *) picker {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
	[self dismissModalViewControllerAnimated:NO];
	[avatarView setImage:(UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage]];
}


#pragma mark
#pragma mark ActionStatusDelegate
#pragma mark

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

- (void) startInit{
    Users *user = [[UsersProvider sharedProvider] currentUser];
    [self loadSettinsForUser:user];
}

- (void)loadSettinsForUser:(Users*)user{
    // self.userName.text = user.mbUser.login;
}


- (void)dealloc {
    [super dealloc];
}

@end