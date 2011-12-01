//
//  QBGeoData.h
//  GeoposService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBGeoDataSearchRequest,QBGeoDataSearchResult,QBGeoDataResult;
@interface QBGeoData : Entity {
@private
	CLLocationDegrees latitude;
	CLLocationDegrees longitude;
	NSDate* created_at;
	QBUser* user;
	NSString* status;
}
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic, retain) NSDate* created_at;
@property (nonatomic, retain) QBUser* user;
@property (nonatomic, retain) NSString* status;
+ (QBGeoData*)currentGeoData;
+ (QBGeoDataResult*)CreateGeoData:(QBGeoData*)geodata;
+ (QBGeoDataSearchResult*)FindForRequest:(QBGeoDataSearchRequest*)request;

@end
