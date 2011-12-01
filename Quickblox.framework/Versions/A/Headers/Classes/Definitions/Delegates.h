/*
 *  Delegates.h
 *  DocNog
 *
 *
 */
@protocol StatusReporter

-(void)progress:(int)progress;
-(void)result:(id)result;
-(void)error:(NSError*)error;

@end
@protocol Progressable

-(void)progress:(int)progress;

@end

@protocol Cancelable
-(void)cancel;
@end

@class Result;
@protocol ActionStatusDelegate
-(void)completedWithResult:(Result*)result;
@optional
-(void)completedWithResult:(Result*)result context:(void*)contextInfo;
-(void)setProgress:(float)progress;
-(void)setUploadProgress:(float)progress;
@end

@protocol ProgressDelegate
-(void)setProgress:(float)progress;
@end

@protocol LoadProgressDelegate
-(void)setUploadProgress:(float)progress;
-(void)setDownloadProgress:(float)progress;
@optional
-(void)setProgress:(float)progress;
@end

@class RestResponse;
@protocol RestRequestDelegate<LoadProgressDelegate>
-(void)completedWithResponse:(RestResponse*)response;
@end

@class RestAnswer;
@protocol QueryDelegate
-(void)completedWithAnswer:(RestAnswer*)answer;
@optional
-(void)setProgress:(float)progress;
@end

@protocol Perform
-(Result*)perform;
-(NSObject<Cancelable>*)performAsyncWithDelegate:(NSObject<ActionStatusDelegate>*)delegate;
-(NSObject<Cancelable>*)performAsyncWithDelegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;
@end