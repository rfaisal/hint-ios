//
//  QBNGetTokenPerformer.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNGetTokenPerformer : QBApplicationRedelegate<Perform,Cancelable> {
	NSObject<ActionStatusDelegate>* performDelegate;
	VoidWrapper* context;
	NSTimer* timeoutTimer;
	NSThread* workThread;
	NSRecursiveLock* canceledLock;
	NSString* testToken;
    
	BOOL completed;
	BOOL isCanceled;
}
@property (nonatomic,assign) NSObject<ActionStatusDelegate>* performDelegate;
@property (nonatomic,retain) VoidWrapper* context;
@property (nonatomic,retain) NSTimer* timeoutTimer;
@property (nonatomic,retain) NSThread* workThread;
@property (nonatomic,retain) NSRecursiveLock* canceledLock;
@property (nonatomic,retain) NSString* testToken;

@property (nonatomic) BOOL completed;
@property (nonatomic) BOOL isCanceled;

- (void)actionInBg;
- (void)performAction;

- (void)tokenRequestTimedOut:(NSTimer*)timer;
- (void)giveTestToken;
@end
