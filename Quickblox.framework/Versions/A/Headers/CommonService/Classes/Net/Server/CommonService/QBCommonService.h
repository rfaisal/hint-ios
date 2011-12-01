//
//  QBCommonService.h
//  CommonServiceClient
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBCommonService : BaseService {

}
+(NSObject<Cancelable>*)CreateDeviceAsync:(QBCDevice*)device withDelegate:(NSObject<ActionStatusDelegate>*)delegate;
+(NSObject<Cancelable>*)CreateDeviceAsync:(QBCDevice*)device withDelegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

+(NSObject<Cancelable>*)GetDeviceByIDAsync:(NSUInteger)deviceID withDelegate:(NSObject<ActionStatusDelegate>*)delegate;
+(NSObject<Cancelable>*)GetDeviceByIDAsync:(NSUInteger)deviceID withDelegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

@end
