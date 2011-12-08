//


#import "userAnnotation.h"


@implementation userAnnotation
@synthesize  coordinate, userModel;

- (id)initWithCoordinate: (CLLocationCoordinate2D) c {
	self.coordinate = c;
	return self;
}

- (void) dealloc {
    self.userModel = nil;

	[super dealloc];
}

@end