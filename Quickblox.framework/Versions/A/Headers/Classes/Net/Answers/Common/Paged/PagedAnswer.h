//
//  PagedAnswer.h
//  GeoposService
//
//

#import <Foundation/Foundation.h>


@interface PagedAnswer : XmlAnswer {
	NSUInteger pages;
}

@property (nonatomic) NSUInteger pages;



@end
