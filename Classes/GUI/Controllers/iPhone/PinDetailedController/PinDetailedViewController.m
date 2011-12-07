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
@synthesize scrollView;
@synthesize imageView;
@synthesize caption;
@synthesize manPosition;
@synthesize infoView;
@synthesize photo;

- (void)releaseProperties {
    self.scrollView = nil;
    self.imageView = nil;
    self.caption = nil;
    self.manPosition = nil;
    self.infoView = nil;
    
    [super releaseProperties];
}

- (void)releaseAll {
    self.objectID = nil;
    
    [super releaseAll];
}

- (void)subscribe {
    [super subscribe];
    
    [self addObserver:self forKeyPath:@"objectID" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)unsubscribe {
    [self removeObserver:self forKeyPath:@"objectID"];
    
    [super unsubscribe];
}

- (void)startInit {
    [super startInit];
    
    [self.infoView setBackgroundColor:[UIColor clearColor]];
    self.infoView.opaque = NO;
}

- (void)handleTap:(UITapGestureRecognizer *) gesture{
    Users *user = [[UsersProvider sharedProvider] currentUser];
    
    if(objectID == user.objectID){
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:nOpenChatView 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObject:objectID forKey:nkData]];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 200);
    [super viewDidDisappear:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@"self.objectID=%@", self.objectID);
    
    if ([@"objectID" isEqualToString:keyPath]) {
        NSError *error = nil;
        Users *user = [[UsersProvider sharedProvider] userByID:self.objectID error:&error];
        if (error) {
            NSLog(@"error did get userByID: %@",error);
            return;
        }
        
        self.caption.text = user.mbUser.login;
        if(self.caption.text == nil || [self.caption.text isEqualToString:@""]){
            self.caption.text = @"anonymous";
        }
            
        SourceImages *sourceImage = user.photo;    
        self.photo.image = [UIImage imageWithContentsOfFile:[Resources fullPathForFileWithName:sourceImage.local_url]];
        if(self.photo.image == nil){
            self.photo.image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"user" ofType:@"png"]];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [self.photo addGestureRecognizer:tap];
        [tap release];
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(IBAction) close:(id)sender{
    [self.parentCustomModalController dismissCustomModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [photo release];
    
    [super dealloc];
}

- (void)viewDidUnload {
    [self setPhoto:nil];
    
    [super viewDidUnload];
}

@end