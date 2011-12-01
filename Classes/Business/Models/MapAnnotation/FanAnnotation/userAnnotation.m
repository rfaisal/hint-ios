//


#import "userAnnotation.h"


@implementation userAnnotation
@synthesize title, subTitle, coordinate, userModel;

- (id)initWithCoordinate: (CLLocationCoordinate2D) c {
	self.coordinate = c;
	return self;
}


- (void) dealloc {

    userModel=nil;
    title=nil;
    subTitle=nil;

	[super dealloc];
	
//	[fanModel release];
}

@end
