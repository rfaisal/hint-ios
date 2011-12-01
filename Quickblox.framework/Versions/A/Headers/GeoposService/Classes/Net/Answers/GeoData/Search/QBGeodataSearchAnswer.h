//
//  GeodataSearchAnswer.h
//  GeoposService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBGeodataSearchAnswer : PagedAnswer 
{
	QBUserAnswer *userAnswer;
	QBGeoData* currentItem;
	NSMutableArray* geodatas;
}

@property (nonatomic, retain) NSMutableArray* geodatas;
@property (nonatomic, assign) QBGeoData* currentItem;


@end
