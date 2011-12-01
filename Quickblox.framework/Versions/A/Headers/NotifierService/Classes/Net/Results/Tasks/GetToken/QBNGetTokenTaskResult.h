//
//  QBNGetTokenTaskResult.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNGetTokenTaskResult : TaskResult {
	NSString* token;
}
@property (nonatomic,retain) NSString* token;
@end
