//
//  QBHighscoreService.h
//  Mobserv
//
//  Created by Andrey Kozlov on 4/13/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface QBHighscoreService : BaseService {
    
}

#pragma mark Add Game Mode

+ (NSObject<Cancelable>*) addGameModeWithAppID:(NSUInteger)appId 
                                         title:(NSString*)title 
                                      delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*) addGameModeWithAppID:(NSUInteger)appId 
                                         title:(NSString*)title 
                                      delegate:(NSObject<ActionStatusDelegate>*)delegate 
                                       context:(void*)context;

#pragma mark Delete Game Mode

+ (NSObject<Cancelable>*) deleteGameModeWithID:(NSUInteger)gameModeId
                                      delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*) deleteGameModeWithID:(NSUInteger)gameModeId
                                      delegate:(NSObject<ActionStatusDelegate>*)delegate 
                                       context:(void*)context;

#pragma mark Add Score

+ (NSObject<Cancelable>*) addScoreWithUserID:(NSUInteger)userId 
                                 forGameMode:(NSUInteger)gameModeId 
                                   withValue:(NSUInteger)value 
                                    delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*) addScoreWithUserID:(NSUInteger)userId 
                                 forGameMode:(NSUInteger)gameModeId 
                                   withValue:(NSUInteger)value 
                                    delegate:(NSObject<ActionStatusDelegate>*)delegate 
                                     context:(void*)context;

#pragma mark Edit Score

+ (NSObject<Cancelable>*) editScoreWithID:(NSUInteger)scoreId 
								 newValue:(NSUInteger)value
                                 delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*) editScoreWithID:(NSUInteger)scoreId 
								 newValue:(NSUInteger)value
								 delegate:(NSObject<ActionStatusDelegate>*)delegate 
								  context:(void*)context;

#pragma mark Averages

+ (NSObject<Cancelable>*) getAveragesForApp:(NSUInteger)appId
							   withDelegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*) getAveragesForApp:(NSUInteger)appId
							   withDelegate:(NSObject<ActionStatusDelegate>*)delegate 
                                          context:(void*)context;


@end
