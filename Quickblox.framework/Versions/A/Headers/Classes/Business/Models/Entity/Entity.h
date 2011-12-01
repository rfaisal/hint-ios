//
//  Entity.h
//  GeoposService
//
//

#import <Foundation/Foundation.h>


@interface Entity : NSObject {
	
	NSDate* createdAt;
	NSDate* updatedAt;
@private
	BOOL autosave;
	NSUInteger ID;
}
@property (nonatomic) NSUInteger ID;
@property (nonatomic) BOOL autosave;
@property (nonatomic,retain) NSDate* createdAt;
@property (nonatomic,retain) NSDate* updatedAt;
-(BOOL)create;
-(BOOL)save;
-(BOOL)destroy;
-(BOOL)refresh;
-(void)changed;
@end
