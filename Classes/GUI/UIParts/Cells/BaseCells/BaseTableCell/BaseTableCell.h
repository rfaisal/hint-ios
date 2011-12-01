//
//  BaseTableCell.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/4/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface BaseTableCell : UITableViewCell {
    NSObject *data;
}

@property (nonatomic, retain) NSObject *data;

- (void) updateCellAtIndexPath:(NSIndexPath*)indexPath;

- (void) releaseObjects;

- (void) subscribe;
- (void) unsubscribe;

- (void) reinit;
- (void) reloadCellSateWithData:(NSObject*)newData;

+ (CGFloat)cellHeight;

@end
