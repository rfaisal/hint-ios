/*
 *  BaseServicePublicFramework.h
 *  BaseService
 *
 *
 */

#import "GeoposServicePublicFramework.h"
#import "BlobsServicePublicFramework.h"

//Error handling related
extern NSString* const kBaseServiceErrorDomain;
extern NSString* const kBaseServiceErrorKeyDescription;
extern NSString* const kBaseServiceErrorKeyInner;
extern NSString* const kBaseServiceException;

//Common Errors
extern NSString* const kBaseServiceErrorNotFound;
extern NSString* const kBaseServiceErrorValidation;
extern NSString* const kBaseServiceErrorUnauthorized;
extern NSString* const kBaseServiceErrorUnexpectedStatus;
extern NSString* const kBaseServiceErrorUnexpectedContentType;
extern NSString* const kBaseServiceErrorUnknownContentType;

enum BaseServiceErrorType {
	BaseServiceErrorTypeUnknown = 0,
	BaseServiceErrorTypeValidation,
	BaseServiceErrorTypeParse,
	BaseServiceErrorTypeConnection,
	BaseServiceErrorTypeServer
};

//Result
@interface Result : NSObject {}
@property (nonatomic,readonly) NSArray* errors;
@property (nonatomic,readonly) BOOL success;
@end
@protocol Cancelable
-(void)cancel;
@end
@protocol ActionStatusDelegate
-(void)completedWithResult:(Result*)result;
@optional
-(void)setProgress:(float)progress;
@end