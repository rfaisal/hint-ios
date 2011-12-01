//
//  XMPPService.h
//  
//


//

#import <Foundation/Foundation.h>

#define MAXCountOfSymbols 255

@class XMPPStream;
@class XMPPRoster;
@class XMPPRosterCoreDataStorage;
@class SendMessageModel;
@class FileModel;

@interface XMPPService : NSObject {
	XMPPStream *xmppStream;
	XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
	
	NSString *password;
	
	BOOL isOpen;
	BOOL isRegistrInProgress;
	
	BOOL shouldConnect;
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	NSOperationQueue *messageQueue;
}

@property (nonatomic, assign) BOOL shouldConnect;
@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, readonly) BOOL isOpen;

+ (XMPPService*) sharedService;

- (void) connect;
- (void) disconnect;

- (void) goOnline;
- (void) goOffline;

- (void) registrUser;   

- (void) sendMessage:(NSString*)messageText to:(NSString*)to login:(NSString*)login;
- (void) sendMessage:(SendMessageModel*)messageModel;
- (void) sendLocationTo:(NSString*)to login:(NSString*)login;
- (void) sendImage:(FileModel*)file to:(NSString*)to login:(NSString*)login;

@end
