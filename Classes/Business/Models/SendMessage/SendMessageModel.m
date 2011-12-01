//
//  SendMessageModel.m
//  
//
//

#import "SendMessageModel.h"

@implementation SendMessageModel

@synthesize messageText, to, login;

-(void) dealloc
{
	[messageText release];
	[to release];
	[login release];
	
	[super dealloc];
}

-(id) initWithMessage:(NSString*)_messageText to:(NSString*)_to login:(NSString*)_login
{
	if(self = [super init])
	{
		self.messageText = _messageText;
		self.to = _to;
		self.login = _login;
	}
	
	return self;
}

@end
