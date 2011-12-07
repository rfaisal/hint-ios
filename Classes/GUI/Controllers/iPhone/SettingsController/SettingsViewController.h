//
//  SettingsViewController.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "SubscribedViewController.h"

@class Users;

@interface SettingsViewController : SubscribedViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, ActionStatusDelegate> {
    UITextField *userName;
    UIImagePickerController *imagePicker;
    UIImageView *avatarView;
}

@property (retain, nonatomic) IBOutlet UITextView *aboutTextView;
@property (nonatomic, retain) IBOutlet UITextField *userName;
@property (nonatomic,retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) IBOutlet UIImageView *avatarView;
@property (nonatomic, retain) NSObject <Cancelable> *canceler;

- (void)loadSettinsForUser:(Users*)user;

- (IBAction)choosePicture:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction) save: (id)sender;

@end