//
//  QBHSGetAveragesQuery.h
//  Mobserv
//
//  Created by Andrey Kozlov on 4/15/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface QBHSGetAveragesAnswer : QBHighscoreServiceAnswer {
    NSMutableArray *averages;
}

@property (nonatomic, retain) NSMutableArray *averages;

@end
