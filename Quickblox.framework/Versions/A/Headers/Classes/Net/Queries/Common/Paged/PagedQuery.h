//
//  PagedQuery.h
//  GeoposService
//
//

#import <Foundation/Foundation.h>


@interface PagedQuery : Query {
	NSUInteger page;
	NSUInteger pagesize;
}

- (id)init;

@property (nonatomic) NSUInteger page;
@property (nonatomic) NSUInteger pagesize;

@end
