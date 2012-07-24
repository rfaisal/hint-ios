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
    
    // setup buttons
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
        }else if(user.qbUser.blobID){
            [QBContent TDownloadFileWithBlobID:user.qbUser.blobID delegate:self];
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

// choose picture from gallery
- (IBAction)choosePicture:(id)sender {
    imagePicker = [[UIImagePickerController alloc] init];

    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.mediaTypes = [UIImagePickerController
                              availableMediaTypesForSourceType:imagePicker.sourceType]; 

    imagePicker.delegate = self;
    
	[self.navigationController presentModalViewController:imagePicker animated:NO];
}

// take picture using camera
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
            [QBContent TUploadFile:imageData fileName:@"image.jpeg" contentType:@"image/jpeg" isPublic:NO delegate:self];	
        }else{
            // update user fields
            
            // create QBUUser entity
            QBUUser *user = [QBUUser user];
            user.ID = [[UsersProvider sharedProvider] currentUserID];
            user.fullName = fullName.text;
            
            // update user
            [QBUsers updateUser:user delegate:self];
        }
    
    // show Sign In controller
    }else{
         [self presentModalViewController:(UIViewController *)loginController animated:YES];
    }
}

- (IBAction) rightNavButtonDidPress: (id)sender{
    NSLog(@"[rightBarButtonItem title]=%@", [rightBarButtonItem title]);
    
    // Logout
    if([[rightBarButtonItem title] isEqualToString:@"Logout"]){
        // logout
        [QBUsers logOutWithDelegate:nil];
        
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:nRefreshAnnotationDetails object:nil];
        
    // show Sign Up controller
    }else{
       [self presentModalViewController:(UIViewController *)registrationController animated:YES];
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


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

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


#pragma mark -
#pragma mark QBActionStatusDelegate

- (void)completedWithResult:(Result*)result{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // Edit User result
    if([result isKindOfClass:[QBUUserResult class]]){

        // Success result
        if(result.success){
            
            // get & update  current user
            Users *currentUser = [[UsersProvider sharedProvider] currentUser];
            currentUser.qbUser.fullName = fullName.text;
            [[UsersProvider sharedProvider] saveUser];
            
            [self showMessage:NSLocalizedString(@"User edited successfully", "") message:nil delegate:self];
        
        // show Errors
        }else{
            [self processErrors:result.errors];
        }
        
    // Upload image result
	}else if([result isKindOfClass:[QBCFileUploadTaskResult class]]){
        // Success result
		if(result.success){
            
            QBCFileUploadTaskResult *res = (QBCFileUploadTaskResult*)result;
            int blobID = res.uploadedBlob.ID;
            
            // update current user
            
            // create QBUUser entity
            QBUUser *user = [QBUUser user];
            user.ID = [[UsersProvider sharedProvider] currentUserID];
            user.fullName = fullName.text;
            user.blobID = blobID; // connect link to avatar
            
            // update user
            [QBUsers updateUser:user delegate:self];
            
            // save blob_id
            Users *currentUser = [[UsersProvider sharedProvider] currentUser];
            currentUser.qbUser.blobID = blobID;
            [[UsersProvider sharedProvider] saveUser];
            
			[self performSelectorInBackground:@selector(saveAvatarAsync:) withObject:res.uploadedBlob];		
		
        // show errors
        }else {
			[self processErrors:result.errors];
		}
        
    // Download file result 
    }else if([result isKindOfClass:[QBCFileDownloadTaskResult class]]){
        QBCFileDownloadTaskResult *res = (QBCFileDownloadTaskResult *)result;
        
        // show photo
        avatarView.image = [UIImage imageWithData:res.file];	
        
        
        NSManagedObjectContext *context = [StorageProvider threadSafeContext];
        
        // save image
        SourceImages *sourceImage = [[SourceImagesProvider sharedProvider] addImage:[UIImage imageWithData:res.file]
                                                                            withUID:[[UsersProvider sharedProvider] currentUser].qbUser.blobID
                                                                          globalURL:nil
                                                                           localURL:nil 
                                                                            context:context];
        
        if(sourceImage){
            
            // update user
            Users *user = [[UsersProvider sharedProvider] userByUID:[NSNumber numberWithUnsignedInt:[[UsersProvider sharedProvider] currentUserID]] context:context];
            user.photo = sourceImage;
            
            
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
            [nc addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:nil];
            NSError *error;
            [context save:&error];
            [nc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];	
        } 
        
    // show errors
	}else if(!result.success){
        [self processErrors:result.errors];
    }
}

-(void) saveAvatarAsync:(QBCBlob *)blob {	
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