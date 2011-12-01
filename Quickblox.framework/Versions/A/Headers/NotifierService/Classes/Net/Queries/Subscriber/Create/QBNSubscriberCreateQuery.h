//
//  QBNSubscriberCreateQuery.h
//  BaseServiceStaticLibrary
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNSubscriberCreateQuery : QBNSubscriberQuery {
	QBNSubscriber* subscriber;
}
@property (nonatomic,retain) QBNSubscriber* subscriber;
- (id)initWithSubscriber:(QBNSubscriber*)subscriber;
@end
