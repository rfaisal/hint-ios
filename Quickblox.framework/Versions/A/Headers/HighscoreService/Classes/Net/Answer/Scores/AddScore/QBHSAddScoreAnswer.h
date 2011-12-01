//
//  QBHSAddScoreQuery.h
//  Mobserv
//
//  Created by Andrey Kozlov on 4/15/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface QBHSAddScoreAnswer : QBHighscoreServiceAnswer {
	QBHSScore *score;
}

@property (nonatomic, retain) QBHSScore *score;

@end
