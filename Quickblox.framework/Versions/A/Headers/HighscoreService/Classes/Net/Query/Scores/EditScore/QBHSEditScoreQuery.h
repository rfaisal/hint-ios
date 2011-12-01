//
//  QBHSEditScoreQuery.h
//  Mobserv
//
//  Created by Andrey Kozlov on 4/15/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface QBHSEditScoreQuery : QBHighscoreServiceQuery {
	NSUInteger scoreId;
	NSUInteger newValue;
}

@property (nonatomic) NSUInteger scoreId;
@property (nonatomic) NSUInteger newValue;

- (id) initWithScoreID:(NSUInteger)score_id newValue:(NSUInteger)value;

@end
