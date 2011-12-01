//
//  QBNEventFireQuery.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNEventFireQuery : QBNEventQuery {
	NSUInteger eventID;
}
@property (nonatomic) NSUInteger eventID;
- (id)initWithEventID:(NSUInteger)eventID;
@end
