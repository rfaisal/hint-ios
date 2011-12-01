//
//  PagedResult.h
//  GeoposService
//
//

#import <Foundation/Foundation.h>


@interface PagedResult : Result {

}
@property(nonatomic,readonly) NSUInteger pages;
@property(nonatomic,readonly) NSUInteger currentPage;
-(PagedResult*)askForPage:(NSUInteger)page;
-(PagedResult*)nextPage;
-(PagedResult*)prevPage;
@end
