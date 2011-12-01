//
//  GeodataAnswer.h
//  GeoposService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//


@interface QBGeodataAnswer : XmlAnswer
{
@protected
	QBGeoData *geoData;
	QBUserAnswer *userAnswer;
}

@property (nonatomic, readonly) QBGeoData *geoData;

@end
