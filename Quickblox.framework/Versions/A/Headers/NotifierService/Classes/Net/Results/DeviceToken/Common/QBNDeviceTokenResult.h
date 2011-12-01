//
//  QBNDeviceTokenResult.h
//  BaseServiceStaticLibrary
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNDeviceTokenResult : QBNotifierServiceResult {

}
@property (nonatomic,readonly) QBNDeviceToken* deviceToken;
@end
