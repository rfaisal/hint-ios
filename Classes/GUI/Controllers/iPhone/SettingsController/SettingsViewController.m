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
@synthesize displayOfflineUserSwitch, shareYourLocationSwitch;
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
    
    // setup switchers
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    [displayOfflineUserSwitch setOn:[defaults boolForKey:kDisplayOfflineUser]];
    [shareYourLocationSwitch setOn:[defaults boolForKey:kShareYourLocation]];
    
    
    // set avatar
    // temporary fix. Use 'blob_id' instead 'website'
	if(user.mbUser.website){
		[QBBlobsService GetBlobAsync:user.mbUser.website delegate:self];
	}
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    Users *user = [[UsersProvider sharedProvider] currentUser];
    
    
    NSLog(@"user.mbUser.fullName=%@", user.mbUser.fullName);
    
    // populate fields
    fullName.text = user.mbUser.fullName;
    bioTextView.text = @"my bio";
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
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
	[self.navigationController presentModalViewController:imagePicker animated:NO];
}

- (IBAction)takePicture:(id)sender {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && ![DeviceHardware simulator]){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentModalViewController:imagePicker animated:YES];
}

-(IBAction) save: (id)sender{
    [bioTextView resignFirstResponder];
    [fullName resignFirstResponder];
    
    /*
	if(nil == avatarView.image){
		return;
	}

	NSData *imageData = UIImagePNGRepresentation(avatarView.image);
	[QBBlobsService TUploadDataAsync:imageData 
							 ownerID:ownerID 
							fileName:@"image.jpeg" 
						 contentType:@"image/jpeg"
							delegate:self];	*/
    
    // update user fields
    QBUUser *user = [[QBUUser alloc] init];
    user.ID = [[UsersProvider sharedProvider] currentUserID];
    user.fullName = fullName.text;
    
    [QBUsersService editUser:user delegate:self];
    
    [user release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (IBAction)displayOfflineUserSwitchDidChangeState:(id)sender{
    UISwitch *switcher = (UISwitch *)sender;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    [defaults setBool:switcher.on forKey:kDisplayOfflineUser];
    [defaults synchronize];
}

- (IBAction)shareYourLocationSwitchDidChangeState:(id)sender{
    UISwitch *switcher = (UISwitch *)sender;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    [defaults setBool:switcher.on forKey:kShareYourLocation];
    [defaults synchronize];
}


#pragma mark
#pragma mark UIImagePickerControllerDelegate
#pragma mark

- (void) imagePickerControllerDidCancel:(UIImagePickerController *) picker {
	[self dismissModalViewControllerAnimated:YES];
    self.imagePicker = nil;
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
	[self dismissModalViewControllerAnimated:NO];
    
    // resize image
    UIImage *image = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(120, 120));
    [image drawInRect:CGRectMake(0, 0, 120, 120)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [avatarView setImage:resizedImage];
    
    self.imagePicker = nil;
}


#pragma mark
#pragma mark ActionStatusDelegate
#pragma mark

- (void)completedWithResult:(Result*)result{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if([result isKindOfClass:[QBUUserResult class]]){
        QBUUserResult* res = (QBUUserResult*)result;
        if(res.success){
            // get & update user
            Users *currentUser = [[UsersProvider sharedProvider] currentUser];
            currentUser.mbUser.fullName = fullName.text;
            BOOL saveUserStatus = [[UsersProvider sharedProvider] saveUser];
            
            [self showMessage:NSLocalizedString(@"Edit user successful", "") message:nil];
        }else{
            [self processErrors:result.answer.errors];
        }
	}else if([result isKindOfClass:[QBUploadFileTaskResult class]]){
		QBUploadFileTaskResult* res = (QBUploadFileTaskResult*)result;
		if(res.success){
			NSString *blobID = res.uploadedFileBlob.UID;
			[self performSelectorInBackground:@selector(saveAvatarAsync:) withObject:blobID];			
		}else {
			NSLog(@"Error: %@", result.errors);
		}
	}else if([result isKindOfClass:[QBBlobFileResult class]]){
		QBBlobFileResult* res = (QBBlobFileResult*)result;
		if(res.success){
			NSData *avatarData = res.data;
			if(avatarData){
				avatarView.image = [UIImage imageWithData:avatarData];	
			}						
		}else {
			NSLog(@"Error: %@", result.errors);
		}
	}else {
		NSLog(@"Unexpected result %@",result);
	}
}

-(void)showMessage:(NSString*)title message:(NSString*)msg{

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:msg 
												   delegate:self 
										  cancelButtonTitle:NSLocalizedString(@"OK", "") 
										  otherButtonTitles:nil];
	
	alert.tag = (title == NSLocalizedString(@"Registration successful", "") ? 1 : 0);
	[alert show];
	[alert release];	
}

-(void)processErrors:(NSMutableArray*)errors{
	NSMutableString *errorsString = [NSMutableString stringWithCapacity:0];
	
	for(NSString *error in errors){
		[errorsString appendFormat:@"%@\n", error];
	}
	
	if ([errorsString length] > 0) {
		[self showMessage:NSLocalizedString(@"Error", "") message:errorsString];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [bioTextView resignFirstResponder];
    [fullName resignFirstResponder];
}

- (void)dealloc {
    [super dealloc];
}

@end