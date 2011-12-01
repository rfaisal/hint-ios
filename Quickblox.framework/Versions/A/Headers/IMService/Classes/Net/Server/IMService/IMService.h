//
//  IMService.h
//  Mobserv
//
//  Created by Andrey Kozlov on 3/17/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface IMService : BaseService {
    
}

+ (void) setGlobalDelegate:(NSObject<IMServiceDelegate>*)delegate;
+ (void) setCommonPassword:(NSString*)password;
+ (void) setAppIdentificator:(NSString*)appID;

+ (void) connectWithUserName:(NSString*)userName;
+ (void) registrUserWithName:(NSString*)userName;

+ (void) goOnline;
+ (void) goOffline;

+ (void) sendMessage:(MBIMMessage*)message;

+ (void) disconnect;

@end
