//
//  GeoDataCreateQuery.h
//  GeoposService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBGeoData;

@interface QBGeoDataCreateQuery : QBGeoDataQuery {
	QBGeoData* geodata;
}

@property (nonatomic, retain) QBGeoData* geodata;

-(id)initWithGeoData:(QBGeoData*)searchRequest;

@end
