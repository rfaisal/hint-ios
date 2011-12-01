//
//  GeoDataSearchRequest.h
//  GeoposService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBGeoData,QBGeoDataSearchResult;

@interface QBGeoDataSearchRequest : PagedRequest {
@private
	// Фильтры
	NSUInteger geoDataID;
	NSDate* created_at;
	NSUInteger userID;
	NSUInteger userAppID;
	NSString* userName;
	NSString* userGroup;
	
	// Диапазоны
	NSDate* min_created_at;
	NSDate* max_created_at;
	struct QBGeoDataRect geo_rect;
	NSInteger radius;
	
	// Сортировки
	BOOL sort_asc;
	enum QBGeoDataSortByKind sort_by;
	
	//Дополнительно
	BOOL last_only;
	CLLocationCoordinate2D current_position;
}

// Filters
@property (nonatomic) NSUInteger geoDataID;
@property (nonatomic, retain) NSDate* created_at;
@property (nonatomic) NSUInteger userID;
@property (nonatomic) NSUInteger userAppID;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* userGroup;

// Diapazones
@property (nonatomic, retain) NSDate* min_created_at;
@property (nonatomic, retain) NSDate* max_created_at;
@property (nonatomic) struct QBGeoDataRect geo_rect;
@property (nonatomic) NSInteger radius;

// Sorting
@property (nonatomic) BOOL sort_asc;
@property (nonatomic) enum QBGeoDataSortByKind sort_by;

// Special
@property (nonatomic) BOOL last_only;
@property (nonatomic) CLLocationCoordinate2D current_position;


@property (nonatomic, readonly) NSDictionary* dict;


@end
