//
//  SettingsViewController.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "SubscribedViewController.h"

@class Users;
@class LoginViewController;
@class RegistrationViewController;

@interface SettingsViewController : SubscribedViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, QBActionStatusDelegate> {
    BOOL isAvatarChanged;
}

@property (nonatomic, retain) IBOutlet UIView *container;
@property (nonatomic, retain) IBOutlet UITextView *bioTextView;
@property (nonatomic, retain) IBOutlet UIImageView *avatarView;
@property (nonatomic, retain) IBOutlet UITextField *fullName;
@property (nonatomic, retain) IBOutlet UISwitch *displayOfflineUserSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *shareYourLocationSwitch;

@property (nonatomic, retain) IBOutlet UIButton *chooseFromGalleryButton;
@property (nonatomic, retain) IBOutlet UIButton *takeAPictureButton;

@property (nonatomic, retain) UIImagePickerController *imagePicker;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *rightBarButtonItem;

@property (nonatomic, retain) IBOutlet LoginViewController *loginController;
@property (nonatomic, retain) IBOutlet RegistrationViewController *registrationController;


- (IBAction) choosePicture:(id)sender;
- (IBAction) takePicture:(id)sender;

- (IBAction) leftNavButtonDidPress: (id)sender;
- (IBAction) rightNavButtonDidPress: (id)sender;

- (IBAction) displayOfflineUserSwitchDidChangeState:(id)sender;
- (IBAction) shareYourLocationSwitchDidChangeState:(id)sender;

@end