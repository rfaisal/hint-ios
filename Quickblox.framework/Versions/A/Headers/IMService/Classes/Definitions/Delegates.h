/*
 *  Delegates.h
 *  Mobserv
 *
 *  Created by Andrey Kozlov on 3/18/11.
 *  Copyright 2011 YAS. All rights reserved.
 *
 */

@class MBIMMessage;

@protocol IMServiceDelegate 
@optional

- (void) serviceDidConnect;
- (void) serviceConnectDidFail;

- (void) serviceDidRegistr;
- (void) serviceRegistrFail;

- (void) serviceDidReceaveMessage:(MBIMMessage*)message fromUser:(NSString*)userName;

- (void) serviceDidSendMessage:(MBIMMessage*)message;
- (void) serviceSendMessageDidFail;

- (void) serviceDidReceaveError:(id)error;

- (void) serviceDidDisconect;

@end