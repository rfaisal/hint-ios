//
//  GPConst.h
//  GeoposService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBGPConst : NSObject {

}
+ (CLLocationCoordinate2D) coordinateWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
+ (struct QBGeoDataRect) geodataRectWithNW:(CLLocationCoordinate2D)NWpoint SE:(CLLocationCoordinate2D)SEpoint;
+ (BOOL) coordinate:(CLLocationCoordinate2D)coordinate1 isEqualTo:(CLLocationCoordinate2D)coordinate2;
+ (BOOL) geodataRect:(struct QBGeoDataRect)rect1 isEqualTo:(struct QBGeoDataRect)rect2;
@end
