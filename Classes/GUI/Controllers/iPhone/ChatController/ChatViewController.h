//
//  ChatViewController.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "SubscribedViewController.h"

@class ChatListDataSource;
@class PrivateChatViewController;

@interface ChatViewController : SubscribedViewController<ActionStatusDelegate>{

    NSArray *tableView;
    UITableView *tabView;
}

@property (nonatomic, retain) IBOutlet ChatListDataSource *chatDataSource;
@property (nonatomic, retain) IBOutlet UITableView *tabView;

@property (nonatomic, retain) IBOutlet UITextField* textField;
@property (retain, nonatomic) IBOutlet PrivateChatViewController *privateChatController;

-(IBAction) sendAction:(id)sender;



@end

