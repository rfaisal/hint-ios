//
//  QBUUserCompleteFacebookAuthQuery.h
//  Mobserv
//
//  Created by Yuriy Kuntyy on 10.05.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUUserCompleteFacebookAuthQuery :  QBUUserQuery 
{
	NSString *redirectURL;
	QBUUser *user;
}

@property (nonatomic, retain) NSString *redirectURL;
@property (nonatomic, retain) QBUUser *user;

- (id)initWithUser:(QBUUser*)user redirectURL:(NSString*)tredirectURL;

@end
