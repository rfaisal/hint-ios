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
    BOOL isAvatarChanged;
}

@property (nonatomic, retain) IBOutlet UIView *container;
@property (nonatomic, retain) IBOutlet UITextView *bioTextView;
@property (nonatomic, retain) IBOutlet UIImageView *avatarView;
@property (nonatomic, retain) IBOutlet UITextField *fullName;
@property (nonatomic, retain) IBOutlet UISwitch *displayOfflineUserSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *shareYourLocationSwitch;

@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) NSObject <Cancelable> *canceler;


- (IBAction) choosePicture:(id)sender;
- (IBAction) takePicture:(id)sender;

- (IBAction) save: (id)sender;
- (IBAction) logout: (id)sender;

- (IBAction) displayOfflineUserSwitchDidChangeState:(id)sender;
- (IBAction) shareYourLocationSwitchDidChangeState:(id)sender;

-(void)processErrors:(NSMutableArray*)errors;
-(void)showMessage:(NSString*)title message:(NSString*)msg;

@end