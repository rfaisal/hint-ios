//
//  CDGridDataSource.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/9/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "BaseTableDataSource.h"

@class EntityProvider;

@interface CDTableDataSource : BaseTableDataSource <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *featchedResultsController;
}

@property (nonatomic, retain) NSFetchedResultsController *featchedResultsController;

@property (nonatomic, readonly) EntityProvider *provider;
@property (nonatomic, readonly) NSArray *sortDescriptors;
@property (nonatomic, readonly) NSPredicate *fetchPredicate;
@property (nonatomic, readonly) NSUInteger fetchLimit;

@end
