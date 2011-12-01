//
//  LocationDataSource.h
//  DocNog
//

//  Copyright 2009 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBLocationDataSource : NSObject<CLLocationManagerDelegate> {
	CLLocation* currentLocation;
	CLLocationManager* locationManager;
}
@property (nonatomic,readonly) CLLocation* currentLocation;
@property (nonatomic,readonly) CLLocationManager* locationManager;
@property (nonatomic,readonly) BOOL locationAvailable;
+(QBLocationDataSource*)instance;
@end
