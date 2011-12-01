//
//  PrivateChatListDataSource.m
//  SuperSample
//
//  Created by Danil on 25.10.11.
//  Copyright (c) 2011 YAS. All rights reserved.
//

#import "PrivateChatListDataSource.h"

#import "PrivateChatListProvider.h"
#import "PrivateMessageCell.h"

@implementation PrivateChatListDataSource

- (EntityProvider *)provider {
    return [PrivateChatListProvider sharedProvider];
}

- (NSArray *)sortDescriptors {
    return [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:NO]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell=[self tableView: tableView cellForRowAtIndexPath:indexPath];
    if([cell isMemberOfClass:[PrivateMessageCell class]]){
        return [(PrivateMessageCell*)cell getCellHeight];
    }
    return [[self cellClass] cellHeight];
}

- (NSObject *)dataForIndexPath:(NSIndexPath *)indexPath {
    return [featchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [super tableView:tabView numberOfRowsInSection:section];
}

- (Class)cellClass {
    return [PrivateMessageCell class];
}
- (NSString *)cellIdentifier {
    return @"PrivateMessageCell";
}

- (BOOL) canSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
        [super controller:controller didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
}


- (void)configureCell:(BaseTableCell*)cell atIndex:(NSIndexPath*)indexPath{
    [super configureCell:cell atIndex:indexPath];
}



@end
