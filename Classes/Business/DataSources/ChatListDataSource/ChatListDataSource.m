//
//  ChatListDataSource.m
//  SuperSample
//
//  Created by Danil on 14.09.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "ChatListDataSource.h"
#import "ChatListProvider.h"
#import "MessageCell.h"

@implementation ChatListDataSource

- (EntityProvider *)provider {
    return [ChatListProvider sharedProvider];
}

- (NSArray *)sortDescriptors {
    return [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:NO]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell=[self tableView: tableView cellForRowAtIndexPath:indexPath];
    if([cell isMemberOfClass:[MessageCell class]]){
        return [(MessageCell*)cell getCellHeight];
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
    return [MessageCell class];
}
- (NSString *)cellIdentifier {
    return @"MessageCell";
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
