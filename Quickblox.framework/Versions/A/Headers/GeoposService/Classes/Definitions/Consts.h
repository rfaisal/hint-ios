



#define kGeoposServiceErrorDomain @"GeoposServiceErrorDomain"
#define kGeoposServiceException @"GeoposServiceException"


#define kGeoposServiceDefaultSort GeoDataSortByKindNone
#define kGeoposServiceDefaultSortIsAsc NO
#define kGeoposServiceDefaultLastOnly NO
#define kGeoposServiceCoordinateNotSet 200
#define kGeoposServiceRadiusNotSet 0
#define kGeoposServiceGeoPointNotSet [QBGPConst coordinateWithLatitude:kGeoposServiceCoordinateNotSet longitude:kGeoposServiceCoordinateNotSet]
#define kGeoposServiceGeoRectNotSet  [QBGPConst geodataRectWithNW:kGeoposServiceGeoPointNotSet SE:kGeoposServiceGeoPointNotSet]
#define kGeoposServiceLocationNotSet [[[CLLocation alloc] initWithLatitude:kGeoposServiceCoordinateNotSet longitude:kGeoposServiceCoordinateNotSet] autorelease]

#define EGP(B,C) E(kGeoposServiceException, B,C)
#define EGP2(B) E2(kGeoposServiceException, B)