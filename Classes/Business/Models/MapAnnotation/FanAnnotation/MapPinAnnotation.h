//


@class MapPinView;
@class Users;

@interface MapPinAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;	
    Users *userModel;
}

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain)  Users *userModel;

- (id)initWithCoordinate: (CLLocationCoordinate2D) c;

@end