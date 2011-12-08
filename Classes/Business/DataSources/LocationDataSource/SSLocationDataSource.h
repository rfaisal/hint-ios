//
//
//



@interface SSLocationDataSource : NSObject <CLLocationManagerDelegate>{ 
    CLLocationManager *locationManager;
} 

+ (SSLocationDataSource *)sharedDataSource;
- (CLLocation *) getCurrentLocation;
- (BOOL) isLocationValid;

@end 