//
//  QBHSGetAveragesQuery.h
//  Mobserv
//
//  Created by Andrey Kozlov on 4/15/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface QBHSGetAveragesQuery : QBHighscoreServiceQuery {
    NSUInteger appId;
}

@property (nonatomic, assign) NSUInteger appId;

- (id) initWithAppId:(NSUInteger)app_id;

@end
