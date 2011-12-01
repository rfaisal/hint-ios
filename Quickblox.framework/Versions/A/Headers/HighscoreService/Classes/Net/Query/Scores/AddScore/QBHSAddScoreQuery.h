//
//  QBHSAddScoreQuery.h
//  Mobserv
//
//  Created by Andrey Kozlov on 4/15/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface QBHSAddScoreQuery : QBHighscoreServiceQuery {
    NSUInteger userId;
    NSUInteger gameModeId;
    NSUInteger value;
}

@property (nonatomic) NSUInteger userId;
@property (nonatomic) NSUInteger gameModeId;
@property (nonatomic) NSUInteger value;

- (id) initWithUser:(NSUInteger) user_id gameMode:(NSUInteger)gameMode_id value:(NSUInteger)_value;

@end
