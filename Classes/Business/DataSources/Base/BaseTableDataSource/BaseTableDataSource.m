//
//  BaseTableDataSource.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/4/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "BaseTableDataSource.h"

#import "BaseTableCell.h"

@implementation BaseTableDataSource

@synthesize tabView;
@synthesize lastIndexPath;

- (void)releaseObjects {
    self.tabView = nil;
    self.lastIndexPath = nil;
    
    [super releaseObjects];
}

#pragma mark -
#pragma mark Readonly settings

- (Class)cellClass {
	return [BaseTableCell class];
}
- (NSString*)cellIdentifier {
	return @"BaseTableCell";
}
- (BOOL)cancelSelectionForRowAtIndexPath:(NSIndexPath*)indexPath {
	return YES;
}
- (BOOL)canEditRows {
	return YES;
}
- (BOOL)canMoveRows {
	return NO;
}
- (BOOL)loadCellFromNib {
	return NO;
}
- (NSString*)cellNibName {
	return  @"";
}

#pragma mark -
#pragma mark Sections Settings

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"";
}

#pragma mark -
#pragma mark Row Settings

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[self cellClass] cellHeight];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableCell *cell = (BaseTableCell*)[tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    if (cell == nil) {
		if ([self loadCellFromNib]) {
			NSArray *objects = [[NSBundle mainBundle] loadNibNamed:[self cellNibName] owner:nil options:nil];
			
			for (id obj in objects) {
				if ([[obj reuseIdentifier] isEqualToString:[self cellIdentifier]]) {
					cell = (BaseTableCell *)obj;
				}
			}
		} else {
			cell = [[[[self cellClass] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self cellIdentifier]] autorelease];
		}
    }
	
	[self configureCell:cell atIndex:indexPath];
    
    return cell;
}

- (BOOL)canSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	return YES;
}
- (NSObject*) dataForIndexPath:(NSIndexPath*)indexPath {
	return nil;
}
- (void)configureCell:(BaseTableCell*)cell atIndex:(NSIndexPath*)indexPath {
	cell.data = [self dataForIndexPath:indexPath];
	[cell updateCellAtIndexPath:indexPath];
}

#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self canSelectRowAtIndexPath:indexPath])
		return indexPath;
	
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self cancelSelectionForRowAtIndexPath:indexPath])
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	self.lastIndexPath = indexPath;
    if (delegate)
		if ([delegate respondsToSelector:@selector(dataSource:selectRowWithObject:atIndexPath:)])
			[delegate dataSource:self selectRowWithObject:[self dataForIndexPath:indexPath] atIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	if ([self cancelSelectionForRowAtIndexPath:indexPath])
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	self.lastIndexPath = indexPath;
    if (delegate)
		if ([delegate respondsToSelector:@selector(detailRowWithObject:atIndexPath:)])
			[delegate dataSource:self detailRowWithObject:[self dataForIndexPath:indexPath] atIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.canMoveRows;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return self.canEditRows;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self canEditRows] && tableView.editing)
		return UITableViewCellEditingStyleDelete;
	
	return UITableViewCellEditingStyleNone;
}

#pragma mark -
#pragma mark Procedures

- (void)reloadData {
	self.lastIndexPath = nil;
	[super reloadData];
}
- (void)refreshLastCell {
	if (self.lastIndexPath != nil)
		[tabView reloadRowsAtIndexPaths:[NSArray arrayWithObject:lastIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
