//
//  EncodeHelper.h
//  Mobserv
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EncodeHelper : NSObject {

}
+(NSString*)urlencode:(NSString*)unencodedString;
+(NSString*)urldecode:(NSString*)encodedString;
@end
