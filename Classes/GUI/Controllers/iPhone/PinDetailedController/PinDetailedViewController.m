//
//  PinDetailedView.m
//  FansNet
//
//  Created by Andrew Kopanev on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PinDetailedViewController.h"

//Data
#import "Users.h"
#import "UsersProvider.h"
#import "SourceImages.h"

//Helpers
#import "Resources.h"


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
        userLogin.text = user.mbUser.login;
        if(userLogin.text == nil || [userLogin.text isEqualToString:@""]){
            userLogin.text = @"anonymous";
        }
        
        // full name
        userFullName.text = user.mbUser.fullName;
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

- (void) dealloc {
    [objectID release];
    
    [super dealloc];
}

@end