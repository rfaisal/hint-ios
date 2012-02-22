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

#import "SuperSampleAppDelegate.h"

//Helpers
#import "DeviceHardware.h"
#import "ImageResize.h"

@implementation SettingsViewController
@synthesize bioTextView, container, avatarView, fullName;
@synthesize displayOfflineUserSwitch, shareYourLocationSwitch;
@synthesize imagePicker;
@synthesize leftBarButtonItem, rightBarButtonItem;
@synthesize chooseFromGalleryButton, takeAPictureButton;
@synthesize loginController, registrationController;

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
    [FlurryAPI logEvent:@"SettingsViewController, viewDidLoad"];
    
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
    
    // setup switchers
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    [displayOfflineUserSwitch setOn:[defaults boolForKey:kDisplayOfflineUser]];
    [shareYourLocationSwitch setOn:[defaults boolForKey:kShareYourLocation]];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    Users *user = [[UsersProvider sharedProvider] currentUser];
    if(user != nil){
        
        [leftBarButtonItem setTitle:@"Save"];
        [rightBarButtonItem setTitle:@"Logout"];
        
        [fullName setEnabled:YES];
        [chooseFromGalleryButton setEnabled:YES];
        [takeAPictureButton setEnabled:YES];
        
        // populate fields
        fullName.text = user.qbUser.fullName;
        
        // set avatar
        if(user.photo){
            [avatarView setImage:[UIImage imageWithData:user.photo.image]];
        }else if(user.qbUser.externalUserID){
            [self performSelectorInBackground:@selector(getAvatarAndStoreForQBUserAsync:) withObject:user.qbUser];
        }
        
    }else{
        [leftBarButtonItem setTitle:@"Sign in"];
        [rightBarButtonItem setTitle:@"Sign up"];
        
        [fullName setEnabled:NO];
        [chooseFromGalleryButton setEnabled:NO];
        [takeAPictureButton setEnabled:NO];
    }
}

- (void)viewDidUnload {
    self.bioTextView = nil;
    self.container = nil;
    self.avatarView = nil;
    self.fullName = nil;
    self.chooseFromGalleryButton = nil;
    self.takeAPictureButton = nil;
    
    self.leftBarButtonItem = nil;
    self.rightBarButtonItem = nil;
    
    self.imagePicker = nil;
    
    self.loginController = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark IBAction

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

- (IBAction) leftNavButtonDidPress: (id)sender{
    // Save
    if([[leftBarButtonItem title] isEqualToString:@"Save"]){
        [bioTextView resignFirstResponder];
        [fullName resignFirstResponder];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        
        // if avatar not changed
        if(isAvatarChanged){
            isAvatarChanged = NO;
            
            // update avatar
            NSData *imageData = UIImagePNGRepresentation(avatarView.image);
            [QBBlobsService TUploadDataAsync:imageData 
                                     ownerID:ownerID 
                                    fileName:@"image.jpeg" 
                                 contentType:@"image/jpeg"
                                    delegate:self];	
        }else{
            // update user fields
            QBUUser *user = [[QBUUser alloc] init];
            user.ID = [[UsersProvider sharedProvider] currentUserID];
            user.fullName = fullName.text;
            [QBUsersService editUser:user delegate:self];
            [user release];
        }
    
    // Sign In
    }else{
         [self presentModalViewController:loginController animated:YES];
    }
}

- (IBAction) rightNavButtonDidPress: (id)sender{
    NSLog(@"[rightBarButtonItem title]=%@", [rightBarButtonItem title]);
    
    // Logout
    if([[rightBarButtonItem title] isEqualToString:@"Logout"]){
        // logout
        [QBUsersService logoutUser:nil];
        
        [[UsersProvider sharedProvider] setCurrentUserID:-1];
        
        [avatarView setImage:[UIImage imageNamed:@"user.png"]];
        [fullName setText:@""];
        [fullName setEnabled:NO];
        [chooseFromGalleryButton setEnabled:NO];
        [takeAPictureButton setEnabled:NO];
        
        [leftBarButtonItem setTitle:@"Sign in"];
        [rightBarButtonItem setTitle:@"Sign up"];
        
        SuperSampleAppDelegate *delegate = ((SuperSampleAppDelegate *)[[UIApplication sharedApplication] delegate]);
        [delegate stopTrackOwnLocation];
        [[delegate facebook] logout];
        
    // Sign Up
    }else{
       [self presentModalViewController:registrationController animated:YES];
    }
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
    
    // origin image
    UIImage *image = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
    
    // resized image
    UIImage *resizedImage = [ImageResize resizedImage:image withRect:CGRectMake(0, 0, 100, 100)];
    
    [avatarView setImage:resizedImage];
    
    isAvatarChanged = YES;
    
    self.imagePicker = nil;
}


#pragma mark
#pragma mark ActionStatusDelegate
#pragma mark

- (void)completedWithResult:(Result*)result{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // Edit User result
    if([result isKindOfClass:[QBUUserResult class]]){
        QBUUserResult *res = (QBUUserResult *)result;
        if(res.success){
            // get & update user
            Users *currentUser = [[UsersProvider sharedProvider] currentUser];
            currentUser.qbUser.fullName = fullName.text;
            [[UsersProvider sharedProvider] saveUser];
            
            [self showMessage:NSLocalizedString(@"User edited successfully", "") message:nil delegate:self];
        }else{
            [self processErrors:res.errors];
        }
        
    // Upload image result
	}else if([result isKindOfClass:[QBUploadFileTaskResult class]]){
		QBUploadFileTaskResult *res = (QBUploadFileTaskResult*)result;
		if(res.success){
            
            int blobID = res.uploadedFileBlob.ID;
            
            // update current user
            QBUUser *user = [[QBUUser alloc] init];
            user.ID = [[UsersProvider sharedProvider] currentUserID];
            user.fullName = fullName.text;
            user.blobID = blobID;
            [QBUsersService editUser:user delegate:self];
            [user release];
            
            // save blob_id
            Users *currentUser = [[UsersProvider sharedProvider] currentUser];
            currentUser.qbUser.externalUserID = blobID; // temporary fix. Use 'blob_id' instead 'externalUserID'
            [[UsersProvider sharedProvider] saveUser];
            
			[self performSelectorInBackground:@selector(saveAvatarAsync:) withObject:res.uploadedFileBlob];		
		}else {
			[self processErrors:res.errors];
		}
        
	}else if(!result.success){
        [self processErrors:result.errors];
    }
}

- (void) getAvatarAndStoreForQBUserAsync:(QBUUser *)qbUser{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSManagedObjectContext *context = [StorageProvider threadSafeContext];
    NSError *error;
    
    // get blob
    QBBlobResult *blobResult = [QBBlobsService GetBlobInfo:qbUser.externalUserID];
    
    if(!blobResult.success){
        [self performSelectorOnMainThread:@selector(processErrors:) withObject:blobResult.errors waitUntilDone:YES];
        [pool drain];
        return;
    }
    
    QBBlob *blob = blobResult.blob;
    
    // get file
    QBBlobFileResult *blobFileResult = [QBBlobsService GetBlob:blob.UID];
    if(!blobFileResult.success){
        [self performSelectorOnMainThread:@selector(processErrors:) withObject:blobResult.errors waitUntilDone:YES];
        [pool drain];
        return;
    }
    
    if(blobFileResult.data == nil){
        [pool drain];
        return;
    }
    
    avatarView.image = [UIImage imageWithData:blobFileResult.data];	
    
    // save image
    SourceImages *sourceImage = [[SourceImagesProvider sharedProvider] addImage:[UIImage imageWithData:blobFileResult.data]
                                                                        withUID:blob.ID 
                                                                      globalURL:blob.UID 
                                                                       localURL:nil 
                                                                        context:context];
    
	if(sourceImage){
        // update user
        Users *user = [[UsersProvider sharedProvider] userByUID:[NSNumber numberWithUnsignedInt:qbUser.ID] context:context];
		user.photo = sourceImage;
		
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
		[nc addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:nil];
		[context save:&error];
		[nc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];	
	} 
    
    [pool drain];
}

-(void) saveAvatarAsync:(QBBlob *)blob {	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSManagedObjectContext *context = [StorageProvider threadSafeContext];
	
	NSError *error = nil;
    [[UsersProvider sharedProvider] currentUserWithContext:context];

    // save image
    SourceImages *sourceImage = [[SourceImagesProvider sharedProvider] addImage:avatarView.image
                                                                        withUID:blob.ID 
                                                                      globalURL:blob.UID 
                                                                       localURL:nil 
                                                                        context:context];
	
	if(sourceImage){
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
		[nc addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:nil];
		[context save:&error];
		[nc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];	
	} 
	
	[pool drain];
}

- (void)mergeChanges:(NSNotification *)notification{	
	NSManagedObjectContext *sharedContext = [StorageProvider sharedInstance].managedObjectContext;
	NSManagedObjectContext *currentContext = (NSManagedObjectContext *)[notification object];
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