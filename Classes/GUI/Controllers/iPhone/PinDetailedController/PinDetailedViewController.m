//
//  PinDetailedViewController.m
//  SuperSample
//
//  Created by Igor Khomenko on 8/23/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "PinDetailedViewController.h"

//Data
#import "Users.h"
#import "UsersProvider.h"
#import "SourceImages.h"


@implementation PinDetailedViewController

@synthesize objectID;
@synthesize container, userLogin, userFullName, userBio, userAvatar, userStatus, userRating;

- (void)subscribe {
    [super subscribe];
    
    [self addObserver:self forKeyPath:@"objectID" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)unsubscribe {
    [super unsubscribe];
    
    [self removeObserver:self forKeyPath:@"objectID"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload {
    self.container = nil;
    self.userLogin = nil;
    self.userFullName = nil;
    self.userBio = nil;
    self.userAvatar = nil;
    self.userStatus = nil;
    self.userRating = nil;
    
    [super viewDidUnload];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [FlurryAPI logEvent:@"PinDetailedViewController, viewDidLoad"];
    
    
    // container customization
    container.layer.borderWidth = 2;
    container.layer.borderColor = [[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1] CGColor];
    container.layer.cornerRadius = 8;
    container.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    
    userAvatar.layer.masksToBounds = YES;
    userAvatar.layer.cornerRadius = 7;
}


- (void)handleTap:(UITapGestureRecognizer *) gesture{
    Users *user = [[UsersProvider sharedProvider] currentUser];
    
    if(objectID == user.objectID){
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:nOpenPrivateChatView 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObject:objectID forKey:nkData]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([@"objectID" isEqualToString:keyPath]) {
        NSError *error = nil;
        Users *user = [[UsersProvider sharedProvider] userByID:self.objectID error:&error];
        if (error) {
            NSLog(@"error did get userByID: %@",error);
            return;
        }
        
        // login
        userLogin.text = user.qbUser.login;
        if(userLogin.text == nil || [userLogin.text isEqualToString:@""]){
            userLogin.text = @"anonymous";
        }
        
        // full name
        userFullName.text = user.qbUser.fullName;
        if(userFullName.text == nil || [userFullName.text isEqualToString:@""]){
            userFullName.text = @"anonymous";
        }
            
        
        // status
        userStatus.text = user.status;
            
        // photo
        SourceImages *sourceImage = user.photo;    
        userAvatar.image = [UIImage imageWithData:sourceImage.image];
        if(userAvatar.image == nil){
            userAvatar.image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"user" ofType:@"png"]];
        }
        
        // tap on avatar GestureRecognizer
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [userAvatar addGestureRecognizer:tap];
        [tap release];
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(IBAction) close:(id)sender{
    [self.parentCustomModalController dismissCustomModalViewControllerAnimated:YES];
}

// open push messages view
-(IBAction) openPushMessageView:(id)sender{
    
    Users *user = [[UsersProvider sharedProvider] currentUser];
    if(user == nil){
        [self showMessage:NSLocalizedString(@"You must first be authorized. Go to Settings tab", "") message:nil delegate:nil];
        return;
    }
    
    // container
    messageContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 245)];
    messageContainer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    messageContainer.alpha = 0;
    [self.view addSubview:messageContainer];
    [messageContainer release];
    
    // text view
    UITextView *messageBody = [[UITextView alloc] initWithFrame:CGRectMake(8, 8, 304, 165)];
    messageBody.layer.cornerRadius = 7;
    [messageBody setTag:101];
    [messageContainer addSubview:messageBody];
    [messageBody release];
    
    // Send button
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton setFrame:CGRectMake(235, 193, 70, 30)];
    [messageContainer addSubview:sendButton];
    [sendButton addTarget:self action:@selector(sendPushMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    // Cancel button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setFrame:CGRectMake(155, 193, 70, 30)];
    [messageContainer addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelPushMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [messageBody becomeFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        messageContainer.alpha = 1;
    }];
}

// send push notification
-(void) sendPushMessage:(id)sender{
    
    // create message
    NSString *mesage = [NSString stringWithFormat:@"QB SuperSample. Message from %@: %@", 
                        [[UsersProvider sharedProvider] currentUser].qbUser.login,  
                        ((UITextView *)[messageContainer viewWithTag:101]).text];

    NSMutableDictionary *payload = [NSMutableDictionary dictionary];
    NSMutableDictionary *aps = [NSMutableDictionary dictionary];
    [aps setObject:@"default" forKey:QBMPushMessageSoundKey];
    [aps setObject:mesage forKey:QBMPushMessageAlertKey];
    [payload setObject:aps forKey:QBMPushMessageApsKey];
     
    QBMPushMessage *message = [[QBMPushMessage alloc] initWithPayload:payload];
     
    // recipient id (user id)
    NSNumber *userID = [[UsersProvider sharedProvider] userByID:self.objectID error:nil].uid;
    
    
    // Send push
    [QBMessages TSendPush:message toUsers:[userID stringValue] isDevelopmentEnvironment:YES delegate:self];

    [message release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void) cancelPushMessage:(id)sender{
    [messageContainer removeFromSuperview];
    messageContainer = nil;
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result*)result{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // Send Push result
    if([result isKindOfClass:[QBMSendPushTaskResult class]]){
        
        // Success result
        if(result.success){
            
            // hide message view
            [messageContainer removeFromSuperview];
            messageContainer = nil;
            
            [self showMessage:NSLocalizedString(@"Message sent successfully", "") message:nil delegate:nil];
            
        // Show errors
        }else{
            [self processErrors:result.errors];
        }
    }
}

- (void) dealloc {
    [objectID release];
    
    [super dealloc];
}

@end