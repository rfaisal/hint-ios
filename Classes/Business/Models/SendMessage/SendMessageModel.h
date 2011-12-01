//
//  SendMessageModel.h
//  
//
//

#import <Foundation/Foundation.h>


@interface SendMessageModel : NSObject 
{
	NSString *messageText, *to, *login;
}

@property (nonatomic, retain) NSString *messageText, *to, *login;

-(id) initWithMessage:(NSString*)messageText to:(NSString*)to login:(NSString*)login;

@end
