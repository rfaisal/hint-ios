#import <Foundation/Foundation.h>

@class XMPPJID;
@class XMPPPresence;
@class XMPPResourceMemoryStorage;


@interface XMPPUserMemoryStorage : NSObject <XMPPUser, NSCoding>
{
	XMPPJID *jid;
	NSMutableDictionary *itemAttributes;
	
	NSMutableDictionary *resources;
	XMPPResourceMemoryStorage *primaryResource;
	
	NSInteger tag;
}

- (id)initWithJID:(XMPPJID *)aJid;
- (id)initWithItem:(NSXMLElement *)item;

- (void)clearAllResources;

- (void)updateWithItem:(NSXMLElement *)item;
- (void)updateWithPresence:(XMPPPresence *)presence;

- (NSInteger)tag;
- (void)setTag:(NSInteger)anInt;

@end
