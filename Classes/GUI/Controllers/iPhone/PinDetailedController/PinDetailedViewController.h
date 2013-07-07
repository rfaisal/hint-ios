//
//  PinDetailedViewController.h
//  SuperSample
//
//  Created by Igor Khomenko on 8/23/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "SubscribedViewController.h"

@class Users;
@interface PinDetailedViewController : SubscribedViewController <QBActionStatusDelegate>{
    UIView *messageContainer;
}

@property (nonatomic, retain) NSManagedObjectID *objectID;
@property (nonatomic, retain) IBOutlet UIView *container;
@property (nonatomic, retain) IBOutlet UILabel *userLogin;
@property (nonatomic, retain) IBOutlet UILabel *userFullName;
@property (nonatomic, retain) IBOutlet UIImageView *userAvatar;
@property (nonatomic, retain) IBOutlet UILabel *userStatus;
@property (nonatomic, retain) IBOutlet UITextView *userBio;
@property (nonatomic, retain) IBOutlet UIProgressView *userRating;

-(IBAction) close:(id)sender;
-(IBAction) openPushMessageView:(id)sender;

@end