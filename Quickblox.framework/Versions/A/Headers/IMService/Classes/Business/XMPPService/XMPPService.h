//
//  XMPPService.h
//  GayDar
//


//

#define MAXCountOfSymbols 255

static NSString* const emailForConnect = @"%@/%@";
static NSString* const emailUserName = @"%@";

@interface XMPPService : NSObject {
	XMPPStream *xmppStream;
	XMPPRoster *xmppRoster;
	XMPPRosterMemoryStorage *xmppRosterStorage;
	
	NSString *user;
    NSString *commonPassword;
    NSString *appExtension;
	
	BOOL isOpen;
	BOOL isRegistrInProgress;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	NSObject<IMServiceDelegate> *delegate;
}

@property (nonatomic, retain) NSString *user;
@property (nonatomic, retain) NSString *commonPassword;
@property (nonatomic, retain) NSString *appExtension;

@property (nonatomic, assign) NSObject<IMServiceDelegate> *delegate;

@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, readonly) XMPPRosterMemoryStorage *xmppRosterStorage;
@property (nonatomic, readonly) BOOL isOpen;

+ (XMPPService*) sharedService;

- (void) connectWithUser:(NSString*)userName;
- (void) disconnect;

- (void) goOnline;
- (void) goOffline;

- (void) registrUser:(NSString*)userName;

- (void) sendMessage:(MBIMMessage*)message;

@end
