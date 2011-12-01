//

//

#import "LoadBinaryQuery.h"
#import "LoadBinaryAnswer.h"

@implementation LoadBinaryQuery

@synthesize URL;

- (void)dealloc {
	[URL release];
	
	[super dealloc];
}

- (id)initWithURL:(NSURL*)_url {
    self = [super init];
	if (self) {
		self.URL = _url;
	}
	return self;
}

- (RestAnswer *)allocAnswer {
	return [LoadBinaryAnswer alloc];
}

- (void)setMethod:(RestRequest *)request {
	request.method = RestMethodKindGET;
}

- (NSString *)url {
	return [URL absoluteString];
}

@end
