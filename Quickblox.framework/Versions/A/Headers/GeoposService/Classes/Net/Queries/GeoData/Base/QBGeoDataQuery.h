//
//  GeoDataQuery.h
//  GeoposService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBGeoDataQuery : QBGeoposServiceQuery {
@private
	QBGeoData* geoData;
}

@property (nonatomic, readonly) QBGeoData* geoData;

-(id)initWithGeoData:(QBGeoData*)geodata;

@end

