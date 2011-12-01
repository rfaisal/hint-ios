//
//  QBNDeviceTokenAnswer.h
//  BaseServiceStaticLibrary
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNDeviceTokenAnswer : QBNotifierServiceAnswer {

}
@property (nonatomic,readonly) QBNDeviceToken* deviceToken;
@end
