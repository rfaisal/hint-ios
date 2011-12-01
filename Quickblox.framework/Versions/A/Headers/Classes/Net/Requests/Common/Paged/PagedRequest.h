//
//  PagedRequest.h
//  GeoposService
//
//

#import <Foundation/Foundation.h>

@class PagedResult;
@interface PagedRequest : Request {
@protected
	NSUInteger page;
	NSUInteger pageSize;
}
@property (nonatomic) NSUInteger page;
@property (nonatomic) NSUInteger pageSize;

-(PagedResult*)performWithPage:(NSUInteger)newPageNumber pageSize:(NSUInteger)newPageSize;
-(PagedResult*)performWithPage:(NSUInteger)newPageNumber;
@end
