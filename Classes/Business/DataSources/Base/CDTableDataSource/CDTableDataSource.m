//
//  CDGridDataSource.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/9/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "CDTableDataSource.h"

#import "EntityProvider.h"

#import "BaseTableCell.h"

@implementation CDTableDataSource

@synthesize featchedResultsController;

- (void)releaseObjects {
    [featchedResultsController release];
    
    [super releaseObjects];
}

#pragma mark -
#pragma mark Configs

- (EntityProvider *)provider {
    return nil;
}
- (NSArray *)sortDescriptors {
    return nil;
}
- (NSPredicate *)fetchPredicate {
    return nil;
}
-(NSUInteger)fetchLimit
{
    return 0;
}

#pragma mark -
#pragma mark Table View 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[featchedResultsController sections] count] > 0 ? [[featchedResultsController sections] count] : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if ([[featchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[featchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}

- (NSObject*) dataForIndexPath:(NSIndexPath*)indexPath {
    if ([[featchedResultsController sections] count] > [indexPath section])
        if ([[[featchedResultsController sections] objectAtIndex:indexPath.section] numberOfObjects] > [indexPath row])
            return [featchedResultsController objectAtIndexPath:indexPath];
    
    return nil;
}
#pragma mark -
#pragma mark Procedures

- (void)reloadData {
    [super reloadData];
    
    [[self featchedResultsController].fetchRequest setPredicate:self.fetchPredicate];
    [[self featchedResultsController].fetchRequest setSortDescriptors:self.sortDescriptors];
    [[self featchedResultsController].fetchRequest setFetchLimit:self.fetchLimit];
    
    NSError *error = nil;
    if (![[self featchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
//    NSLog(@"[self featchedResultsController]: %@",[[self featchedResultsController] fetchedObjects]);
    
    [self.tabView reloadData];
}

#pragma mark -
#pragma mark Fetched Procedures

- (NSFetchedResultsController *)featchedResultsController {
    if (featchedResultsController == nil) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescroption = [NSEntityDescription entityForName:self.provider.entityName inManagedObjectContext:self.provider.managedObjectContext];
        
        [request setEntity:entityDescroption];
        [request setPredicate:self.fetchPredicate];
        [request setSortDescriptors:self.sortDescriptors];
        [request setFetchLimit:self.fetchLimit];
        
        NSFetchedResultsController *aFetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.provider.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        aFetchedResultController.delegate = self;
        self.featchedResultsController = aFetchedResultController;
        
        [aFetchedResultController release];
        [request release];
    }
    
    return featchedResultsController;
}

#pragma mark -
#pragma mark FetchedResult Controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tabView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tabView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(BaseTableCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] atIndex:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) 
	{
        case NSFetchedResultsChangeInsert:
            [self.tabView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tabView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tabView endUpdates];
    [self loadFinished];
}

@end
