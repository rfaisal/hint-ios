//

//

#import "SubscribedView.h"

@implementation SubscribedView

- (void) dealloc {
	[self unsubscribe];
	[self releaseProperties];
	
	[super dealloc];
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self subscribe];
		[self startInit];
    }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		[self subscribe];
		[self startInit];
    }
    return self;
}

- (void)addObservers:(NSObject*)observable forKeyPaths:(NSArray*)keyPaths{
	for(NSString* keyPath in keyPaths)
		[observable addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
}
- (void)removeObservers:(NSObject*)observable forKeyPaths:(NSArray*)keyPaths{
	for(NSString* keyPath in keyPaths)
		[observable removeObserver:self forKeyPath:keyPath];
}
- (void)addObserversForKeyPaths:(NSArray*)keyPaths{
	[self addObservers:self forKeyPaths:keyPaths];
}
- (void)removeObserversForKeyPaths:(NSArray*)keyPaths{
	[self removeObservers:self forKeyPaths:keyPaths];
}

- (void) subscribe {}
- (void) unsubscribe {}

- (void) startInit {}
- (void) releaseProperties {}

@end
