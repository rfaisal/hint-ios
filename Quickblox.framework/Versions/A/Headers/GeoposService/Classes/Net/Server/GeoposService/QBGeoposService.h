//
//  GeoposService.h
//  GeoposService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBGeoposService : BaseService {

}

+ (QBGeoDataResult*)PostGeoData:(QBGeoData*)data;
+ (NSObject<Cancelable>*)postGeoData:(QBGeoData*)data delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)postGeoData:(QBGeoData*)data delegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;
+ (QBGeoDataSearchResult*)FindGeoData:(QBGeoDataSearchRequest*)geoDataRequest;
+ (NSObject<Cancelable>*)findGeoData:(QBGeoDataSearchRequest*)geoDataRequest delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)findGeoData:(QBGeoDataSearchRequest*)geoDataRequest delegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;
+ (QBUserResult*)CreateUser:(QBUser*)user;
+ (QBUserResult*)EditUser:(QBUser*)user;
+ (Result*)DeleteUser:(NSUInteger)userID;
+ (QBUserResult*)GetUser:(NSUInteger)userID;

@end
