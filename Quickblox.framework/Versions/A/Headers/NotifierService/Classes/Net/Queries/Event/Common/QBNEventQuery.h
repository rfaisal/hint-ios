//
//  QBNEventQuery.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNEventQuery : QBNotifierServiceQuery {
	QBNEvent* event;
}
@property (nonatomic,retain) QBNEvent* event;
- (id)initWithEvent:(QBNEvent*)event;
@end
