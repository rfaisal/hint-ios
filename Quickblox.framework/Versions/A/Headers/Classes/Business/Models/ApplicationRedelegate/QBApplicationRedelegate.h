//
//  QBApplicationRedelegate.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIApplicationDelegate42<UIApplicationDelegate>

@optional
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end


@interface QBApplicationRedelegate : NSObject<UIApplicationDelegate> {
	NSObject<UIApplicationDelegate42>* delegate;
	UIApplication* app;
}
@property (nonatomic,retain) NSObject<UIApplicationDelegate42>* delegate;
@property (nonatomic,assign) UIApplication* app;

+ (QBApplicationRedelegate*)redelegate:(UIApplication*)application;
+ (QBApplicationRedelegate*)redelegateCurrentApplication;
@end
