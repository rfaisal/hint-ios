//
//  SettingsViewController.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "SubscribedViewController.h"

@class Users;

@interface SettingsViewController : SubscribedViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, ActionStatusDelegate> {

}

@property (nonatomic, retain) IBOutlet UIView *container;
@property (nonatomic, retain) IBOutlet UITextView *bioTextView;
@property (nonatomic, retain) IBOutlet UIImageView *avatarView;
@property (nonatomic, retain) IBOutlet UITextField *fullName;

@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) NSObject <Cancelable> *canceler;

- (void)loadSettinsForUser:(Users*)user;

- (IBAction)choosePicture:(id)sender;
- (IBAction)takePicture:(id)sender;

- (IBAction) save: (id)sender;

- (IBAction)displayOfflineUserSwitchDidChangeState:(id)sender;
- (IBAction)shareYourLocationSwitchDidChangeState:(id)sender;

@end