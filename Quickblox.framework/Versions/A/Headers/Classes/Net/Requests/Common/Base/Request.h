//
//  Request.h
//  GeoposService
//
//

#import <Foundation/Foundation.h>

@class Result;
@interface Request : NSObject {

}
@property (nonatomic,readonly) NSDictionary* parameters;
@property (nonatomic,readonly) NSString* urlPostfix;
-(Result*)perform;
@end
