//
//
//

#import "GDConnectionHelper.h"


@implementation GDConnectionHelper
@synthesize connectionAvailable,inBackground,inactive;
+ (GDConnectionHelper*)instance {
	static id instance = nil;
	@synchronized (self) {
		if (instance == nil) instance = [[GDConnectionHelper alloc] init];										
	}
	return instance;
}
@end
