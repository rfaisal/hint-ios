//
//  BaseTableDataSource.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/4/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "LoadableDataSource.h"

@class BaseTableCell;

@interface BaseTableDataSource : LoadableDataSource <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tabView;
	
	NSIndexPath *lastIndexPath;
}

@property (nonatomic, retain) IBOutlet UITableView *tabView;
@property (nonatomic, retain) NSIndexPath *lastIndexPath;

@property (nonatomic, readonly) Class cellClass;
@property (nonatomic, readonly) NSString *cellIdentifier;
@property (nonatomic, readonly) BOOL canEditRows;
@property (nonatomic, readonly) BOOL canMoveRows;
@property (nonatomic, readonly) BOOL loadCellFromNib;
@property (nonatomic, readonly) NSString *cellNibName;

- (BOOL)cancelSelectionForRowAtIndexPath:(NSIndexPath*)indexPath;

- (BOOL)canSelectRowAtIndexPath:(NSIndexPath*)indexPath;
- (NSObject*)dataForIndexPath:(NSIndexPath*)indexPath;
- (void)configureCell:(BaseTableCell*)cell atIndex:(NSIndexPath*)indexPath;

@end
