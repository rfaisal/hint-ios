//
//  QBGeodataSearchQuery.h
//  GeoposService
//

//  Copyright 2010 m. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBGeodataSearchQuery : QBGeoDataQuery {
	QBGeoDataSearchRequest* searchRequest;
}
@property (nonatomic,readonly) QBGeoDataSearchRequest* searchRequest;

-(id)initWithRequest:(QBGeoDataSearchRequest*)searchrequest;
@end
