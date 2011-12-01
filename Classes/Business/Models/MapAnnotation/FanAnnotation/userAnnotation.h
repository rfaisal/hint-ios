//


@class PinView;
@class Users;
@interface userAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;	
    Users* userModel;

}

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString * title;	
@property (nonatomic, retain) NSString * subTitle;	
@property(nonatomic, retain)  Users* userModel;


@end
