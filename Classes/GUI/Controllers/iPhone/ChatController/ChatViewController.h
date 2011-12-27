//
//  ChatViewController.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "SubscribedViewController.h"

@class ChatListDataSource;

@interface ChatViewController : SubscribedViewController<ActionStatusDelegate>{
    NSArray *tableView;
    UITableView *tabView;
    
    UIActivityIndicatorView *wheel;
    NSTimer *updateGeoDataTimer;
}

@property (nonatomic, retain) IBOutlet ChatListDataSource *chatDataSource;
@property (nonatomic, retain) IBOutlet UITableView *tabView;
@property (nonatomic, retain) IBOutlet UITextField *textField;

- (IBAction) sendAction:(id)sender;
- (void) searchGeoData:(NSTimer *) timer;
- (void) startSearchGeoData;

-(void) processGeoDatumAsync:(QBGeoData *)data;
-(void) processGeoDataAsync:(NSArray *)geodata;

@end