//
//  LoadableDataSource.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/5/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "LoadableDataSource.h"

@implementation LoadableDataSource

@synthesize delegate;
@synthesize canceler;

#pragma mark -
#pragma mark Release

- (void)dealloc {
	[self unsubscribe];
	[self releaseObjects];
	
	[super dealloc];
}

- (void)releaseObjects {
	self.canceler = nil;
}

- (void)clearCashData {
}

#pragma mark -
#pragma mark Initialization

- (id)init {
    self = [super init];
	if(self)
	{
		[self subscribe];
		[self startInit];
	}
	return self;
}

- (void)startInit {
}

#pragma mark -
#pragma mark Subscribers

- (void)subscribe {}
- (void)unsubscribe {}

#pragma mark -
#pragma mark Query Status Delegate

- (void)setProgress:(float)progress {
	[self setLoadProgress:progress];
}
- (void)completedWithResult:(Result *)result {
	[self completedWithResult:result context:nil];
}
- (void)completedWithResult:(Result *)result context:(void *)contextInfo {
	if (result.success) {
		[self loadData:result];
		[self loadFinished];
	} else {
		[self loadFinished];
		[self loadError:result.errors];
	}
}

#pragma mark -
#pragma mark Procedures

- (void)reloadData {
	[self loadStarted];
}
- (void)cancelReload {
	if (canceler != nil) {
		[canceler cancel];
        self.canceler = nil;
    }
	[self loadFinished];
}
- (void)refreshLastCell {
}

- (void)loadData:(Result*)result {
}

- (void)loadStarted {
	if (delegate && [delegate respondsToSelector:@selector(dataStartLoading:)]) {
		[delegate dataStartLoading:self];
	}
}
- (void)setLoadProgress:(float)progress {
    if (delegate && [delegate respondsToSelector:@selector(dataSource:loadProgressChangeTo:)]) {
		[delegate dataSource:self loadProgressChangeTo:progress];
	}
}
- (void)loadFinished {
	if (delegate && [delegate respondsToSelector:@selector(dataLoaded:)]) {
		[delegate dataLoaded:self];
	}
}
- (void)loadError:(NSArray*)errors {
}


@end
