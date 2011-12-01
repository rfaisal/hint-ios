//
//  PrivateChatViewController.h
//  SuperSample
//
//  Created by Danil on 25.10.11.
//  Copyright (c) 2011 YAS. All rights reserved.
//

#import "SubscribedViewController.h"

@class PrivateChatListDataSource;

@interface PrivateChatViewController : SubscribedViewController{
    NSManagedObjectID *objectID;
    UITableView *tabView;

}

@property (retain, nonatomic) IBOutlet PrivateChatListDataSource *privateChatDataSource;
@property (retain, nonatomic) IBOutlet UITextField *textView;
@property (nonatomic, retain) IBOutlet UITableView *tabView;


@property (nonatomic, retain) NSManagedObjectID *objectID;

- (IBAction)sendAction:(id)sender;

@end
