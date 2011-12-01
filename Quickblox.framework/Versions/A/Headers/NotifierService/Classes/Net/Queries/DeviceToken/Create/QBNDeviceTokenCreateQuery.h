//
//  QBNDeviceTokenCreateQuery.h
//  BaseServiceStaticLibrary
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNDeviceTokenCreateQuery : QBNDeviceTokenQuery {
	QBNDeviceToken* deviceToken;
}
@property (nonatomic,retain) QBNDeviceToken* deviceToken;
- (id)initWithDeviceToken:(QBNDeviceToken*)token;
@end
