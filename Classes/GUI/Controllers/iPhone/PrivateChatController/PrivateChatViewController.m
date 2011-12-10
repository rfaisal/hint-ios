//
//  PrivateChatViewController.m
//  SuperSample
//
//  Created by Danil on 25.10.11.
//  Copyright (c) 2011 YAS. All rights reserved.
//

#import "PrivateChatViewController.h"

//Data
#import "PrivateChatListDataSource.h"
#import "Users.h"
#import "UsersProvider.h"

//Service
#import "XMPPService.h"

@implementation PrivateChatViewController
@synthesize privateChatDataSource;
@synthesize textView;
@synthesize tabView;
@synthesize objectID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)subscribe {
    [super subscribe];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageArrived:) name:nMessageArrived object:nil];
    
    [self addObserver:self forKeyPath:@"objectID" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)unsubscribe {
    [self removeObserver:self forKeyPath:@"objectID"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nMessageArrived object:nil];

    [super unsubscribe];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([@"objectID" isEqualToString:keyPath]) {
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self.tabView addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload{
    [self setPrivateChatDataSource:nil];
    [self setTabView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dismissKeyboard {
    [textView resignFirstResponder];
}

- (void)dealloc {
    [privateChatDataSource release];
    [textView release];
    [tabView release];
    
    [super dealloc];
}

- (IBAction)sendAction:(id)sender {
    NSError *error = nil;
    Users *user = [[UsersProvider sharedProvider] userByID:self.objectID error:&error];
    if (error) {
        NSLog(@"error did get userByID: %@",error);
    } 
    NSString *to = [NSString stringWithFormat:emailUserName, [user.uid intValue]];		
    
    [[XMPPService sharedService] sendMessage:textView.text to:to login:user.mbUser.login];
}

-(void)newMessageArrived:(NSNotification*)notification{
    [privateChatDataSource reloadData];
}

@end