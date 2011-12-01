//
//  QBHSAddGameModeAnswer.h
//  Mobserv
//
//  Created by Andrey Kozlov on 4/15/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface QBHSAddGameModeAnswer : QBHighscoreServiceAnswer {
    NSUInteger gameModeId;
}

@property (nonatomic) NSUInteger gameModeId;

@end
