//
//  Result.h
//  GeoposService
//
//

#import <Foundation/Foundation.h>


@interface Result : NSObject {
	Request* request;
	Answer* answer;
	
}
@property (nonatomic,retain) Request* request;
@property (nonatomic,retain) Answer* answer;
@property (nonatomic,readonly) NSArray* errors;
@property (nonatomic,readonly) BOOL success;
-(id)initWithRequest:(Request*)req answer:(Answer*)answ;
-(id)initWithAnswer:(Answer*)answ;
@end
