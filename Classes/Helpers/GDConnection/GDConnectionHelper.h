//
//
//

#import <Foundation/Foundation.h>


@interface GDConnectionHelper : NSObject {
	BOOL connectionAvailable;
	BOOL inBackground;
	BOOL inactive;
}
@property (nonatomic) BOOL connectionAvailable;
@property (nonatomic) BOOL inBackground;
@property (nonatomic) BOOL inactive;
+ (GDConnectionHelper*)instance;
@end
