//
//  BaseTableCell.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/4/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "BaseTableCell.h"

@implementation BaseTableCell

@synthesize data;

#pragma mark -
#pragma mark Release

- (void)dealloc {
	[self unsubscribe];
	[self releaseObjects];
	
    [super dealloc];
}

- (void)releaseObjects {
	self.data = nil;
}

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		[self reinit];
		[self subscribe];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self reinit];
		[self subscribe];
	}
	return self;
}

#pragma mark -
#pragma mark UITableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
}

#pragma mark -
#pragma mark Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	if([@"data" isEqualToString:keyPath]){
		[self reloadCellSateWithData:self.data];
	} else if([super respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)])
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark -
#pragma mark Customize

- (void)updateCellAtIndexPath:(NSIndexPath*)indexPath {
}
- (void)reinit {
}
- (void)reloadCellSateWithData:(NSObject*)newData {
}

#pragma mark -
#pragma mark Subscribers

- (void)subscribe {
	[self addObserver:self forKeyPath:@"data" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
- (void)unsubscribe {
	[self removeObserver:self forKeyPath:@"data"];
}

+ (CGFloat)cellHeight {
    return 44.0;
}

@end
