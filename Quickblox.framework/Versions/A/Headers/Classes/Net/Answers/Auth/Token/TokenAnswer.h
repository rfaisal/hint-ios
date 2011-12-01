//
//  TokenAnswer.h
//  BaseService
//
//

#import <Foundation/Foundation.h>


@interface TokenAnswer : XmlAnswer {
	NSString* token;
}
@property (nonatomic,readonly) NSString* token;
@end
