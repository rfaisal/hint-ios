//
//

@interface LoadBinaryQuery : Query {
	NSURL *URL;
}

@property (nonatomic, retain) NSURL *URL;

- (id)initWithURL:(NSURL *)url;

@end
