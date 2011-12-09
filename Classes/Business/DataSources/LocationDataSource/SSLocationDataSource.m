//
//
//

#import "SSLocationDataSource.h"

@implementation SSLocationDataSource

+ (SSLocationDataSource *)sharedDataSource {
	static id instance = nil;
	@synchronized (self) {
		if (instance == nil){
			instance = [[self alloc] init];
		}
	}
	return instance;
}

-(id)init{ 
	if(self = [super init]) { 
		locationManager = [[CLLocationManager alloc] init];  
		locationManager.distanceFilter = 10;  		
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; 
        locationManager.delegate = self;
		[locationManager startUpdatingLocation];  
	} 
	return self; 
} 

-(CLLocation *) getCurrentLocation{
    return [locationManager location];
}

-(void)dealloc{
    [locationManager release];
    
    [super dealloc];
}

- (BOOL)isLocationValid{
	float dLat = fabs(locationManager.location.coordinate.latitude - 0.0f);
	float dLon = fabs(locationManager.location.coordinate.longitude - 0.0f);
	return dLat > 0.001 && dLon > 0.001;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"Location updated from %@ to %@", oldLocation, newLocation);
}


@end