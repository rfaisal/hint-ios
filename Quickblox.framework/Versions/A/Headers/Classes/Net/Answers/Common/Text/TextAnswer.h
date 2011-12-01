//
//  TextAnswer.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TextAnswer : RestAnswer {
	NSString* text;
}
@property (nonatomic,retain) NSString* text;
@end
