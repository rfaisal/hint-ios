//
//  QBHSDeleteGameMode.h
//  Mobserv
//
//  Created by Andrey Kozlov on 4/15/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface QBHSDeleteGameMode : QBHighscoreServiceQuery {
	NSUInteger gameModeId;
}

@property (nonatomic) NSUInteger gameModeId;

- (id) initWithGameModeID:(NSUInteger)game_mode_id;

@end
